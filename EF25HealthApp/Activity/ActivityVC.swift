//
//  ActivityVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 19/8/25.
//

import UIKit
import Combine

class ActivityVC: UIViewController {
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartContainerView: UIView!

    private var trendChartView: LineChartView?
    private var cancellables = Set<AnyCancellable>()
    private let healthKit = HealthKitManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setUpTitle()
        setupHealthKitObservers()
        checkHealthKitAuthorization()
        setupChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkHealthKitAuthorization()
    }
    
    private func setupHealthKitObservers() {
        healthKit.$isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthorized in
                self?.handleAuthorizationChange(isAuthorized)
            }
            .store(in: &cancellables)
        
        healthKit.$todaySteps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] steps in
                self?.updateStepsDisplay(steps)
            }
            .store(in: &cancellables)
        
        healthKit.$todayCalories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] calories in
                self?.updateCaloriesDisplay(calories)
            }
            .store(in: &cancellables)
        
        healthKit.$todayDistance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distance in
                self?.updateDistanceDisplay(distance)
            }
            .store(in: &cancellables)
        
        healthKit.$todayExerciseMinutes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] minutes in
                self?.updateExerciseDisplay(minutes)
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthorizationChange(_ isAuthorized: Bool) {
        if isAuthorized {
            requestBtn.isHidden = true
            loadWeeklyChart()
        } else {
            showNoDataState()
            requestBtn.isHidden = false
        }
    }
    
    private func checkHealthKitAuthorization() {
        if healthKit.isHealthKitAvailable() {
            healthKit.needsActivityDataAuthorization { [weak self] needsAuth in
                DispatchQueue.main.async {
                    if needsAuth {
                        self?.requestBtn.isHidden = false
                        self?.showNoDataState()
                    } else {
                        self?.requestBtn.isHidden = true
                        self?.healthKit.requestAuthorization { success, _ in
                            if success {
                                self?.loadWeeklyChart()
                            }
                        }
                    }
                }
            }
        } else {
            showHealthKitNotAvailableAlert()
            requestBtn.isHidden = true
        }
    }
    
    @IBAction func requestBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Permissions Required", message: "To access health data, please enable permissions in Settings > Privacy & Security > Health", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func updateStepsDisplay(_ steps: Double) {
        let formattedSteps = Int(steps).formatted()
        activityData[0].value = formattedSteps
        collectionView?.reloadData()
    }
    
    private func updateCaloriesDisplay(_ calories: Double) {
        let formattedCalories = Int(calories).formatted()
        activityData[1].value = formattedCalories
        collectionView?.reloadData()
    }
    
    private func updateDistanceDisplay(_ distance: Double) {
        let distanceKm = distance / 1000 // Convert meters to kilometers
        let formattedDistance = String(format: "%.2f", distanceKm)
        activityData[2].value = formattedDistance
        collectionView?.reloadData()
    }
    
    private func updateExerciseDisplay(_ minutes: Double) {
        let formattedMinutes = Int(minutes).formatted()
        activityData[3].value = formattedMinutes
        collectionView?.reloadData()
    }
    
    private func showNoDataState() {
        updateStepsDisplay(0)
        updateCaloriesDisplay(0)
        updateDistanceDisplay(0)
        updateExerciseDisplay(0)
    }
    
    private func showHealthKitNotAvailableAlert() {
        let alert = UIAlertController(
            title: "HealthKit Not Available",
            message: "HealthKit is not available on this device.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Permissions Required",
            message: "To access health data, please enable permissions in Settings > Privacy & Security > Health",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellWithReuseIdentifier: "ActivityCell")
    }
    
    
    func setUpTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Activity"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textColor = UIColor.neutral1
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    

    private func setupChart() {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(chart)
        NSLayoutConstraint.activate([
            chart.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor),
            chart.topAnchor.constraint(equalTo: chartContainerView.topAnchor),
            chart.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor)
        ])
        trendChartView = chart
        loadWeeklyChart()
    }

    private func loadWeeklyChart() {
        HealthKitManager.shared.fetchLast7DaysSteps { [weak self] points in
            self?.trendChartView?.setData(points: points)
        }
    }
}

extension ActivityVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        let item = activityData[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

extension ActivityVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 2
        return CGSize(width: width, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
