//
//  ComposeViewModel.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 12/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class ComposeViewModel : NSObject, NSFetchedResultsControllerDelegate {
    
    let rxFetchFriendsResultController : RxFetchResultsController<Friend>
    
    init(friendRepository : FriendRepository) {
        rxFetchFriendsResultController = RxFetchResultsController(fetchResultController: friendRepository.getFriendsFetchResultController())
    }
    
    func bind() {
        rxFetchFriendsResultController.fetchRequest()
    }
    
    func numberOfItemInSection() ->Int {
        return self.rxFetchFriendsResultController
            .sectionAt(sectionNumber: 0)
            .numberOfObjects
    }
    
    func friendAt(indexPath: IndexPath) -> Friend? {
        return self.rxFetchFriendsResultController
            .object(at: indexPath)
    }
}
