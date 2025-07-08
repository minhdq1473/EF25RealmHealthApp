//
//  SettingsCellObject.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 4/7/25.
//

import Foundation
import UIKit

struct SettingsItem {
    var title: String
    var icon: UIImage
}

let settingsSection: [[SettingsItem]] = [
    [
        SettingsItem(title: "Profile", icon: UIImage(named: "profile")!)
    ],
    [
        SettingsItem(title: "Daily Reminder", icon: UIImage(named: "notification")!),
        SettingsItem(title: "Change App Icon", icon: UIImage(named: "category")!),
        SettingsItem(title: "Language", icon: UIImage(named: "website")!)
    ],
    [
        SettingsItem(title: "Rate Us", icon: UIImage(named: "like")!),
        SettingsItem(title: "Feedback", icon: UIImage(named: "message")!),
        SettingsItem(title: "Privacy Policy", icon: UIImage(named: "shield")!),
        SettingsItem(title: "Term of User", icon: UIImage(named: "document")!)
    ]
]

    

