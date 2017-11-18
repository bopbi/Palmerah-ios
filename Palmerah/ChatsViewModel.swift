//
//  RecentsViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/1/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxBlocking

class ChatsViewModel {
    
    let rxFetchRecentsResultController : RxFetchResultsController<Friend>
    
    init(friendRepository : FriendRepository) {
        rxFetchRecentsResultController = RxFetchResultsController(fetchResultController: friendRepository.getRecentsFetchResultController())
    }
    
    func bind() {
        rxFetchRecentsResultController.fetchRequest()
    }
    
    func numberOfItemInSection() ->Int {
        return self.rxFetchRecentsResultController
            .sectionAt(sectionNumber: 0)
            .numberOfObjects
    }
    
    func lastMessageAt(indexPath : IndexPath) -> Message? {
        return self.rxFetchRecentsResultController.object(at: indexPath).lastMessage
    }
    
    func friendAt(indexPath: IndexPath) -> Friend? {
        return self.rxFetchRecentsResultController
            .object(at: indexPath)
    }
    
    
}
