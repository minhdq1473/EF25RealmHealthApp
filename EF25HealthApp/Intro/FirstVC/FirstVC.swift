//
//  FirstVC.swift
//  EF25HealthPlanApp
//
//  Created by iKame Elite Fresher 2025 on 3/7/25.
//

import UIKit

class FirstVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    func setupLabel() {
        titleLabel.text = "Health Plan Pro"
        descLabel.text = "Providing workout routines and health information to support well-being."
        descLabel.numberOfLines = 0
    }
    func setupButton() {
        continueBtn.setTitle("Continue", for: .normal)
        continueBtn.backgroundColor = .primary1
        continueBtn.tintColor = .neutral5
        continueBtn.layer.cornerRadius = 16
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        let vc = SecondVC()
        navigationController?.pushViewController(vc, animated: true)
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
