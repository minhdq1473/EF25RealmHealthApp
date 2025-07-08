//
//  ProfileVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 24/6/25.
//

import UIKit

protocol ProfileDelegate: AnyObject {
    func edit(_ profile: Profile, index: Int)
    func delete(at index: Int)
}

extension ProfileVC: ResultDelegate {
    func update(_ profile: Profile) {
        self.profile = profile
        configProfile()
        profileDelegate?.edit(profile, index: profileIndex!)
    }
}

class ProfileVC: UIViewController {
    var profile: Profile?
    var profileIndex: Int?
    weak var profileDelegate: ProfileDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var yourBMILabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var infoStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        stack.layer.cornerRadius = 15
//        yourBMILabel.translatesAutoresizingMaskIntoConstraints = false
//        yourBMILabel.topAnchor.constraint(equalTo: stack.topAnchor, constant: 16).isActive = true
//        infoStack.translatesAutoresizingMaskIntoConstraints = false
//        infoStack.setCustomSpacing(16, after: infoStack)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
//        add.tintColor = .primary1
        editButton.backgroundColor = .primary1
        editButton.layer.cornerRadius = 15
        
        // fullname.attributedPlaceholder = NSAttributedString(string: "----", attributes: [NSAttributedString.Key.foregroundColor: UIColor.neutral15])
        // bmi.attributedPlaceholder = NSAttributedString(string: "---", attributes: [NSAttributedString.Key.foregroundColor: UIColor.good])
        // weight.attributedPlaceholder = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.foregroundColor: UIColor.good])
        // height.attributedPlaceholder = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.foregroundColor: UIColor.good])
        // age.attributedPlaceholder = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.foregroundColor: UIColor.good])
        // sex.attributedPlaceholder = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.foregroundColor: UIColor.good])
        
        configProfile()
        
//        nameLabel.sizeToFit()
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deleteButton))
        navigationItem.rightBarButtonItem?.tintColor = .primary1
    }
    
    @objc func deleteButton() {
        let alert = DeleteAlertVC()
        alert.yesAction = { [weak self] in
            guard let self else { return }
            self.profileDelegate?.delete(at: self.profileIndex!)
            self.navigationController?.popViewController(animated: true)
        }
//        let alertController = UIAlertController(title: "Delete Profile", message: "Are you sure, you want to delete?", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
//            self.profileDelegate?.delete(at: self.profileIndex!)
//            self.navigationController?.popViewController(animated: true)
//        }))
        present(alert, animated: true)
//        firstName.text = ""
//        lastName.text = ""
//        kg.text = ""
//        cm.text = ""
//        gender.selectedSegmentIndex = 0
//        delegate?.clear()
    }

    
    func configProfile() {
        guard let profile else { return }
        
        nameLabel.text = profile.fullName
        weightLabel.text = "\(Int(profile.weight)) kg"
        heightLabel.text = "\(Int(profile.height)) cm"
        sexLabel.text = profile.gender
        bmiLabel.text = String(format: "%.1f", profile.bmi)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let vc = InformationVC()
        vc.delegate = self
        vc.editingProfile = self.profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
   

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // func calculateBMI(kg: Double, cm: Double) -> Double {
    //     kg / pow(cm / 100, 2)
    // }

}
//extension ProfileVC: ResultDelegate {
//    func update(firstName: String, lastName: String, gender: String, kg: String, cm: String) {
//        fullname.text = "\(firstName) \(lastName)"
//        weight.text = "\(kg)"
//        height.text = "\(cm)"
//        sex.text = gender
//        bmi.text = String(calculateBMI(kg: Double(kg)!, cm: Double(cm)!))
//        editButton.setTitle("Edit", for: UIControl.State.normal)
//    }
//    func clear() {
//        fullname.text = ""
//        weight.text = ""
//        height.text = ""
//        sex.text = ""
//        bmi.text = ""
//        editButton.setTitle("Add", for: UIControl.State.normal)
//    }
//
//}
