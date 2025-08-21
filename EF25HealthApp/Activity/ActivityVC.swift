//
//  HealthTrackingVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 19/8/25.
//

import UIKit

final class ActivityVC: UIViewController {
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    private let stepsValueLabel = UILabel()
    private let distanceValueLabel = UILabel()
    private let caloriesValueLabel = UILabel()
    private let healthKit = HealthKitManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        buildUI()
        requestAndLoad()
        loadData()
        setUpTitle()
    }
    
    @IBAction func requestBtnTapped(_ sender: UIButton) {
        healthKit.requestAuthorization { success, error in
            if success {
                self.loadData()
            }
        }
    }
//    private func setUpUnauthorizedUI() {
//        let messageLabel = UILabel()
//        messageLabel.text = "Health data access is not authorized."
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = .center
//        view.addSubview(messageLabel)
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//    }
    func setUpTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Activity"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textColor = UIColor.neutral1
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
//    private func buildUI() {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.spacing = 16
//        stack.alignment = .fill
//
//        func makeRow(title: String, valueLabel: UILabel) -> UIStackView {
//            let titleLabel = UILabel()
//            titleLabel.text = title
//            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
//            valueLabel.text = "-"
//            valueLabel.textAlignment = .right
//            valueLabel.font = .systemFont(ofSize: 16)
//            let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
//            row.axis = .horizontal
//            row.spacing = 8
//            return row
//        }
//
//        let stepsRow = makeRow(title: "Steps Today", valueLabel: stepsValueLabel)
//        let distanceRow = makeRow(title: "Distance Today", valueLabel: distanceValueLabel)
//        let caloriesRow = makeRow(title: "Active Energy Today", valueLabel: caloriesValueLabel)
//
//        [stepsRow, distanceRow, caloriesRow].forEach { stack.addArrangedSubview($0) }
//
//        let container = UIStackView(arrangedSubviews: [stack])
//        container.axis = .vertical
//        container.spacing = 0
//        container.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(container)
//        NSLayoutConstraint.activate([
//            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
//        ])
//    }
//
    private func requestAndLoad() {
        HealthKitManager.shared.requestAuthorization { [weak self] granted, _ in
            guard let self else { return }
            if !granted {
                self.stepLabel.text = "Permission denied"
                self.distanceLabel.text = "Permission denied"
                self.caloriesLabel.text = "Permission denied"
                self.requestBtn.isHidden = false
                return
            }
            self.requestBtn.isHidden = true
            self.loadData()
        }
    }

    private func loadData() {
        HealthKitManager.shared.fetchTodaySteps { [weak self] steps in
            self?.stepLabel.text = String(Int(steps))
        }
        HealthKitManager.shared.fetchTodayDistanceMeters { [weak self] meters in
            let km = meters / 1000.0
            self?.distanceLabel.text = String(format: "%.2f km", km)
        }
        HealthKitManager.shared.fetchTodayActiveEnergyCalories { [weak self] calories in
            self?.caloriesLabel.text = String(format: "%.0f kcal", calories)
        }
    }
}

