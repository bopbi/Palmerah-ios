//
//  Message+CoreDataProperties.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 9/17/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isSender: Bool
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}
