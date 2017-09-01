//
//  ChatRoomViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit

class ChatRoomViewModel {
    
    let friendRepository : FriendRepository
    let friend : Friend
    let title : String
    
    init(friend : Friend, friendRepository : FriendRepository) {
        self.friend = friend
        self.title = self.friend.name!
        self.friendRepository = friendRepository
    }
    
    func insertMessage(textMessage: String) -> Bool {
        return self.friendRepository.createMessageForFriend(messageText: textMessage, friend: self.friend, date: NSDate(), isSender: true)
    }
    
}
