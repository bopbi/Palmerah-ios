//
//  ChatRoomView.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 19/10/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatRoomView : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
 
    private let cellId  = "cellId"
    
    var viewModel : ChatRoomViewModel? = nil
    private var disposeBag = CompositeDisposable()
    private var messageInputView : MessageInputView? = MessageInputView()
    private var blockOperations = [BlockOperation]()
    
    static let smileEmoji = #imageLiteral(resourceName: "smile").resizeImage(newSize: CGSize(width: UIFont.preferredFont(forTextStyle: .body).lineHeight, height: UIFont.preferredFont(forTextStyle: .body).lineHeight))
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: layout)
        self.messageInputView?.inputTextView.delegate = self
        let inputDisposable = self.messageInputView?.sendMessageButton.rx.tap.asDriver()
            .map { [weak self] _ in self?.messageInputView?.inputTextView.text ?? "" }
            .filter { text in !text.isEmpty }
            .filter { [weak self] text in (self?.viewModel?.insertMessage(textMessage: text))! }
            .map { _ in "" }
            .drive((self.messageInputView?.inputTextView.rx.text)!)
        
        disposeBag.insert(inputDisposable!)
        
        self.contentInsetAdjustmentBehavior = .automatic
        self.showsHorizontalScrollIndicator = false;
        self.backgroundColor = .white
        self.alwaysBounceVertical = true
        self.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        self.keyboardDismissMode = .interactive
        self.dataSource = self
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardEvent), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardEvent(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentInset.bottom = (keyboardFrame?.height)!
            })
            self.scrollToBottom(animated: true);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var inputAccessoryView: UIView? {
        return messageInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel?.messagesCount())!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // experimental for label click on certain area
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatCell
        let currentMessage = self.viewModel?.messageAt(indexPath: indexPath)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        tapGesture.numberOfTapsRequired = 1
        cell?.isUserInteractionEnabled = true
        cell?.addGestureRecognizer(tapGesture)
        // end experimental
        cell?.drawMessage(message: currentMessage!, emojiImage: ChatRoomView.smileEmoji)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentMessage = self.viewModel?.messageAt(indexPath: indexPath)
        var nextMessage : Message? = nil
        
        if (indexPath.item < ((self.viewModel?.messagesCount())! - 1)) {
            let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            nextMessage = self.viewModel?.messageAt(indexPath: nextIndex)
            
        }
        let totalHeight = ChatCell.cellHeightForMessage(message: currentMessage!, nextMessage: nextMessage, emojiImage: ChatRoomView.smileEmoji)
        
        return CGSize(width: self.frame.width, height: totalHeight)
    }
    
    func scrollToBottom(animated: Bool) {
        let lastMessageIndexPath = IndexPath(item: (self.viewModel?.messagesCount())! - 1, section: 0)
        self.scrollToItem(at: lastMessageIndexPath, at: .bottom, animated: animated)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        messageInputView?.inputTextViewLabelPlaceHolder.isHidden = textView.hasText
        if ((self.viewModel?.messagesCount())! > 0) {
            DispatchQueue.main.async(execute: {
                self.scrollToBottom(animated: true)
            })
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        messageInputView?.inputTextViewLabelPlaceHolder.isHidden = textView.hasText
    }
    
    func onBind() {
        let rowDisposable = self.viewModel?.rowUpdateSubject.subscribe(onNext: { [weak self] (event) in
            switch event.type {
            case .insert:
                self?.blockOperations.append(BlockOperation(block: { [weak self] in
                    self?.insertItems(at: [event.newIndexPath!])
                }))
                break
            case .delete:
                self?.blockOperations.append(BlockOperation(block: { [weak self] in
                    self?.deleteItems(at: [event.indexPath!])
                }))
                break
            case .update:
                self?.blockOperations.append(BlockOperation(block: { [weak self] in
                    self?.reloadItems(at: [event.indexPath!])
                }))
                break
            default:
                break
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
        
        disposeBag.insert(rowDisposable!)
        
        let changeDisposable = self.viewModel?.changeContentSubject.subscribe(onNext: { [weak self] (result) in
            DispatchQueue.main.async {
                self?.performBatchUpdates({
                    for operation in (self?.blockOperations)! {
                        operation.start()
                    }
                }, completion: { (completed) in
                    self?.scrollToBottom(animated: true)
                })
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
        
        disposeBag.insert(changeDisposable!)
        
    }

    func adjustBottomInset() {
        self.contentInset.bottom = (messageInputView?.frame.height)!
    }
    
    @objc func handleGesture(sender: UITapGestureRecognizer) {
        let cell = sender.view as! ChatCell
        let messageLabel = cell.messageWithTimestampView.messageLabel
        let stringToCheck = messageLabel.attributedText?.string
        let clickRange = stringToCheck?.range(of: "Click here")
        if (clickRange == nil) {
            return
        }
        let startPos = stringToCheck?.distance(from: (stringToCheck?.startIndex)!, to: (clickRange?.lowerBound)!).advanced(by: 0)
        let endPos = stringToCheck?.distance(from: (stringToCheck?.startIndex)!, to: (clickRange?.upperBound)!).advanced(by: 0)
        
        let point = sender.location(in: messageLabel)
        let textStorage = NSTextStorage(attributedString: messageLabel.attributedText!)
        let textContainer = NSTextContainer(size: CGSize(width: messageLabel.bounds.width, height: messageLabel.bounds.height))
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textStorage.addAttribute(.font, value: messageLabel.font, range: NSMakeRange(0, textStorage.length))
        textContainer.lineFragmentPadding = 0.0
        
        let characterIndex = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if ((characterIndex >= startPos!) && (characterIndex <= endPos!)) {
            print(characterIndex)
            print(messageLabel.attributedText?.string[clickRange!])
        }
        
    }
}
