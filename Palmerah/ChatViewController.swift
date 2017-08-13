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
    
    let maxBubbleContentWidth = 250
    let textPadding = CGFloat(10)
    let bubblePadding = CGFloat(10)
    let senderBubbleColor = UIColor.appleBlue()
    let receiverBubbleColor = UIColor(white: 0.95, alpha: 1)
    
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
                NSSortDescriptor(key: "date", ascending: true)
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
        collectionView?.alwaysBounceVertical = true
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
        
        if let textMessage = messages?[indexPath.item].text {
            cell?.messageLabel.text = messages?[indexPath.item].text
            
            let textBoundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: textMessage, constrainedToWidth: CGFloat(maxBubbleContentWidth))
            
            let totalHeight = textBoundingRect.height + (2 * textPadding)
            let totalWidth = textBoundingRect.width + (2 * textPadding)
            var startBubble : CGFloat?;
            
            if (messages?[indexPath.item].isSender)! {
                cell?.bubbleBackgroundView.backgroundColor = senderBubbleColor
                cell?.messageLabel.textColor = UIColor.white
                startBubble = view.frame.width - (textBoundingRect.width + ( 2 * textPadding ) + bubblePadding)
            } else {
                cell?.bubbleBackgroundView.backgroundColor = receiverBubbleColor
                cell?.messageLabel.textColor = UIColor.black
                startBubble = bubblePadding
            }
            
            cell?.messageLabel.frame = CGRect(x: startBubble! + textPadding, y: textPadding, width: textBoundingRect.width, height: textBoundingRect.height)
            cell?.bubbleBackgroundView.frame = CGRect(x: startBubble!, y: 0, width: totalWidth, height: totalHeight)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let textMessage = messages?[indexPath.item].text {
            
            let textBoundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: textMessage, constrainedToWidth: CGFloat(maxBubbleContentWidth))
            
            let totalHeight = textBoundingRect.height + (2 * textPadding)
            
            return CGSize(width: view.frame.width, height: totalHeight)
        }
        
        return CGSize(width: view.frame.width, height: 0)
    }
}

class ChatCell : UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    let bubbleBackgroundView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not implemented")
    }

    func setupViews() {
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        
    }
}
