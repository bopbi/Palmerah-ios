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
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let recentsViewController = RecentsViewController(collectionViewLayout: layout)
        let recentsNavigationController = UINavigationController(rootViewController: recentsViewController)
        recentsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.recents, tag: 0)
        
        let contactsViewController = ContactsViewController(collectionViewLayout: layout)
        let contactsNavigationController = UINavigationController(rootViewController: contactsViewController)
        contactsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.contacts, tag: 1)
        
        let moreSettingsViewController = MoreSettingsViewController()
        let moreSettingsNavigationController = UINavigationController(rootViewController: moreSettingsViewController)
        moreSettingsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.more, tag: 2)
        
        viewControllers = [recentsNavigationController, contactsNavigationController, moreSettingsNavigationController]
    }
}
