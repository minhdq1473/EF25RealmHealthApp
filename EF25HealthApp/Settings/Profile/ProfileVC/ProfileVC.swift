//
//  ProfileVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 24/6/25.
//

import UIKit
import RealmSwift


extension ProfileVC: ResultDelegate {
    func update(_ profile: Profile) {
        self.profile = profile
        configProfile()
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupUI()
        setupBarButton()
        setupSwipeGesture()
        setupData()
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
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(swipeleft))
    }
    
    func setupData() {
        if let profile = ProfileRealmManager.shared.getProfile() {
            self.profile = profile
            configProfile()
        }
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
}
