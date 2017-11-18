//
//  FriendRepository.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/30/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData

class FriendRepository {
    
    let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getFriendWithLastMessageFetchResultController() -> NSFetchedResultsController<Friend> {
        let friendFetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        friendFetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastMessage.date", ascending: false)
        ]
        friendFetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        
        let fetchRequestController = NSFetchedResultsController(fetchRequest: friendFetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchRequestController
    }
    
    func getFriendsFetchResultController() -> NSFetchedResultsController<Friend> {
        let friendFetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        friendFetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchRequestController = NSFetchedResultsController(fetchRequest: friendFetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchRequestController
    }
    
}
