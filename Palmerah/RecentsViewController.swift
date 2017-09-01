//
//  ViewController.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/6/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

class RecentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Recents"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(LastMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        do {
            try self.recentsFetchController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    lazy var recentsFetchController : NSFetchedResultsController<Friend> = {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        let friendFetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        friendFetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastMessage.date", ascending: false)
        ]
        friendFetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        
        let fetchRequestController = NSFetchedResultsController(fetchRequest: friendFetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchRequestController.delegate = self
        return fetchRequestController
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
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = self.recentsFetchController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LastMessageCell
        
        if let message = self.recentsFetchController.object(at: indexPath).lastMessage {
            cell.message = message
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellheight = 86 * (UIFont.preferredFont(forTextStyle: .headline).pointSize / 17)
        return CGSize(width: view.frame.width, height: cellheight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let controller = ChatRoomViewController(collectionViewLayout: layout)
        controller.friend = recentsFetchController.object(at: indexPath)
        navigationController?.pushViewController(controller, animated: true)
        
    }

}
