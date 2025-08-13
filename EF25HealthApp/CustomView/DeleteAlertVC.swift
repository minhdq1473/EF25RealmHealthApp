//
//  DeleteAlertVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 30/6/25.
//

import UIKit

class DeleteAlertVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var outterStack: UIStackView!
    
    var yesAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStack()
        setupBtns()
    }
    
    @IBAction func yesTapped(_ sender: UIButton) {
        dismiss(animated: true)
        yesAction?()
    
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func setupStack() {
        outterStack.layer.cornerRadius = 15
        outterStack.isLayoutMarginsRelativeArrangement = true
        outterStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
    }
    
    private func setupBtns() {
        yesBtn.layer.cornerRadius = 15
        cancelBtn.layer.cornerRadius = 15
        cancelBtn.layer.borderWidth = 1.5
        cancelBtn.layer.borderColor = UIColor.primary1.cgColor
    }
}
