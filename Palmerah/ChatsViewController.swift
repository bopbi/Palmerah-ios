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

class ChatsViewController: UITableViewController, UISearchResultsUpdating {
    
    
    private let cellId = "cellId"
    private var viewModel : ChatsViewModel? = nil
    static let smileEmoji = #imageLiteral(resourceName: "smile").resizeImage(newSize: CGSize(width: UIFont.preferredFont(forTextStyle: .subheadline).lineHeight, height: UIFont.preferredFont(forTextStyle: .subheadline).lineHeight))
    private var disposeBag = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Chats"
        let composeBarButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(composeChat))
        navigationItem.rightBarButtonItem = composeBarButtonItem
        
        let editBarButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(editChat))
        navigationItem.leftBarButtonItem = editBarButtonItem

        tableView?.backgroundColor = UIColor.white
        tableView?.alwaysBounceVertical = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Chats"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.register(LastMessageCell.self, forCellReuseIdentifier: cellId)
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
        let disposable = self.viewModel?
            .rxFetchRecentsResultController
            .rowUpdateSubject
            .subscribe(onNext: { [weak self] (event) in
            switch event.type {
            case .insert:
                self?.blockOperations.append(BlockOperation(block: {
                    (self?.tableView.insertRows(at: [event.newIndexPath!], with: .automatic))
                }))
                break
            case .delete:
                self?.blockOperations.append(BlockOperation(block: {
                    (self?.tableView.deleteRows(at: [event.newIndexPath!], with: .automatic))
                }))
                break
            case .update:
                self?.blockOperations.append(BlockOperation(block: {
                    (self?.tableView.reloadRows(at: [event.newIndexPath!], with: .automatic))
                }))
                break
            default:
                break
            }
            
            })
        disposeBag.insert(disposable!)
        
    }
    
    func subscribeToChangeContent() {
        let disposable = self.viewModel?
            .rxFetchRecentsResultController
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel?.numberOfItemInSection())!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LastMessageCell
        
        if let message = self.viewModel?.lastMessageAt(indexPath: indexPath) {
            cell.bindMessage(message: message, emojiImage: ChatsViewController.smileEmoji)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86 * (UIFont.preferredFont(forTextStyle: .headline).pointSize / 17)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChatRoomViewController()
        controller.friend = self.viewModel?.friendAt(indexPath: indexPath)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func composeChat(_ sender:UIBarButtonItem!) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let composeViewController = ComposeViewController()
        let composeNavigationController = UINavigationController(rootViewController: composeViewController)
        let disposable = composeViewController.dismissSubject.subscribe(onNext: { [weak self] (friend) in
            self?.navigationController?.dismiss(animated: true, completion: {
                let controller = ChatRoomViewController()
                controller.friend = friend
                self?.navigationController?.pushViewController(controller, animated: true)
            })
        })
        disposeBag.insert(disposable)
        navigationController?.present(composeNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func editChat(_ sender:UIBarButtonItem!) {
        self.tableView.setEditing(true, animated: true);
        self.tableView.beginUpdates()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
