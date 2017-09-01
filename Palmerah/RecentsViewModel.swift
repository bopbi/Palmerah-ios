//
//  RecentsViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData

class RecentsViewModel {
    
    private let recentFetchResultController : NSFetchedResultsController<Friend>
    
    init(friendRepository : FriendRepository, delegate: NSFetchedResultsControllerDelegate) {
        self.recentFetchResultController = friendRepository.getRecentsFetchResultController()
        self.recentFetchResultController.delegate = delegate
    }
    
    func performFetch() {
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
    
}
