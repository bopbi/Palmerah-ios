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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    struct ComposeRowUpdateEvent {
        var indexPath: IndexPath?
        var type: NSFetchedResultsChangeType
        var newIndexPath: IndexPath?
    }
}
