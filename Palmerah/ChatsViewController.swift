//
//  ViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/6/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class ChatsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private var viewModel : ChatsViewModel? = nil
    static let smileEmoji = #imageLiteral(resourceName: "smile").resizeImage(newSize: CGSize(width: UIFont.preferredFont(forTextStyle: .subheadline).lineHeight, height: UIFont.preferredFont(forTextStyle: .subheadline).lineHeight))
    private var disposeBag = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Chats"
        let barButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(newChat))
        navigationItem.rightBarButtonItem = barButtonItem
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(LastMessageCell.self, forCellWithReuseIdentifier: cellId)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        let friendRepository = FriendRepository(context: context!)
        self.viewModel = ChatsViewModel(friendRepository: friendRepository)
        self.subscribeToRowEvent()
        self.subscribeToChangeContent()
        self.viewModel?.bind()
    }
    
    var blockOperations = [BlockOperation]()
    
    func subscribeToRowEvent() {
        let disposable = self.viewModel?.rxFetchRecentsResultController.rowUpdateSubject.subscribe(onNext: { [weak self] (event) in
            switch event.type {
            case .insert:
                self?.blockOperations.append(BlockOperation(block: {
                    (self?.collectionView?.insertItems(at: [event.newIndexPath!]))!
                }))
                break
            case .delete:
                self?.blockOperations.append(BlockOperation(block: {
                    (self?.collectionView?.deleteItems(at: [event.newIndexPath!]))!
                }))
                break
            case .update:
                self?.blockOperations.append(BlockOperation(block: {
                    (self?.collectionView?.reloadItems(at: [event.newIndexPath!]))!
                }))
                break
            default:
                break
            }
            
            }, onDisposed: {
                
        })
        disposeBag.insert(disposable!)
        
    }
    
    func subscribeToChangeContent() {
        let disposable = self.viewModel?.rxFetchRecentsResultController.changeContentSubject.subscribe({ [weak self] (event) in
            DispatchQueue.main.async {
                self?.collectionView?.performBatchUpdates({
                    for operation in (self?.blockOperations)! {
                        operation.start()
                    }
                }, completion: { (completed) in
                    
                })
            }
        })
        disposeBag.insert(disposable!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel?.numberOfItemInSection())!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LastMessageCell
        
        if let message = self.viewModel?.lastMessageAt(indexPath: indexPath) {
            cell.bindMessage(message: message, emojiImage: ChatsViewController.smileEmoji)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellheight = 86 * (UIFont.preferredFont(forTextStyle: .headline).pointSize / 17)
        return CGSize(width: view.frame.width, height: cellheight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ChatRoomViewController()
        controller.friend = self.viewModel?.friendAt(indexPath: indexPath)
        navigationController?.pushViewController(controller, animated: true)
        
    }

    @objc func newChat(_ sender:UIBarButtonItem!) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let composeViewController = ComposeViewController(collectionViewLayout: layout)
        let composeNavigationController = UINavigationController(rootViewController: composeViewController)
        navigationController?.present(composeNavigationController, animated: true, completion: nil)
    }
}
