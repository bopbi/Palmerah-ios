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
    let rxChatMesageFetchResultController : RxFetchResultsController<Message>
    private let friend : Friend
    let title : String
    
    init(friend : Friend, messageRepository : MessageRepository) {
        self.friend = friend
        self.title = self.friend.name!
        self.messageRepository = messageRepository
        self.rxChatMesageFetchResultController = RxFetchResultsController(fetchResultController: self.messageRepository.getChatMessagesFetchResultController(friend: friend))
    }
    
    func insertMessage(textMessage: String) -> Bool {
        return self.messageRepository.createMessageForFriend(messageText: textMessage, friend: self.friend, date: NSDate(), isSender: true)
    }
    
    func bind() {
        self.rxChatMesageFetchResultController.fetchRequest()
    }
    
    func messagesCount() -> Int {
        return self.rxChatMesageFetchResultController
            .sectionAt(sectionNumber: 0)
            .numberOfObjects
    }
    
    func messageAt(indexPath: IndexPath) -> Message? {
        return self.rxChatMesageFetchResultController.object(at: indexPath)
    }
}
