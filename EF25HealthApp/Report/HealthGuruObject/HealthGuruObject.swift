//
//  HealthGuruObject.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import Foundation
import UIKit
import RealmSwift

class HealthGuru: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var pulse: Int
    @Persisted var HRV: Int
    @Persisted var status: status
    @Persisted var timestamp: Date = Date()

}

enum status: String, PersistableEnum {
    case good = "Good"
    case low = "Low"
    case warning = "Warning"
    
    var color: UIColor {
        switch self {
        case .good:
            return .accentNormal
        case .low:
            return .low
        case .warning:
            return .warning
        }
    }
    
    func getStatus(pulse: Int) -> status {
        switch pulse {
        case 0..<60:
            return .low
        case 60...100:
            return .good
        default:
            return .warning
        }
    }
}
