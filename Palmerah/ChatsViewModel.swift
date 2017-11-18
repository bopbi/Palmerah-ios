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

class ChatsViewModel : NSObject, NSFetchedResultsControllerDelegate {
    
    let rxFetchRecentsResultController : RxFetchResultController<Friend>
    
    init(friendRepository : FriendRepository) {
        rxFetchRecentsResultController = RxFetchResultController(fetchResultController: friendRepository.getRecentsFetchResultController())
    }
    
    func bind() {
        rxFetchRecentsResultController.fetchRequest()
    }
    
    func numberOfItemInSection() ->Int {
        do {
            return try self.rxFetchRecentsResultController
                .sectionAt(sectionNumber: 0)
                .map { (result) -> Int in
                    result.numberOfObjects
                }
                .toBlocking()
                .single()!
        } catch let err {
            print(err)
        }
        return 0
    }
    
    func lastMessageAt(indexPath : IndexPath) -> Message? {
        do {
            return try self.rxFetchRecentsResultController.object(at: indexPath)
                .toBlocking()
                .single()?
                .lastMessage
        } catch let err {
            print(err)
        }
        return nil
    }
    
    func friendAt(indexPath: IndexPath) -> Friend? {
        do {
            return try self.rxFetchRecentsResultController
                .object(at: indexPath)
                .toBlocking()
                .single()
        } catch let err {
            print(err)
        }
        return nil
    }
    
    
}
