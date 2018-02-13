//
//  UserListViewModel.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/12/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation
import CoreData

class UserListViewModel: UserListViewModelProtocol {

    var managedObjectContext = CoreDataContextCoordinator.shared.mainQueueContext
    fileprivate weak var viewDelegate: UserListViewDelegate?
    
    var filterString: String? = nil {
        didSet {
            // delete cache before updating sort descriptor
            //
            var predicate: NSPredicate? = nil
            if let filterString = filterString, !filterString.isEmpty {
                predicate = NSPredicate(format: "name contains[cd] %@ OR realName contains[cd] %@ OR title contains[cd] %@",
                                        filterString, filterString, filterString)
            }
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Master")
            fetchedResultsController.fetchRequest.predicate = predicate
            do {
                try fetchedResultsController.performFetch()
            } catch {}
        }
    }
    
    var sortString: String = "" {
        didSet {
            // delete cache before updating sort descriptor
            //
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Master")
            let sortDescriptor = NSSortDescriptor(key: sortString, ascending: true)
            fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                try fetchedResultsController.performFetch()
            } catch {}
        }
    }
    
    var userCount: Int {
        guard let sectionInfo = fetchedResultsController.sections?[0] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func userAtIndex(_ index: Int) -> User? {
        return fetchedResultsController.object(at: IndexPath(row: index, section: 0))
    }
    
    
    init(view: UserListViewDelegate) {
        viewDelegate = view
        fetchedResultsController.delegate = view

        // Hit the API to refresh the list of users
        //
        WebService.getUsers() { [weak self] (users, error) in
            self?.viewDelegate?.loaded()
        }
    }

    var _fetchedResultsController: NSFetchedResultsController<User>? = nil
    var fetchedResultsController: NSFetchedResultsController<User> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // Fetch request is sorted by name first time through
        //
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Master")
        let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = nil
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: managedObjectContext,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: "Master")
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
        }
        
        return _fetchedResultsController!
    }
}
