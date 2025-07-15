//
//  InformationVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 24/6/25.
//

import UIKit

protocol ResultDelegate: AnyObject {
    func update(_ profile: Profile)
}

class InformationVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var view1: CustomView!
    @IBOutlet weak var view2: CustomView!
    @IBOutlet weak var view3: CustomView!
    @IBOutlet weak var view4: CustomView!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: ResultDelegate?
    var editingProfile: Profile?
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        setupButton()
        setupTextField()
        setupBackButton()
        setupSwipeGesture()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let firstName = view1.getTextValue(), let lastName = view2.getTextValue(), let kg = view3.getTextValue(), let cm = view4.getTextValue() else { return }
        //        let firstName = view1.text!
        //        let lastName = view2.text!
        //        let kg = view3.text!
        //        let cm = view4.text!
        //        let firstNameValue: String = firstName.text!
        //        let lastNameValue: String = lastName.text!
        let genderValue: String = gender.titleForSegment(at: gender.selectedSegmentIndex) ?? "Male"
        let kgValue = Double(kg) ?? 0
        let cmValue = Double(cm) ?? 0
        
        let profile = Profile(firstName: firstName, lastName: lastName, gender: genderValue, weight: kgValue, height: cmValue)
        delegate?.update(profile)
        
        if UserDefaults.standard.bool(forKey: "hasProfile") == false {
            UserDefaults.standard.set(true, forKey: "hasProfile")
            let vc = ProfileVC()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
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
        
        if let profile = editingProfile {
            view1.text.text = profile.firstName
            view2.text.text = profile.lastName
            view3.text.text = String(Int(profile.weight))
            view4.text.text = String(Int(profile.height))
            gender.selectedSegmentIndex = profile.gender == "Male" ? 0 : 1
            saveButton.isEnabled = true
            saveButton.backgroundColor = .primary1
        }
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
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
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
        let firstNameValid = view1.getTextValue() != nil
        let lastNameValid = view2.getTextValue() != nil
        let weightValid = view3.validateValue(max: 300) != nil
        let heightValid = view4.validateValue(max: 250) != nil
        
        saveButton.isEnabled = firstNameValid && lastNameValid && weightValid && heightValid
        saveButton.backgroundColor = saveButton.isEnabled ? .primary1 : .neutral3
        //        let firstName = view1.text!
        //        let lastName = view2.text!
        //        let kg = view3.text!
        //        let cm = view4.text!
        //        if !firstName.text!.isEmpty && !lastName.text!.isEmpty && !kg.text!.isEmpty && !cm.text!.isEmpty {
        //            saveButton.backgroundColor = .primary1
        //        } else {
        //            saveButton.isEnabled = false
        //            saveButton.backgroundColor = .neutral3
        //        }
    }
}
