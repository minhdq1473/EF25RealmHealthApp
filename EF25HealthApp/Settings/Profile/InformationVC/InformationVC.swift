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

//extension InformationVC: EditDelegate {
//    func edit(_ profile: Profile) {
//        self.editingProfile = profile
//    }
//}

class InformationVC: UIViewController {
    var delegate: ResultDelegate?
    var editingProfile: Profile?
    
    @IBOutlet weak var view1: CustomView!
    @IBOutlet weak var view2: CustomView!
    @IBOutlet weak var view3: CustomView!
    @IBOutlet weak var view4: CustomView!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
//        print("Editing profile: \(editingProfile?.fullName ?? "nil")")

        view1.label.text = "First name"
        view1.text.placeholder = "Enter first name"
        view2.label.text = "Last name"
        view2.text.placeholder = "Enter last name"
        view3.label.text = "Weight"
        view3.text.placeholder = "Kg"
        view4.label.text = "Height"
        view4.text.placeholder = "Cm"
        
        view1.view.layer.cornerRadius = 15
        view2.view.layer.cornerRadius = 15
        view3.view.layer.cornerRadius = 15
        view4.view.layer.cornerRadius = 15
//        firstName.layer.cornerRadius = 20
//        lastName.layer.cornerRadius = 20
//        kg.layer.cornerRadius = 20
//        cm.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 15
        saveButton.backgroundColor = .neutral3
        saveButton.isEnabled = false
        
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
        
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let firstName = view1.text!
        let lastName = view2.text!
        let kg = view3.text!
        let cm = view4.text!
        
        if !firstName.text!.isEmpty && !lastName.text!.isEmpty && !kg.text!.isEmpty && !cm.text!.isEmpty {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .primary1
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .neutral3
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
//        let firstNameValue = firstName.text!
//        let lastNameValue = lastName.text!
        print("Save button tapped")

        let firstName = view1.text!
        let lastName = view2.text!
        let kg = view3.text!
        let cm = view4.text!
        print("First name: \(firstName.text ?? "nil")")
        print("Last name: \(lastName.text ?? "nil")")
        print("Weight: \(kg.text ?? "nil")")
        print("Height: \(cm.text ?? "nil")")
        
        let firstNameValue: String = firstName.text!
        let lastNameValue: String = lastName.text!
        let genderValue: String = gender.titleForSegment(at: gender.selectedSegmentIndex)!
        let kgValue = Double(kg.text!)!
        let cmValue = Double(cm.text!)!
//        let fullname = "\(firstName.text!) \(lastName.text!)"
//        let bmi = kgValue / (cmValue * cmValue / 10000)
        
        let profile = Profile(firstName: firstNameValue, lastName: lastNameValue, gender: genderValue, weight: kgValue, height: cmValue)
        delegate?.update(profile)
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
