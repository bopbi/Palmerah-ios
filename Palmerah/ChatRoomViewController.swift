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
    
    var viewModel : ChatRoomViewModel? = nil
    
    private let cellId  = "cellId"
    
    var friend: Friend? {
        didSet {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let context = delegate?.persistentContainer.viewContext
            let messageRepository = MessageRepository(context: context!)
            viewModel = ChatRoomViewModel(friend: friend!, messageRepository: messageRepository)
            navigationItem.title = viewModel?.title
        }
    }
    
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
        DispatchQueue.main.async {
            self.collectionView?.performBatchUpdates({
                for operation in self.blockOperations {
                    operation.start()
                }
            }, completion: { (completed) in
                self.scrollToBottom()
            })
        }
        
    }
    
    lazy var messageInputView : MessageInputView = {
        let inputAccessoryView = MessageInputView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44 ))
        inputAccessoryView.sendMessageButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return inputAccessoryView
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        messageInputView.inputTextViewLabelPlaceHolder.isHidden = textView.hasText
        if ((self.viewModel?.messagesCount())! > 0) {
            DispatchQueue.main.async(execute: {
                self.scrollToBottom()
            })
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        messageInputView.inputTextViewLabelPlaceHolder.isHidden = textView.hasText
    }
    
    @objc func handleSend() {
        
        if (self.viewModel?.insertMessage(textMessage: self.messageInputView.inputTextView.text!))! {
            self.messageInputView.inputTextView.text = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.showsHorizontalScrollIndicator = false;
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        self.messageInputView.inputTextView.delegate = self
        
        self.viewModel?.bindToDelegate(delegate: self)
        self.viewModel?.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.scrollToBottom()
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel?.messagesCount())!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatCell
        let message = self.viewModel?.messageAt(indexPath: indexPath)
        if let textMessage = message?.text {
            cell?.messageLabel.text = message?.text
            
            let messageTextSize = textMessage.frameSize(maxWidth: CGFloat(maxBubbleContentWidth), font: UIFont.preferredFont(forTextStyle: .body))
    
            let totalHeight = messageTextSize.height + (2 * textPadding)
            let totalWidth = messageTextSize.width + (2 * textPadding)
            var startBubble : CGFloat?;
            
            if (message?.isSender)! {
                cell?.bubbleBackgroundView.backgroundColor = senderBubbleColor
                cell?.messageLabel.textColor = UIColor.white
                startBubble = view.frame.width - (messageTextSize.width + ( 2 * textPadding ) + sideBubblePadding)
            } else {
                cell?.bubbleBackgroundView.backgroundColor = receiverBubbleColor
                cell?.messageLabel.textColor = UIColor.black
                startBubble = sideBubblePadding
            }
            
            cell?.messageLabel.frame = CGRect(x: startBubble! + textPadding, y: topBubblePadding + textPadding, width: messageTextSize.width, height: messageTextSize.height)
            cell?.bubbleBackgroundView.frame = CGRect(x: startBubble!, y: topBubblePadding, width: totalWidth, height: totalHeight)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentMessage = self.viewModel?.messageAt(indexPath: indexPath)
        if let textMessage = currentMessage?.text {
            
            let messageTextSize = textMessage.frameSize(maxWidth: CGFloat(maxBubbleContentWidth), font: UIFont.preferredFont(forTextStyle: .body))
            
            var bubbleSpace = bottomBubblePadding;
            if (indexPath.item < ((self.viewModel?.messagesCount())! - 1)) {
                let currentBubbleSender = currentMessage?.isSender
                let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                let nextMessage = self.viewModel?.messageAt(indexPath: nextIndex)
                if (currentBubbleSender == nextMessage?.isSender) {
                    bubbleSpace = 0
                }
                
            }
            
            let totalHeight = messageTextSize.height + (2 * textPadding) + topBubblePadding + bubbleSpace;
            
            return CGSize(width: view.frame.width, height: totalHeight)
        }
        
        return CGSize(width: view.frame.width, height: 0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: 0, height: 0)
//    }
    
    override var inputAccessoryView: UIView? {
        get {
            return messageInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func scrollToBottom() {
        let lastMessageIndexPath = IndexPath(item: (self.viewModel?.messagesCount())! - 1, section: 0)
        self.collectionView?.scrollToItem(at: lastMessageIndexPath, at: .bottom, animated: true)
    }
}
