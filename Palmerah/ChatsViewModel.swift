//
//  RecentsViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class ChatsViewModel : NSObject, NSFetchedResultsControllerDelegate {
    
    private let recentFetchResultController : NSFetchedResultsController<Friend>
    let rowUpdateSubject = PublishSubject<ChatsRowUpdateEvent>()
    let changeContentSubject = PublishSubject<Bool>()
    
    init(friendRepository : FriendRepository) {
        self.recentFetchResultController = friendRepository.getRecentsFetchResultController()
    }
    
    func bind() {
        self.recentFetchResultController.delegate = self
        do {
            try self.recentFetchResultController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func numberOfItemInSection() ->Int {
        if let count = self.recentFetchResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    func lastMessageAt(indexPath : IndexPath) -> Message {
        return self.recentFetchResultController.object(at: indexPath).lastMessage!
    }
    
    func friendAt(indexPath: IndexPath) -> Friend {
        return self.recentFetchResultController.object(at: indexPath)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        self.rowUpdateSubject.onNext(ChatsRowUpdateEvent(indexPath: indexPath, type: type, newIndexPath: newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.changeContentSubject.onNext(true)
    }
    
    struct ChatsRowUpdateEvent {
        var indexPath: IndexPath?
        var type: NSFetchedResultsChangeType
        var newIndexPath: IndexPath?
    }
    
}
