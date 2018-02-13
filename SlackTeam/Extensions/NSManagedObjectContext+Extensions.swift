//
//  NSManagedObjectContext+Extensions.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/10/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

    public func insertObject<A: ManagedObject>() -> A? where A: ManagedObjectType {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            assertionFailure("Wrong object type")
            return nil
        }
        return obj
    }
    
    public func retrieveObject<A: ManagedObject>(with objectID: NSManagedObjectID) -> A? {
        return (try? existingObject(with: objectID)) as? A
    }

    @discardableResult
    public func saveOrRollback() -> Bool {
        do {
            if hasChanges {
                try save()
            }
            return true
        } catch let error as NSError {
            debugPrint("MOC save failed : \(error), \(error.userInfo)")
            rollback()
            return false
        }
    }
}
