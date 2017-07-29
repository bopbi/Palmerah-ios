//
//  FriendControllerHelper.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData

extension FriendViewController {
   
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let friend = Friend(context: context)
            friend.name = "Jesse Doe"
            friend.profileImageNamed = "sample_user_1"
            
            let message = Message(context: context)
            message.text = "Hello, this is just a test message, sorry to bother you"
            message.date = NSDate()
            message.friend = friend
            
            let friend2 = Friend(context: context)
            friend2.name = "Jack Doe"
            friend2.profileImageNamed = "sample_user_2"
            
            let message2 = Message(context: context)
            message2.text = "Hello, this is just a test message, sorry to bother you"
            message2.date = NSDate().addingTimeInterval(-1 * 60)
            message2.friend = friend2
            
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
                messages = try context.fetch(messageFetchRequest)
                for message in messages! {
                    context.delete(message)
                }
            } catch let err {
                print(err)
            }
            
            
        }
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let messageFetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
            messageFetchRequest.sortDescriptors =   [
                                                    NSSortDescriptor(key: "date", ascending: false)
                                                    ]
            do {
                messages = try context.fetch(messageFetchRequest)
            } catch let err {
                print(err)
            }
            
            
        }
        
    
        
    }
    
}
