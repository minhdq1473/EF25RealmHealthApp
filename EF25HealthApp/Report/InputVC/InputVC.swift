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
        // Do any additional setup after loading the view.
        view1.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view2.text.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.isTabBarHidden = false
    }
    
    func setupText() {
        view1.label.text = "Pulse"
        view2.label.text = "HRV"
        view1.text.placeholder = "Enter your pulse"
        view2.text.placeholder = "Enter your HRV"
    }
    
    func setupButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.tintColor = .neutral5
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.isEnabled = false
        addButton.setTitleColor(.neutral5, for: .disabled)
        addButton.backgroundColor = .neutral3
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let pulseText = view1.text!
        let hrvText = view2.text!
        
        if !pulseText.text!.isEmpty && !hrvText.text!.isEmpty {
            addButton.isEnabled = true
            addButton.backgroundColor = .primary1
        } else {
            addButton.isEnabled = false
            addButton.backgroundColor = .neutral3
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let pulseText = view1.text!
        let hrvText = view2.text!
        
        let pulseValue = Int(pulseText.text!)!
        let hrvValue = hrvText.text!
        
        let log = HealthGuru(pulse: pulseValue, HRV: hrvValue)
        inputDelegate?.update(log)
        navigationController?.popViewController(animated: true)
        tabBarController?.isTabBarHidden = false
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
