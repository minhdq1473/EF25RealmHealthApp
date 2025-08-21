//
//  ActivityObject.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 20/8/25.
//

struct ActivityItem {
    let icon: String
    var value: String
    let unit: String
    let label: String
}

var activityData: [ActivityItem] = [
    ActivityItem(icon: "figure.walk", value: "0", unit: "steps", label: "Steps"),
    ActivityItem(icon: "flame.fill", value: "0", unit: "kcal", label: "Calories"),
    ActivityItem(icon: "location.circle.fill", value: "0.00", unit: "km", label: "Distance"),
    ActivityItem(icon: "timer", value: "0", unit: "minutes", label: "Active Time")
]

