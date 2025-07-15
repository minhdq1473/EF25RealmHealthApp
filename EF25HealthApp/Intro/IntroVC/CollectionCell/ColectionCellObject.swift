//
//  CellObject.swift
//  EF25HealthPlanApp
//
//  Created by iKame Elite Fresher 2025 on 3/7/25.
//
import Foundation
import UIKit

struct collectionCellItem {
    let title: String
    let image: UIImage
}
let item1: [collectionCellItem] = [
    collectionCellItem(title: "Heart Rate", image: UIImage(named: "heart-rate")!),
    collectionCellItem(title: "High Blood Pressure", image: UIImage(named: "hypertension")!),
    collectionCellItem(title: "Stress & Anxiety", image: UIImage(named: "stress")!),
    collectionCellItem(title: "Low Energy Levels", image: UIImage(named: "energy")!),
]
let item2: [collectionCellItem] = [
    collectionCellItem(title: "Improve Heart Health", image: UIImage(named: "dumbbell")!),
    collectionCellItem(title: "Improve blood pressure health", image: UIImage(named: "pressure")!),
    collectionCellItem(title: "Reduce Stress", image: UIImage(named: "harmony")!),
    collectionCellItem(title: "Increase Energy Levels", image: UIImage(named: "energy-up")!),
]
let item3: [collectionCellItem] = [
    collectionCellItem(title: "Educational Plan", image: UIImage(named: "plan")!),
    collectionCellItem(title: "Exercise Plan", image: UIImage(named: "exercise-plan")!),
    collectionCellItem(title: "Health Tests", image: UIImage(named: "stress-test")!),
]

