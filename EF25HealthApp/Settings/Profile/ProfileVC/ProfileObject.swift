//
//  ProfileObject.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 29/6/25.
//
import Foundation
import UIKit
//import RealmSwift
//
//class Profile: Object {
//    @Persisted var firstName: String
//    @Persisted var lastName: String
//    @Persisted var gender: String
//    @Persisted var weight: Double
//    @Persisted var height: Double
//   
//    var fullName: String {
//        firstName + " " + lastName
//    }
//    
//    var bmi: Double {
//        weight / pow(height / 100, 2)
//    }
//}
struct Profile: Codable {
    let firstName: String
    let lastName: String
    let gender: String
    let weight: Double
    let height: Double
    let age: Int
    var fullName: String {
        firstName + " " + lastName
    }
    var bmi: Double
    {
        weight / pow(height / 100, 2)
    }

}

