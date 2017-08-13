//
//  FriendControllerHelper.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

extension RecentsViewController {
   
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let friend1 = Friend(context: context)
            friend1.name = "Jesse Doe"
            friend1.profileImageNamed = "sample_user_1"
            
            createMessageForFriend(messageText: "Hello, this is just a test message, sorry to bother you", friend: friend1, date: NSDate().addingTimeInterval(-2 * 60), isSender: false, context: context)
            createMessageForFriend(messageText: "No worries, i understand your position 😊", friend: friend1, date: NSDate().addingTimeInterval(-1 * 60), isSender: true, context: context)
            createMessageForFriend(messageText: "So lets have a talk, shall we", friend: friend1, date: NSDate().addingTimeInterval(-1 * 60), isSender: true, context: context)
            
            let friend2 = Friend(context: context)
            friend2.name = "Jack Doe"
            friend2.profileImageNamed = "sample_user_2"
            
            
            createMessageForFriend(messageText: "Hello, this is just a test message, sorry to bother you", friend: friend2, date: NSDate().addingTimeInterval(-12 * 60 * 60 * 24), isSender: false, context: context)
            createMessageForFriend(messageText: "Next sample for creating text message", friend: friend2, date: NSDate().addingTimeInterval(-3 * 60 * 60 * 24), isSender: false, context: context)
            createMessageForFriend(messageText: "Please dont disturb me", friend: friend2, date: NSDate().addingTimeInterval(-2 * 60 * 60 * 24), isSender: true, context: context)
            createMessageForFriend(messageText: "Why are you using production setting anyway? its get sent to a real user", friend: friend2, date: NSDate().addingTimeInterval(-1 * 60 * 60 * 24), isSender: true, context: context)
            
            let friend3 = Friend(context: context)
            friend3.name = "Ujang Siang"
            friend3.profileImageNamed = "sample_user_2"
            
            
            createMessageForFriend(messageText: "All by myself", friend: friend3, date: NSDate().addingTimeInterval(-2 * 60 * 60 * 24), isSender: false, context: context)
            createMessageForFriend(messageText: "Galau eh?", friend: friend3, date: NSDate().addingTimeInterval(-2 * 60 * 60 * 24), isSender: true, context: context)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
        
        loadData()
        
    }
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let messageFetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
            do {
                let messagesToDelete = try context.fetch(messageFetchRequest)
                for message in messagesToDelete {
                    context.delete(message)
                }
            } catch let err {
                print(err)
            }
            
            
            
            let friendFetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
            do {
                let friendsToDelete = try context.fetch(friendFetchRequest)
                for friend in friendsToDelete {
                    context.delete(friend)
                }
            } catch let err {
                print(err)
            }
            
            
        }
    }
    
    func createMessageForFriend(messageText: String, friend: Friend, date: NSDate, isSender: Bool, context: NSManagedObjectContext) {
        let message = Message(context: context)
        message.text = messageText
        message.date = date
        message.friend = friend
        message.isSender = isSender
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                messages = [Message]()
                
                for friend in friends {
                    let messageFetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
                    messageFetchRequest.sortDescriptors =   [
                        NSSortDescriptor(key: "date", ascending: false)
                    ]
                    messageFetchRequest.predicate = NSPredicate(format: "friend.name = %@ ", friend.name!)
                    messageFetchRequest.fetchLimit = 1
                    do {
                        let messageResult = try context.fetch(messageFetchRequest)
                        messages?.append(contentsOf: messageResult)
                    } catch let err {
                        print(err)
                    }
                }
            }
            
        }
        
    }
    
    func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let friendFetchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
            
            do {
                return try context.fetch(friendFetchRequest)
            } catch let err {
                print(err)
            }
            
        }
        return nil
    }
    
}
