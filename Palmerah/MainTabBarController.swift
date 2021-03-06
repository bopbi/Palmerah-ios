//
//  MainTabBarController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 8/5/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        // add data seeder
        let seeder = Seeder()
        seeder.setupData()
        
        let chatsViewController = ChatsViewController()
        let chatsNavigationController = UINavigationController(rootViewController: chatsViewController)
        chatsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.recents, tag: 0)
        
        let moreSettingsViewController = MoreSettingsViewController()
        let moreSettingsNavigationController = UINavigationController(rootViewController: moreSettingsViewController)
        moreSettingsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.more, tag: 1)
        
        viewControllers = [chatsNavigationController, moreSettingsNavigationController]
    }
}
