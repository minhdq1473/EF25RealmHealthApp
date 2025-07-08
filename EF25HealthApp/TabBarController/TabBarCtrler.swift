//
//  TabBarCtrler.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import UIKit

class TabBarCtrler: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tab1 = UINavigationController(rootViewController: ReportVC())
        let tab2 = UINavigationController(rootViewController: SettingsVC())
        tab1.tabBarItem = UITabBarItem(title: "Report", image: .chart, selectedImage: .coloredChart)
        tab1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        tab2.tabBarItem = UITabBarItem(title: "Settings", image: .setting, selectedImage: .coloredSetting)
        tab2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
      
        viewControllers = [tab1, tab2]
        setupTabBar()
        // Do any additional setup after loading the view.
    }
    
    func setupTabBar() {
        tabBar.tintColor = .primary1
        tabBar.backgroundColor = .neutral5
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
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
