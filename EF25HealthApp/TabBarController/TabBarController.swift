//
//  TabBarCtrler.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupUI()
    }
    
    func setupTabBar() {
        let tab1 = UINavigationController(rootViewController: ReportVC())
        let tab2 = UINavigationController(rootViewController: SettingsVC())
        tab1.tabBarItem = UITabBarItem(title: "Report", image: .chart, selectedImage: .coloredChart)
        tab1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        tab2.tabBarItem = UITabBarItem(title: "Settings", image: .setting, selectedImage: .coloredSetting)
        tab2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        viewControllers = [tab1, tab2]
    }
    
    func setupUI() {
        tabBar.tintColor = .primary1
        tabBar.backgroundColor = .neutral5
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
    }
}
