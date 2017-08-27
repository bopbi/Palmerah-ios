//
//  ChatViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/30/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

class ChatRoomViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate, NSFetchedResultsControllerDelegate {
    
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
        }
    }
    
    lazy var chatMessagesFetchResultController : NSFetchedResultsController<Message> = {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        let messageFetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        messageFetchRequest.sortDescriptors =   [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        messageFetchRequest.predicate = NSPredicate(format: "friend.name = %@ ", (self.friend?.name)!)
        
        let context = delegate?.persistentContainer.viewContext
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: messageFetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            blockOperations.append(BlockOperation(block: { 
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
            break
        case .delete:
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.deleteItems(at: [newIndexPath!])
            }))
            break
        case .update:
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.reloadItems(at: [newIndexPath!])
            }))
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView?.performBatchUpdates({ 
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (completed) in
            self.scrollToBottom()
        })
    }
    
    lazy var messageInputContainerView : InputAccessoryView = {
        let inputAccessoryView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48))
        inputAccessoryView.sendMessageButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return inputAccessoryView
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (self.messagesCount() > 0) {
            DispatchQueue.main.async(execute: {
                self.scrollToBottom()
            })
            
        }
    }
    
    func handleSend() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            createMessageForFriend(messageText: self.messageInputContainerView.inputTextView.text!, friend: self.friend!, date: NSDate(), isSender: true, context: context)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
            
            self.messageInputContainerView.inputTextView.text = nil
        }
    }
    
    func createMessageForFriend(messageText: String, friend: Friend, date: NSDate, isSender: Bool, context: NSManagedObjectContext) {
        let message = Message(context: context)
        message.text = messageText
        message.date = date
        message.friend = friend
        message.isSender = isSender
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try self.chatMessagesFetchResultController.performFetch()
        } catch let err {
            print(err)
        }
        
        collectionView?.showsHorizontalScrollIndicator = false;
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        self.messageInputContainerView.inputTextView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        DispatchQueue.main.async(execute: {
            
            let currentContentInset = self.collectionView?.contentInset
            let currentScrollInset = self.collectionView?.scrollIndicatorInsets
            self.collectionView?.contentInset = UIEdgeInsets(top: (currentContentInset?.top)!, left: 0, bottom: self.messageInputContainerView.bounds.height, right: 0)
            self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: (currentScrollInset?.top)!, left: 0, bottom: self.messageInputContainerView.bounds.height, right: 0)
            
            self.collectionView?.reloadData()
            let lastMessageIndexPath = IndexPath(item: self.messagesCount() - 1, section: 0)
            self.collectionView?.scrollToItem(at: lastMessageIndexPath, at: .bottom, animated: false)
        })
    }
    
    func messagesCount() -> Int {
        return self.chatMessagesFetchResultController.sections![0].numberOfObjects
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.chatMessagesFetchResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatCell
        let message = self.chatMessagesFetchResultController.object(at: indexPath)
        if let textMessage = message.text {
            cell?.messageLabel.text = message.text
            
            if (self.messageTextHeight[textMessage] == nil) {
                let textBoundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: textMessage, constrainedToWidth: CGFloat(maxBubbleContentWidth))
                
                self.messageTextHeight[textMessage] = textBoundingRect
            }
            
            let messageTextSize = self.messageTextHeight[textMessage]

            let totalHeight = (messageTextSize?.height)! + (2 * textPadding)
            let totalWidth = (messageTextSize?.width)! + (2 * textPadding)
            var startBubble : CGFloat?;
            
            if (message.isSender) {
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
        let currentMessage = self.chatMessagesFetchResultController.object(at: indexPath)
        if let textMessage = currentMessage.text {
            if (self.messageTextHeight[textMessage] == nil) {
                let textBoundingRect = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).sizeOfString(string: textMessage, constrainedToWidth: CGFloat(maxBubbleContentWidth))
                
                self.messageTextHeight[textMessage] = textBoundingRect
            }
            
            let messageTextSize = self.messageTextHeight[textMessage]
            var bubbleSpace = bottomBubblePadding;
            if (indexPath.item < (self.messagesCount() - 1)) {
                let currentBubbleSender = currentMessage.isSender
                let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                let nextMessage = self.chatMessagesFetchResultController.object(at: nextIndex)
                if (currentBubbleSender == nextMessage.isSender) {
                    bubbleSpace = 0
                }
                
            }
            
            let totalHeight = messageTextSize!.height + (2 * textPadding) + topBubblePadding + bubbleSpace;
            
            return CGSize(width: view.frame.width, height: totalHeight)
        }
        
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return messageInputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func scrollToBottom() {
        let lastMessageIndexPath = IndexPath(item: self.messagesCount() - 1, section: 0)
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

class InputAccessoryView: UIView, UITextViewDelegate {
    
    let inputTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8.0
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.backgroundColor = UIColor.white.cgColor
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    let sendMessageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor.appleBlue()
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        var textSize = inputTextView.font?.sizeOfString(string: inputTextView.text, constrainedToWidth: bounds.width)
        if (textSize?.height == 0) {
            textSize = inputTextView.sizeThatFits(CGSize(width: inputTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        }
        return CGSize(width: bounds.width, height: textSize!.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addBlurBackgroundLayer(blurStyle: .extraLight, colorIfBlurIsDisable: .white)
        
        // This is required to make the view grow vertically
        autoresizingMask = .flexibleHeight
        
        // Setup textView as needed
        
        //sendMessageButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)

        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor.init(white: 0.69, alpha: 1)

        addSubview(inputTextView)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendMessageButton)
        addSubview(topBorderView)

        addConstraintWithFormat(format: "H:|-8-[v0][v1(60)]|", views: self.inputTextView, sendMessageButton)
        addConstraintWithFormat(format: "V:|-4-[v0]-4-|", views: inputTextView)
        addConstraintWithFormat(format: "V:|[v0]|", views: sendMessageButton)
        addConstraintWithFormat(format: "H:|[v0]|", views: topBorderView)
        addConstraintWithFormat(format: "V:|[v0(0.3)]", views: topBorderView)
        
        inputTextView.delegate = self
        
        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        inputTextView.isScrollEnabled = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        // Re-calculate intrinsicContentSize when text changes
        invalidateIntrinsicContentSize()
    }
}
