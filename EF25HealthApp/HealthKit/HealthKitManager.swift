//
//  HealthKitManager.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 19/8/25.
//

import Foundation
import HealthKit
import Combine

final class HealthKitManager {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()
    
    @Published var currentProfile: Profile? = nil
    @Published var isAuthorized: Bool = false
    @Published var todaySteps: Double = 0
    @Published var todayDistance: Double = 0
    @Published var todayCalories: Double = 0
    @Published var todayExerciseMinutes: Double = 0
    
    private var activeObserverQueries: [HKQuery] = []

    private init() {}

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device"]))
            return
        }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
        ]
        
        let typesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    self.isAuthorized = false
                    completion(false, error)
                    return
                }
                self.isAuthorized = success
                if success {
                    self.startSync()
                }
                completion(success, nil)
            }
        }
    }
    
    func needsActivityDataAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            DispatchQueue.main.async { completion(true) }
            return
        }
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]
        healthStore.getRequestStatusForAuthorization(toShare: [], read: readTypes) { status, _ in
            DispatchQueue.main.async { completion(status != .unnecessary) }
        }
    }
    
    func startSync() {
        guard isAuthorized else { return }
        
        fetchInitialProfileData()
        fetchTodayActivityData()
        
        startObservingHealthKitChanges()
    }
    
    private func fetchInitialProfileData() {
        var firstName = "User"
        var lastName = ""
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let savedProfile = try? JSONDecoder().decode(Profile.self, from: data) {
            firstName = savedProfile.firstName
            lastName = savedProfile.lastName
        }
        
        let baseProfile = Profile(firstName: firstName, lastName: lastName, gender: "Not specified", weight: 0, height: 0, age: 0)
        currentProfile = baseProfile

        fetchLatestWeightKg { [weak self] fetchedWeight in
            guard let self = self, let w = fetchedWeight else { return }
            if let currentProfile = self.currentProfile {
                let updatedProfile = Profile(
                    firstName: currentProfile.firstName,
                    lastName: currentProfile.lastName,
                    gender: currentProfile.gender,
                    weight: w,
                    height: currentProfile.height,
                    age: currentProfile.age
                )
                self.currentProfile = updatedProfile
            }
        }

        fetchLatestHeightCm { [weak self] fetchedHeight in
            guard let self = self, let h = fetchedHeight else { return }
            if let currentProfile = self.currentProfile {
                let updatedProfile = Profile(
                    firstName: currentProfile.firstName,
                    lastName: currentProfile.lastName,
                    gender: currentProfile.gender,
                    weight: currentProfile.weight,
                    height: h,
                    age: currentProfile.age
                )
                self.currentProfile = updatedProfile
            }
        }

        fetchBiologicalSex { [weak self] sex in
            guard let self = self else { return }
            let gender: String
            switch sex {
            case .male: gender = "Male"
            case .female: gender = "Female"
            case .other: gender = "Other"
            default: gender = "Not specified"
            }
            if let currentProfile = self.currentProfile {
                let updatedProfile = Profile(
                    firstName: currentProfile.firstName,
                    lastName: currentProfile.lastName,
                    gender: gender,
                    weight: currentProfile.weight,
                    height: currentProfile.height,
                    age: currentProfile.age
                )
                self.currentProfile = updatedProfile
            }
        }

        fetchDateOfBirth { [weak self] dob in
            guard let self = self, let dob = dob else { return }
            let age = self.calculateAge(from: dob)
            if let currentProfile = self.currentProfile {
                let updatedProfile = Profile(
                    firstName: currentProfile.firstName,
                    lastName: currentProfile.lastName,
                    gender: currentProfile.gender,
                    weight: currentProfile.weight,
                    height: currentProfile.height,
                    age: age
                )
                self.currentProfile = updatedProfile
            }
        }
    }
    
    private func fetchTodayActivityData() {
        fetchTodaySteps { [weak self] steps in
            self?.todaySteps = steps
        }
        
        fetchTodayDistanceMeters { [weak self] distance in
            self?.todayDistance = distance
        }
        
        fetchTodayActiveEnergyCalories { [weak self] calories in
            self?.todayCalories = calories
        }
        
        fetchTodayAppleExerciseMinutes { [weak self] minutes in
            self?.todayExerciseMinutes = minutes
        }
    }
    
    private func startObservingHealthKitChanges() {
        guard isAuthorized else { return }

        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!

        setupObserver(for: weightType, anchorKey: nil)
        setupObserver(for: heightType, anchorKey: nil)
        
        setupActivityObservers()
    }
    
    private func setupObserver(for sampleType: HKSampleType, anchorKey: String?) {
        let observer = HKObserverQuery(sampleType: sampleType, predicate: nil) { [weak self] _, completionHandler, error in
            if let qType = sampleType as? HKQuantityType {
                switch qType.identifier {
                case HKQuantityTypeIdentifier.bodyMass.rawValue:
                    self?.handleProfileUpdates(for: sampleType)
                case HKQuantityTypeIdentifier.height.rawValue:
                    self?.handleProfileUpdates(for: sampleType)
                default:
                    break
                }
            }
            completionHandler()
        }

        healthStore.execute(observer)
        activeObserverQueries.append(observer)

        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { success, error in }
    }
    
    private func setupActivityObservers() {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let exerciseType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        
        let activityTypes = [stepType, distanceType, caloriesType, exerciseType]
        
        for type in activityTypes {
            let observer = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completionHandler, error in
                self?.fetchTodayActivityData()
                completionHandler()
            }
            
            healthStore.execute(observer)
            activeObserverQueries.append(observer)
        }
    }
        
    private func handleProfileUpdates(for sampleType: HKSampleType) {
        guard let currentProfile = currentProfile else { return }
        
        if let quantityType = sampleType as? HKQuantityType {
            switch quantityType.identifier {
            case HKQuantityTypeIdentifier.bodyMass.rawValue:
                fetchLatestWeightKg { [weak self] w in
                    guard let self = self, let w = w else { return }
                    let updatedProfile = Profile(
                        firstName: currentProfile.firstName,
                        lastName: currentProfile.lastName,
                        gender: currentProfile.gender,
                        weight: w,
                        height: currentProfile.height,
                        age: currentProfile.age
                    )
                    self.currentProfile = updatedProfile
                }
            case HKQuantityTypeIdentifier.height.rawValue:
                fetchLatestHeightCm { [weak self] h in
                    guard let self = self, let h = h else { return }
                    let updatedProfile = Profile(
                        firstName: currentProfile.firstName,
                        lastName: currentProfile.lastName,
                        gender: currentProfile.gender,
                        weight: currentProfile.weight,
                        height: h,
                        age: currentProfile.age
                    )
                    self.currentProfile = updatedProfile
                }
            default:
                break
            }
        }
    }
    
    func updateWeightInHealthApp(weight: Double) {
        guard isAuthorized else { return }
        
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight)
        let weightSample = HKQuantitySample(type: weightType, quantity: weightQuantity, start: Date(), end: Date())
        
        healthStore.save(weightSample) { success, error in }
    }
    
    func updateHeightInHealthApp(height: Double) {
        guard isAuthorized else { return }
        
        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let heightQuantity = HKQuantity(unit: HKUnit.meterUnit(with: .centi), doubleValue: height)
        let heightSample = HKQuantitySample(type: heightType, quantity: heightQuantity, start: Date(), end: Date())
        
        healthStore.save(heightSample) { success, error in }
    }
    
    func updateUserProfile(_ profile: Profile) {
        if let profileData = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(profileData, forKey: "userProfile")
        }
        
        currentProfile = profile
        
        updateWeightInHealthApp(weight: profile.weight)
        updateHeightInHealthApp(height: profile.height)
    }
    
    private func fetchMostRecentSample(for identifier: HKQuantityTypeIdentifier, completion: @escaping (HKSample?) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: identifier) else {
            completion(nil)
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            completion(samples?.first)
        }
        healthStore.execute(query)
    }
    
    private func calculateAge(from dateOfBirth: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year ?? 0
    }
    
 
    
//    func stopObservingHealthKitChanges() {
//        for query in activeObserverQueries {
//            healthStore.stop(query)
//        }
//        activeObserverQueries.removeAll()
//    }
    
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
//    func checkAuthorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus {
//        return healthStore.authorizationStatus(for: type)
//    }
    
    

    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }
        executeCumulativeQuery(for: type, unit: .count(), completion: completion)
    }

    func fetchTodayDistanceMeters(completion: @escaping (Double) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(0)
            return
        }
        executeCumulativeQuery(for: type, unit: .meter(), completion: completion)
    }

    func fetchTodayActiveEnergyCalories(completion: @escaping (Double) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(0)
            return
        }
        executeCumulativeQuery(for: type, unit: .kilocalorie(), completion: completion)
    }

    func fetchTodayAppleExerciseMinutes(completion: @escaping (Double) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(0)
            return
        }
        executeCumulativeQuery(for: type, unit: .minute(), completion: completion)
    }
    

    func fetchLatestWeightKg(completion: @escaping (Double?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .bodyMass) else { completion(nil); return }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: .gramUnit(with: .kilo))
            DispatchQueue.main.async { completion(value) }
        }
        healthStore.execute(query)
    }

    func fetchLatestHeightCm(completion: @escaping (Double?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .height) else { completion(nil); return }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: .meterUnit(with: .centi))
            DispatchQueue.main.async { completion(value) }
        }
        healthStore.execute(query)
    }

    func fetchDateOfBirth(completion: @escaping (Date?) -> Void) {
        do {
            let components = try healthStore.dateOfBirthComponents()
            DispatchQueue.main.async { completion(components.date) }
        } catch {
            DispatchQueue.main.async { completion(nil) }
        }
    }

    func fetchBiologicalSex(completion: @escaping (HKBiologicalSex?) -> Void) {
        do {
            let sex = try healthStore.biologicalSex().biologicalSex
            DispatchQueue.main.async { completion(sex) }
        } catch {
            DispatchQueue.main.async { completion(nil) }
        }
    }
    
    private func executeCumulativeQuery(for type: HKQuantityType, unit: HKUnit, completion: @escaping (Double) -> Void) {
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let value = result?.sumQuantity()?.doubleValue(for: unit) ?? 0
            DispatchQueue.main.async { completion(value) }
        }
        healthStore.execute(query)
    }

    func savePulseBPM(_ bpm: Double, date: Date = Date(), completion: @escaping (Bool, Error?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, NSError(domain: "HealthKit", code: 10, userInfo: [NSLocalizedDescriptionKey: "Heart Rate type not available"]))
            return
        }
        let quantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: bpm)
        let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
        healthStore.save(sample) { success, error in
            DispatchQueue.main.async { completion(success, error) }
        }
    }

    func saveHRVms(_ ms: Double, date: Date = Date(), completion: @escaping (Bool, Error?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(false, NSError(domain: "HealthKit", code: 11, userInfo: [NSLocalizedDescriptionKey: "HRV SDNN type not available"]))
            return
        }
        let quantity = HKQuantity(unit: .secondUnit(with: .milli), doubleValue: ms)
        let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
        healthStore.save(sample) { success, error in
            DispatchQueue.main.async { completion(success, error) }
        }
    }

    func fetchDailySum(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, days: Int = 7, completion: @escaping ([(Date, Double)]) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            completion([])
            return
        }
        let calendar = Calendar.current
        let now = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: calendar.startOfDay(for: now)) else {
            completion([])
            return
        }
        var interval = DateComponents()
        interval.day = 1
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)

        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: calendar.startOfDay(for: now), intervalComponents: interval)

        query.initialResultsHandler = { _, results, _ in
            var dataPoints: [(Date, Double)] = []
            if let results = results {
                let endDate = now
                results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let sum = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0
                    let day = statistics.startDate
                    dataPoints.append((day, sum))
                }
            }
            DispatchQueue.main.async { completion(dataPoints) }
        }
        healthStore.execute(query)
    }
    
    func fetchLast7DaysSteps(completion: @escaping ([(Date, Double)]) -> Void) {
        fetchDailySum(for: .stepCount, unit: .count(), days: 7, completion: completion)
    }
    
    func fetchLast7DaysDistanceMeters(completion: @escaping ([(Date, Double)]) -> Void) {
        fetchDailySum(for: .distanceWalkingRunning, unit: .meter(), days: 7, completion: completion)
    }
    
    func fetchLast7DaysActiveEnergyCalories(completion: @escaping ([(Date, Double)]) -> Void) {
        fetchDailySum(for: .activeEnergyBurned, unit: .kilocalorie(), days: 7, completion: completion)
    }
    
    func fetchLast7DaysExerciseMinutes(completion: @escaping ([(Date, Double)]) -> Void) {
        fetchDailySum(for: .appleExerciseTime, unit: .minute(), days: 7, completion: completion)
    }
}
