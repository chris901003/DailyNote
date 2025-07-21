// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "主頁", image: UIImage(systemName: "list.clipboard"), selectedImage: nil)

        let settingViewController = SettingViewController()
        settingViewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), selectedImage: nil)

        viewControllers = [mainViewController, settingViewController]

        selectedIndex = 0
    }
}
