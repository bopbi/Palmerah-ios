//
//  ChatRoomViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData

class ChatRoomViewModel {
    
    private let messageRepository : MessageRepository
    private let chatMesageFetchResultController : NSFetchedResultsController<Message>
    let friend : Friend
    let title : String
    
    init(friend : Friend, messageRepository : MessageRepository) {
        self.friend = friend
        self.title = self.friend.name!
        self.messageRepository = messageRepository
        self.chatMesageFetchResultController = self.messageRepository.getChatMessagesFetchResultController(friend: self.friend)
    }
    
    func insertMessage(textMessage: String) -> Bool {
        return self.messageRepository.createMessageForFriend(messageText: textMessage, friend: self.friend, date: NSDate(), isSender: true)
    }
    
    func performFetch() {
        do {
            try self.chatMesageFetchResultController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func bindToDelegate(delegate: NSFetchedResultsControllerDelegate) {
        self.chatMesageFetchResultController.delegate = delegate
    }
    
    func messagesCount() -> Int {
        if let count = self.chatMesageFetchResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    func messageAt(indexPath: IndexPath) -> Message {
        return self.chatMesageFetchResultController.object(at: indexPath)
    }
    
}
