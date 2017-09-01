//
//  MessageRepository.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData

class MessageRepository {
    
    let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getChatMessagesFetchResultController(friend: Friend) -> NSFetchedResultsController<Message> {
        let messageFetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
        messageFetchRequest.sortDescriptors =   [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        messageFetchRequest.predicate = NSPredicate(format: "friend.name = %@ ", friend.name!)
        let fetchResultController = NSFetchedResultsController(fetchRequest: messageFetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    func createMessageForFriend(messageText: String, friend: Friend, date: NSDate, isSender: Bool) -> Bool {
        let message = Message(context: self.context)
        message.text = messageText
        message.date = date
        message.friend = friend
        message.isSender = isSender
        
        friend.lastMessage = message
        
        do {
            try context.save()
        } catch let err {
            print(err)
            return false
        }
        return true
    }

}
