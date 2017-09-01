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
