//
//  ComposeViewController.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 10/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//
import UIKit

class ComposeViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        title = "New Chat"
        collectionView?.backgroundColor = .white
        
        let closeButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
