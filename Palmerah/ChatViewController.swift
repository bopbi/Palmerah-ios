//
//  ChatViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/30/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId  = "cellId"
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            
            loadData()
        }
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            messages = [Message]()
                
            let messageFetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
            messageFetchRequest.sortDescriptors =   [
                NSSortDescriptor(key: "date", ascending: false)
            ]
            messageFetchRequest.predicate = NSPredicate(format: "friend.name = %@ ", (friend?.name)!)
            do {
                let messageResult = try context.fetch(messageFetchRequest)
                messages?.append(contentsOf: messageResult)
            } catch let err {
                print(err)
            }
        
            
        }
        
    }
    
    var messages:[Message]?
    
    override func viewDidLoad() {
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatCell
        cell?.messageLabel.text = messages?[indexPath.item].text
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = messages?[indexPath.item]
        
        let boundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: (message?.text)!, constrainedToWidth: Double(view.frame.width))
        
        return CGSize(width: view.frame.width, height: boundingRect.height)
    }
}

class ChatCell : UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not implemented")
    }

    func setupViews() {
        
        addSubview(messageLabel)
        addConstraintWithFormat(format: "H:|[v0]|", views: messageLabel)
        addConstraintWithFormat(format: "V:|[v0]|", views: messageLabel)
    }
}
