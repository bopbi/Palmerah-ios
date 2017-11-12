//
//  ChatRoomViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class ChatRoomViewModel : NSObject, NSFetchedResultsControllerDelegate {
    
    private let messageRepository : MessageRepository
    private let chatMesageFetchResultController : NSFetchedResultsController<Message>
    private let friend : Friend
    let title : String
    
    let rowUpdateSubject = PublishSubject<ChatRoomRowUpdateEvent>()
    let changeContentSubject = PublishSubject<Bool>()
    
    init(friend : Friend, messageRepository : MessageRepository) {
        self.friend = friend
        self.title = self.friend.name!
        self.messageRepository = messageRepository
        self.chatMesageFetchResultController = self.messageRepository.getChatMessagesFetchResultController(friend: friend)
        
    }
    
    func insertMessage(textMessage: String) -> Bool {
        return self.messageRepository.createMessageForFriend(messageText: textMessage, friend: self.friend, date: NSDate(), isSender: true)
    }
    
    func onBind() {
        self.chatMesageFetchResultController.delegate = self
        do {
            try self.chatMesageFetchResultController.performFetch()
        } catch let err {
            print(err)
        }
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        rowUpdateSubject.onNext(ChatRoomRowUpdateEvent(indexPath: indexPath, type: type, newIndexPath: newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changeContentSubject.onNext(true)
    }
    
    struct ChatRoomRowUpdateEvent {
        var indexPath: IndexPath?
        var type: NSFetchedResultsChangeType
        var newIndexPath: IndexPath?
    }
}
