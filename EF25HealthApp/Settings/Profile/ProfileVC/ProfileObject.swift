//
//  ProfileObject.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 29/6/25.
//
import Foundation

struct Profile {
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
    
    func addProfile() {
        
    }
    
    func updateProfile(firstName: String,lastName: String, gender: String, weight: Double, height: Double) -> Profile {
        Profile(firstName: firstName, lastName: lastName, gender: gender, weight: weight, height: height)
    }
    
    func deleteProfile() -> Profile {
        Profile(firstName: "", lastName: "", gender: "", weight: 0, height: 0)
    }

}
