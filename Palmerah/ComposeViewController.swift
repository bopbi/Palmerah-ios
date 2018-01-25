//
//  ComposeViewController.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 10/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//
import UIKit
import RxSwift

class ComposeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    
    private let cellId = "cellId"
    var composeViewModel : ComposeViewModel?
    private var disposeBag = CompositeDisposable()
    var dismissSubject = PublishSubject<Friend>()
    
    override func viewDidLoad() {
        title = "Create Chat"
        collectionView?.backgroundColor = .white
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButtonItem
        
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(FriendCell.self, forCellWithReuseIdentifier: cellId)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contact"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        let friendRepository = FriendRepository(context: context!)
        self.composeViewModel = ComposeViewModel(friendRepository: friendRepository)
        subscribeToChangeContent()
        subscribeToRowEvent()
        self.composeViewModel?.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismissSubject.onNext((self.composeViewModel?.friendAt(indexPath: indexPath))!)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.composeViewModel?.numberOfItemInSection())!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellheight = 86 * (UIFont.preferredFont(forTextStyle: .headline).pointSize / 17)
        return CGSize(width: view.frame.width, height: cellheight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendCell
        
        if let friend = self.composeViewModel?.friendAt(indexPath: indexPath) {
            cell.bindMessage(friend: friend, emojiImage: ChatsViewController.smileEmoji)
        }
        
        return cell
    }
    
    var blockOperations = [BlockOperation]()
    
    func subscribeToRowEvent() {
        let disposable = self.composeViewModel?
            .rxFetchFriendsResultController
            .rowUpdateSubject
            .subscribe(onNext: { [weak self] (event) in
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
                
            })
        disposeBag.insert(disposable!)
        
    }
    
    func subscribeToChangeContent() {
        let disposable = self.composeViewModel?
            .rxFetchFriendsResultController
            .changeContentSubject
            .subscribe({ [weak self] (event) in
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
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
