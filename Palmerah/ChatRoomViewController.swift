//
//  ChatViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/30/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

class ChatRoomViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let maxBubbleContentWidth = 250
    let textPadding = CGFloat(10)
    let sideBubblePadding = CGFloat(10)
    let topBubblePadding = CGFloat(5)
    let bottomBubblePadding = CGFloat(10)
    let senderBubbleColor = UIColor.appleBlue()
    let receiverBubbleColor = UIColor(white: 0.95, alpha: 1)
    var messageTextHeight :[String:CGSize] = [:]
    
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
                
                DispatchQueue.main.async(execute: { 
                    let lastMessageIndexPath = IndexPath(item: (self.messages?.count)! - 1, section: 0)
                    self.collectionView?.scrollToItem(at: lastMessageIndexPath, at: .bottom, animated: false)
                })
            } catch let err {
                print(err)
            }
        
            
        }
        
    }
    
    var messages:[Message]?
    
    let messageInputContainerView : UIView = {
        let view = UIView()
        view.addBlurBackgroundLayer(blurStyle: .extraLight, colorIfBlurIsDisable: .white)
        return view
    }()
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendMessageButton : UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor.appleBlue()
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor.init(white: 0.69, alpha: 1)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendMessageButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendMessageButton)
        messageInputContainerView.addConstraintWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintWithFormat(format: "V:|[v0]|", views: sendMessageButton)
        messageInputContainerView.addConstraintWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintWithFormat(format: "V:|[v0(0.3)]", views: topBorderView)
    }
    
    var bottomMessageInputContainerViewConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomMessageInputContainerViewConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraint(bottomMessageInputContainerViewConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: .UIKeyboardWillHide, object: nil)
        
        
    }
    
    func handleKeyboard(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            
            bottomMessageInputContainerViewConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            
            var bottomInset : CGFloat = 0.0
            let topInset : CGFloat = (self.collectionView?.contentInset.top)!
            
            if (isKeyboardShowing) {
                bottomInset = keyboardFrame.size.height + self.messageInputContainerView.bounds.height
            } else {
                bottomInset = self.messageInputContainerView.bounds.height
            }
            
            DispatchQueue.main.async(execute: {
                self.collectionView?.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
                self.collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0, bottomInset, 0)
            })
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if (isKeyboardShowing) {
                    self.scrollToBottom()
                }
            })
            
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
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
            
            if (self.messageTextHeight[textMessage] == nil) {
                let textBoundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: textMessage, constrainedToWidth: CGFloat(maxBubbleContentWidth))
                
                self.messageTextHeight[textMessage] = textBoundingRect
            }
            
            let messageTextSize = self.messageTextHeight[textMessage]

            let totalHeight = (messageTextSize?.height)! + (2 * textPadding)
            let totalWidth = (messageTextSize?.width)! + (2 * textPadding)
            var startBubble : CGFloat?;
            
            if (messages?[indexPath.item].isSender)! {
                cell?.bubbleBackgroundView.backgroundColor = senderBubbleColor
                cell?.messageLabel.textColor = UIColor.white
                startBubble = view.frame.width - ((messageTextSize?.width)! + ( 2 * textPadding ) + sideBubblePadding)
            } else {
                cell?.bubbleBackgroundView.backgroundColor = receiverBubbleColor
                cell?.messageLabel.textColor = UIColor.black
                startBubble = sideBubblePadding
            }
            
            cell?.messageLabel.frame = CGRect(x: startBubble! + textPadding, y: topBubblePadding + textPadding, width: (messageTextSize?.width)!, height: (messageTextSize?.height)!)
            cell?.bubbleBackgroundView.frame = CGRect(x: startBubble!, y: topBubblePadding, width: totalWidth, height: totalHeight)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentMessage = messages?[indexPath.item]
        if let textMessage = currentMessage?.text {
            if (self.messageTextHeight[textMessage] == nil) {
                let textBoundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: textMessage, constrainedToWidth: CGFloat(maxBubbleContentWidth))
                
                self.messageTextHeight[textMessage] = textBoundingRect
            }
            
            let messageTextSize = self.messageTextHeight[textMessage]
            var bubbleSpace = bottomBubblePadding;
            if (indexPath.item < (self.messages?.count)! - 1) {
                let currentBubbleSender = currentMessage?.isSender
                let nextMessage = self.messages?[indexPath.item + 1]
                if (currentBubbleSender == nextMessage?.isSender) {
                    bubbleSpace = 0
                }
                
            }
            
            let totalHeight = messageTextSize!.height + (2 * textPadding) + topBubblePadding + bubbleSpace;
            
            return CGSize(width: view.frame.width, height: totalHeight)
        }
        
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func scrollToBottom() {
        let lastMessageIndexPath = IndexPath(item: (self.messages?.count)! - 1, section: 0)
        self.collectionView?.scrollToItem(at: lastMessageIndexPath, at: .bottom, animated: true)
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
        view.layer.cornerRadius = 13
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
