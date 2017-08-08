//
//  FriendRepository.swift
//  Palmerah
//
//  Created by Bobby Adi Prabowo on 7/30/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData

class FriendRepository: NSObject {
    
    init(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
    }
    
}
