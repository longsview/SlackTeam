//
//  CoreDataContextCoordinator.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/12/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation
import CoreData

// This class coordinates and merges changes in the read and write
// managed object contexts. When writing core data
// objects use CoreDataContextCoordinator.shared.backgroundContext
// When reading use CoreDataContextCoordinator.shared.mainQueueContext
//
class CoreDataContextCoordinator : NSObject {
    let mainQueueContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    let notification = NotificationCenter.default
    
    static let shared = CoreDataContextCoordinator()
    
    override init() {
        let container = NSPersistentContainer(name: "SlackTeam")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        mainQueueContext = container.viewContext
        mainQueueContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = mainQueueContext.persistentStoreCoordinator
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        super.init()

        notification.addObserver(self, selector: #selector(CoreDataContextCoordinator.mainQueueManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: mainQueueContext)
        notification.addObserver(self, selector: #selector(CoreDataContextCoordinator.backgroundQueueManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext)
    }
    
    deinit {
        notification.removeObserver(self)
    }

    @objc
    func mainQueueManagedObjectContextDidSave(_ notification : Notification) {
        backgroundContext.perform { [weak self] () -> Void in
            self?.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    @objc
    func backgroundQueueManagedObjectContextDidSave(_ notification : Notification) {
        mainQueueContext.perform { [weak self] () -> Void in
            self?.mainQueueContext.mergeChanges(fromContextDidSave: notification)
        }
    }
}
