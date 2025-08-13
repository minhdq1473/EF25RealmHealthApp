//
//  RealmManager.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 12/8/25.
//

import Foundation
import RealmSwift

class LogRealmManager {
    static let shared = LogRealmManager()
    private let realm: Realm
        
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func add(pulse: Int, hrv: Int) {
        let log = HealthGuru()
        log.pulse = pulse
        log.HRV = hrv
        log.status = status().getStatus(pulse: pulse)
        do {
            try realm.write {
                realm.add(log)
            }
        } catch {
            print(error)
        }
    }
    
    func remove(id: ObjectId) {
        guard let log = realm.objects(HealthGuru.self).where({ $0.id == id }).first else { return }
        do {
            try realm.write {
                realm.delete(log)
            }
        } catch {
            print(error)
        }
    }
    
    func update(id: ObjectId, pulse: Int, hrv: Int) {
        guard let log = realm.objects(HealthGuru.self).where({ $0.id == id }).first else { return }

        do {
            try realm.write {
                log.pulse = pulse
                log.HRV = hrv
                log.status = status().getStatus(pulse: pulse)
            }
        } catch {
            print(error)
        }
    }
    
    func getLogs() -> [HealthGuru] {
        let realmObjects = realm.objects(HealthGuru.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Array(realmObjects)
    }
}
