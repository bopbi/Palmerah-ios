//
//  RxFetchController.swift
//  Palmerah
//
//  Created by Bobby Prabowo on 18/11/17.
//  Copyright © 2017 Bobby Adi Prabowo. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class RxFetchResultsController<ResultType>: NSObject, NSFetchedResultsControllerDelegate where ResultType : NSFetchRequestResult {
    
    private let fetchResultController : NSFetchedResultsController<ResultType>
    let rowUpdateSubject = PublishSubject<DataUpdateEvent>()
    let changeContentSubject = PublishSubject<Bool>()
    
    init(fetchResultController : NSFetchedResultsController<ResultType>) {
        self.fetchResultController = fetchResultController
    }
    
    func fetchRequest() {
        self.fetchResultController.delegate = self
        do {
            try self.fetchResultController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        self.rowUpdateSubject.onNext(DataUpdateEvent(indexPath: indexPath, type: type, newIndexPath: newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.changeContentSubject.onNext(true)
    }
    
    func object(at indexPath: IndexPath) -> ResultType {
        return self.fetchResultController.object(at: indexPath)
    }
    
    func sectionAt(sectionNumber: Int) -> NSFetchedResultsSectionInfo {
        return self.fetchResultController.sections![sectionNumber]
    }
    
    struct DataUpdateEvent {
        var indexPath: IndexPath?
        var type: NSFetchedResultsChangeType
        var newIndexPath: IndexPath?
    }
}
