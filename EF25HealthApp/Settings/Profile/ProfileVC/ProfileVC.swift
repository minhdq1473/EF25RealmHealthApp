//
//  ProfileVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 24/6/25.
//

import UIKit
import HealthKit
import Combine

class ProfileVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var yourBMILabel: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var infoStack: UIStackView!
    
    var profile: Profile?
    var profileIndex: Int?
    
    private var cancellables = Set<AnyCancellable>()
    private let healthManager = HealthKitManager.shared
    
    private var firstName: String = ""
    private var lastName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupUI()
        setupBarButton()
        setupSwipeGesture()
        loadStoredNames()
        setupHealthKitObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI(with: healthManager.currentProfile)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
    
    func setupTitle() {
        title = "Profile"
    }
    
    func setupUI() {
        stack.layer.cornerRadius = 15
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func setupBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = .primary1
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .neutral2
    }
    
    func setupSwipeGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(swipeleft))
    }
    
    private func loadStoredNames() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let savedProfile = try? JSONDecoder().decode(Profile.self, from: data) {
            self.firstName = savedProfile.firstName
            self.lastName = savedProfile.lastName
        }
    }
    
    private func setupHealthKitObservers() {
        healthManager.$currentProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.updateUI(with: profile)
            }
            .store(in: &cancellables)
        
        healthManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthorized in
                guard let self else { return }
                if isAuthorized {
                    if self.healthManager.currentProfile == nil {
                        self.healthManager.startSync()
                    }
                    self.updateUI(with: self.healthManager.currentProfile)
                } else {
                    self.healthManager.requestAuthorization { success, _ in
                        if success {
                            self.healthManager.startSync()
                        } else {
                            DispatchQueue.main.async { self.showNoDataState() }
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        if healthManager.isAuthorized {
            updateUI(with: healthManager.currentProfile)
        } else {
            healthManager.requestAuthorization { [weak self] success, _ in
                if success {
                    self?.healthManager.startSync()
                } else {
                    DispatchQueue.main.async { self?.showNoDataState() }
                }
            }
        }
    }
    
    private func updateUI(with profile: Profile?) {
        
        guard let profile = profile else {
            showNoDataState()
            return
        }
        
        nameLabel.text = profile.fullName
        weightLabel.text = profile.weight > 0 ? String(format: "%.0f kg", profile.weight) : "-- kg"
        heightLabel.text = profile.height > 0 ? String(format: "%.0f cm", profile.height) : "-- cm"
        sexLabel.text = profile.gender
        ageLabel.text = profile.age > 0 ? "\(profile.age)" : "--"
        
        if profile.weight > 0 && profile.height > 0 {
            bmiLabel.text = String(format: "%.1f", profile.bmi)
        } else {
            bmiLabel.text = "--"
        }
        
    }
    
    private func showNoDataState() {
        nameLabel.text = "No Profile Data"
        weightLabel.text = "-- kg"
        heightLabel.text = "-- cm"
        sexLabel.text = "--"
        bmiLabel.text = "--"
        ageLabel.text = "--"
    }
    
    @objc func swipeleft(sender: UISwipeGestureRecognizer) {
        tabBarController?.isTabBarHidden = false
    }
   
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.isTabBarHidden = false
    }
    
    @objc func editButtonTapped() {
        let vc = InformationVC()
        vc.isEditingMode = true
        
        if let currentProfile = healthManager.currentProfile {
            vc.setCurrentProfile(currentProfile)
        } else {
            let defaultProfile = Profile(
                firstName: firstName.isEmpty ? "User" : firstName,
                lastName: lastName,
                gender: "unknown",
                weight: 70.0,
                height: 170.0,
                age: 25
            )
            vc.setCurrentProfile(defaultProfile)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
