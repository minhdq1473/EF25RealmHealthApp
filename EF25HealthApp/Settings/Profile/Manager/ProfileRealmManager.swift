//
//  ProfileRealmManager.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 13/8/25.
//

import Foundation
import RealmSwift

class ProfileRealmManager {
    static let shared = ProfileRealmManager()
    private let realm: Realm
        
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func save(_ firstName: String, _ lastName: String, _ gender: String, _ weight: Double, _ height: Double) {
        let profile = Profile()
        profile.firstName = firstName
        profile.lastName = lastName
        profile.gender = gender
        profile.weight = weight
        profile.height = height
        
        do {
            try realm.write {
                realm.add(profile)
            }
        } catch {
            print(error)
        }
    }
    
    func delete() {
        guard let profile = realm.objects(Profile.self).first else { return }
        do {
            try realm.write {
                realm.delete(profile)
            }
        } catch {
            print(error)
        }
    }
    
    func update(id: ObjectId, pulse: Int, hrv: Int) {
        guard let profile = realm.objects(Profile.self).first else { return }

        do {
            try realm.write {
                
            }
        } catch {
            print(error)
        }
    }
    
    func getProfile() -> Profile {
        let profile = realm.objects(Profile.self).first
        return profile
    }
}
