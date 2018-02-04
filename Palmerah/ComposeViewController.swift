//
//  ComposeViewController.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 10/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//
import UIKit
import RxSwift

class ComposeViewController: UITableViewController, UISearchResultsUpdating {
    
    private let cellId = "cellId"
    var composeViewModel : ComposeViewModel?
    private var disposeBag = CompositeDisposable()
    var dismissSubject = PublishSubject<Friend>()
    
    override func viewDidLoad() {
        title = "Create Chat"
        tableView?.backgroundColor = .white
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButtonItem
        
        
        tableView?.backgroundColor = UIColor.white
        tableView?.alwaysBounceVertical = true
        
        tableView?.register(FriendCell.self, forCellReuseIdentifier: cellId)
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissSubject.onNext((self.composeViewModel?.friendAt(indexPath: indexPath))!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.composeViewModel?.numberOfItemInSection())!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86 * (UIFont.preferredFont(forTextStyle: .headline).pointSize / 17)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendCell
        
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
                        (self?.tableView?.insertRows(at: [event.newIndexPath!], with: .automatic))!
                    }))
                    break
                case .delete:
                    self?.blockOperations.append(BlockOperation(block: {
                        (self?.tableView?.deleteRows(at: [event.newIndexPath!], with: .automatic))!
                    }))
                    break
                case .update:
                    self?.blockOperations.append(BlockOperation(block: {
                        (self?.tableView?.reloadRows(at: [event.newIndexPath!], with: .automatic))!
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
                    self?.tableView?.performBatchUpdates({
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
