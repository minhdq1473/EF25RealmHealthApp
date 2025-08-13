//
//  InputVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import UIKit
import RealmSwift
//protocol InputVCDelegate: AnyObject {
//    func update(_ log: HealthGuru)
//}

class InputVC: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var view1: CustomView!
    @IBOutlet weak var view2: CustomView!
    
    var editingLog: HealthGuru?
    var isEditingMode: Bool {
        editingLog != nil
    }
    

//    var inputDelegate: InputVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupText()
        setupButton()
        setupDismissButton()
        
        if let log = editingLog {
            view1.text.text = String(log.pulse)
            view2.text.text = String(log.HRV)
            textFieldDidChange(view1.text)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let pulse = view1.validateValue(max: 200), let hrv = view2.validateValue(max: 200) else {return}
        
        if let log = editingLog {
            LogRealmManager.shared.update(id: log.id, pulse: pulse, hrv: hrv)
        } else {
            LogRealmManager.shared.add(pulse: pulse, hrv: hrv)
        }
        
//        let log = HealthGuru(pulse: pulse, HRV: hrv)
//        inputDelegate?.update(log)
        dismiss(animated: true)
    }
    
    func setupTitle() {
        title = isEditingMode ? "Edit Information" : "Information"
    }
    
    func setupText() {
        view1.configure(labelText: "Pulse", placeholder: "Enter your pulse")
        view2.configure(labelText: "HRV", placeholder: "Enter your HRV")
        view1.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view2.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupButton() {
        addButton.setTitle(isEditingMode ? "Save" : "Add", for: .normal)
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
    }
}
