//
//  InformationVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 24/6/25.
//

import UIKit
import HealthKit

class InformationVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var view1: CustomView!
    @IBOutlet weak var view2: CustomView!
    @IBOutlet weak var view3: CustomView!
    @IBOutlet weak var view4: CustomView!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    var isEditingMode = false
    var currentProfile: Profile?
    
    private let healthManager = HealthKitManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupButton()
        setupTextField()
        setupBackButton()
        setupSwipeGesture()
        loadCurrentProfile()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let firstName = view1.getTextValue(),
              let lastName = view2.getTextValue(),
              let kg = view3.getTextValue(),
              let cm = view4.getTextValue() else { return }
        
        let genderValue: String = gender.titleForSegment(at: gender.selectedSegmentIndex) ?? "Male"
        let kgValue = Double(kg) ?? 0
        let cmValue = Double(cm) ?? 0
        
        let age = currentProfile?.age ?? calculateAgeFromHealthKit()
        
        let profile = Profile(
            firstName: firstName,
            lastName: lastName,
            gender: genderValue,
            weight: kgValue,
            height: cmValue,
            age: age
        )
        
        healthManager.updateUserProfile(profile)
                
//        UserDefaults.standard.set(true, forKey: "hasProfile")
        
        navigationController?.popViewController(animated: true)
    }
    
    private func loadCurrentProfile() {
        if let healthKitProfile = healthManager.currentProfile {
            currentProfile = healthKitProfile
        } else if let data = UserDefaults.standard.data(forKey: "userProfile"),
                  let savedProfile = try? JSONDecoder().decode(Profile.self, from: data) {
            currentProfile = savedProfile
        }
        
        if let profile = currentProfile {
            prefillForm(with: profile)
        }
        
        updateSaveButtonState()
    }
    
    private func prefillForm(with profile: Profile) {
        guard isViewLoaded else { return }
        
        view1.text.text = profile.firstName
        view2.text.text = profile.lastName
        view3.text.text = profile.weight > 0 ? String(format: "%.0f", profile.weight) : ""
        view4.text.text = profile.height > 0 ? String(format: "%.0f", profile.height) : ""
        
        switch profile.gender.lowercased() {
        case "male":
            gender.selectedSegmentIndex = 0
        case "female":
            gender.selectedSegmentIndex = 1
        case "other":
            gender.selectedSegmentIndex = 2
        default:
            gender.selectedSegmentIndex = 0
        }
        
        updateSaveButtonState()
    }
    
    private func calculateAgeFromHealthKit() -> Int {
        var calculatedAge = 0
        let semaphore = DispatchSemaphore(value: 0)
        
        healthManager.fetchDateOfBirth { dateOfBirth in
            if let dateOfBirth = dateOfBirth {
                let calendar = Calendar.current
                let now = Date()
                let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
                calculatedAge = ageComponents.year ?? 0
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return calculatedAge
    }
    
    func setupTitle() {
        title = isEditingMode ? "Edit Profile" : "Information"
    }
    
    func setupTextField() {
        view1.configure(labelText: "First name", placeholder: "Enter first name...")
        view2.configure(labelText: "Last name", placeholder: "Enter last name...")
        view3.configure(labelText: "Weight", placeholder: "Enter weight...")
        view4.configure(labelText: "Height", placeholder: "Enter height...")
        
        view1.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view2.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view3.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view4.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view3.text.keyboardType = .decimalPad
        view4.text.keyboardType = .decimalPad
        
        addDoneToolbar(to: view3.text)
        addDoneToolbar(to: view4.text)
    }
    
    private func addDoneToolbar(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupBackButton() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutral2
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    func setupButton() {
        saveButton.layer.cornerRadius = 16
        saveButton.layer.masksToBounds = true
        saveButton.backgroundColor = .neutral3
        saveButton.isEnabled = false
        saveButton.setTitleColor(.neutral5, for: .disabled)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.setTitle(isEditingMode ? "Update Profile" : "Save Profile", for: .normal)
    }
    
    func setupSwipeGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(swipeleft))
    }
    
    @objc func swipeleft(sender: UISwipeGestureRecognizer) {
        if !isEditingMode {
            tabBarController?.isTabBarHidden = false
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        if !isEditingMode {
            tabBarController?.isTabBarHidden = false
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let firstNameValid = view1.getTextValue() != nil && !view1.getTextValue()!.isEmpty
        let lastNameValid = view2.getTextValue() != nil && !view2.getTextValue()!.isEmpty
        let weightValid = view3.validateValue(max: 300) != nil
        let heightValid = view4.validateValue(max: 250) != nil
        
        saveButton.isEnabled = firstNameValid && lastNameValid && weightValid && heightValid
        saveButton.backgroundColor = saveButton.isEnabled ? .primary1 : .neutral3
    }

    func setCurrentProfile(_ profile: Profile) {
        self.currentProfile = profile
        if isViewLoaded {
            prefillForm(with: profile)
        }
    }
}
