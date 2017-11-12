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
        title = "Create Chat"
        collectionView?.backgroundColor = .white
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButtonItem
        
        let createChatButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createChat))
        // TODO : HANDLE SELECT CONTACT
        // navigationItem.rightBarButtonItem = createChatButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func createChat() {
        let controller = ChatRoomViewController()
        controller.friend = nil
        navigationController?.pushViewController(controller, animated: true)
    }
}
