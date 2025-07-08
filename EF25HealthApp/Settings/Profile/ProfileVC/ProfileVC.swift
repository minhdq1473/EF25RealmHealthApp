//
//  ProfileVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 24/6/25.
//

import UIKit


extension ProfileVC: ResultDelegate {
    func update(_ profile: Profile) {
        self.profile = profile
        configProfile()
    }
}

class ProfileVC: UIViewController {
    var profile: Profile?
    var profileIndex: Int?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var yourBMILabel: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var infoStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        stack.layer.cornerRadius = 15
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        

        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .primary1
        
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
            let profile = try? JSONDecoder().decode(Profile.self, from: data) {
            self.profile = profile
            configProfile()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .neutral2
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.isTabBarHidden = false
    }
    
    
    @objc func editButtonTapped() {
        let vc = InformationVC()
        vc.delegate = self
        vc.editingProfile = self.profile
        vc.isEditingMode = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configProfile() {
        guard let profile else { return }
        nameLabel.text = profile.fullName
        weightLabel.text = "\(Int(profile.weight)) kg"
        heightLabel.text = "\(Int(profile.height)) cm"
        sexLabel.text = profile.gender
        bmiLabel.text = String(format: "%.1f", profile.bmi)
    }
//    @IBAction func editButtonTapped(_ sender: UIButton) {
//        let vc = InformationVC()
//        vc.delegate = self
//        vc.editingProfile = self.profile
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
   

    
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
//    }
//    func clear() {
//        fullname.text = ""
//        weight.text = ""
//        height.text = ""
//        sex.text = ""
//        bmi.text = ""
//        editButton.setTitle("Add", for: UIControl.State.normal)
//    }
//}
