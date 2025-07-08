//
//  ProfileObject.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 29/6/25.
//
import Foundation

struct Profile: Codable {
    let firstName: String
    let lastName: String
    let gender: String
    let weight: Double
    let height: Double
    var fullName: String {
        firstName + " " + lastName
    }
    var bmi: Double
    {
        weight / pow(height / 100, 2)
    }

}
