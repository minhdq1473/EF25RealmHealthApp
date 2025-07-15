//
//  InputVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import UIKit

protocol InputVCDelegate: AnyObject {
    func update(_ log: HealthGuru)
}

class InputVC: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var view1: CustomView!
    @IBOutlet weak var view2: CustomView!
    
    var inputDelegate: InputVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        
        setupText()
        setupButton()
        setupDismissButton()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let pulse = view1.validateValue(max: 200), let hrv = view2.validateValue(max: 200) else {return}
        let log = HealthGuru(pulse: pulse, HRV: hrv)
        
        inputDelegate?.update(log)
        dismiss(animated: true)
    }
    
    func setupText() {
        view1.configure(labelText: "Pulse", placeholder: "Enter your pulse")
        view2.configure(labelText: "HRV", placeholder: "Enter your HRV")
        view1.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view2.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.tintColor = .neutral5
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.isEnabled = false
        addButton.setTitleColor(.neutral5, for: .disabled)
        addButton.backgroundColor = .neutral3
        addButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    func setupDismissButton() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .neutral2
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let pulseValid = view1.validateValue(max: 200) != nil
        let hrvValid = view2.validateValue(max: 200) != nil
        
        addButton.isEnabled = pulseValid && hrvValid
        addButton.backgroundColor = addButton.isEnabled ? .primary1 : .neutral3
        
//        let pulseText = view1.text!
//        let hrvText = view2.text!
//        if !pulseText.text!.isEmpty && !hrvText.text!.isEmpty {
//            addButton.isEnabled = true
//            addButton.backgroundColor = .primary1
//        } else {
//            addButton.isEnabled = false
//            addButton.backgroundColor = .neutral3
//        }
    }
}
