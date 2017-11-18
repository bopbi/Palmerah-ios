//
//  ChatViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/30/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class ChatRoomViewController: UIViewController {
    
    var viewModel : ChatRoomViewModel? = nil
    
    var friend: Friend? {
        didSet {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let context = delegate?.persistentContainer.viewContext
            let messageRepository = MessageRepository(context: context!)
            viewModel = ChatRoomViewModel(friend: friend!, messageRepository: messageRepository)
            navigationItem.title = viewModel?.title
        }
    }

    var chatRoomView : ChatRoomView? = {
        let view = ChatRoomView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatRoomView?.viewModel = self.viewModel
        self.chatRoomView?.onBind()
        
        self.view = chatRoomView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        DispatchQueue.main.async(execute: {
            self.view.becomeFirstResponder()
            self.chatRoomView?.adjustBottomInset()
            self.chatRoomView?.scrollToBottom(animated: false)
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.chatRoomView?.collectionViewLayout.invalidateLayout()
    }
}
