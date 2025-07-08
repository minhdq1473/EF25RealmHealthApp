//
//  SettingsVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 4/7/25.
//

import UIKit

class SettingsVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorInset = .init(top: 0, left: 52, bottom: 0, right: 16)
//        tableView.separatorColor = .accentLine
        tableView.showsVerticalScrollIndicator = false
    
        setUpTitle()
        // Do any additional setup after loading the view.
        //2
        
    }
    
    func setUpTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textColor = UIColor.neutral1
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
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
extension SettingsVC: UITableViewDelegate {
    
}

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = InformationVC()
        let profileVC = ProfileVC()
        if indexPath.section == 0 {
            let hasProfile = UserDefaults.standard.bool(forKey: "hasProfile")
            if hasProfile {
                navigationController?.pushViewController(profileVC, animated: true)
                tabBarController?.isTabBarHidden = true
            } else {
                infoVC.delegate = self
                navigationController?.pushViewController(infoVC, animated: true)
                tabBarController?.isTabBarHidden = true
            }
        }
        
        

//        if profileVC.nameLabel.text! == "" {
//            navigationController?.pushViewController(infoVC, animated: true)
//        } else {
        //            navigationController?.pushViewController(profileVC, animated: true)
//        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let item = settingsSection[indexPath.section][indexPath.row]
        cell.configure(title: item.title, icon: item.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SettingsCell else { return }
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
//        if indexPath.section == 0 {
//            cell.containerView.layer.cornerRadius = 12
//        }
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == numberOfRows - 1
        
        cell.containerView.layer.cornerRadius = 12
        cell.containerView.layer.masksToBounds = true
        
        if isFirst && isLast {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        } else if isFirst {
            cell.containerView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner
            ]
        } else if isLast {
            cell.containerView.layer.maskedCorners = [
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner
            ]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        } else {
            cell.containerView.layer.cornerRadius = 0
        }
        
    }
}


extension SettingsVC: ResultDelegate {
    func update(_ profile: Profile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
    }
}

