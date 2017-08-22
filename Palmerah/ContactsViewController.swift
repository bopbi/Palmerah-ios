//
//  ContactsViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 8/6/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class ContactsViewController: UICollectionViewController {
 
    override func viewDidLoad() {
        navigationItem.title = "Contacts"
        collectionView?.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}
