//
//  ManagedObject.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/10/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation
import CoreData

open class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
}

extension ManagedObjectType {
    public static var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: entityName)
    }
}

// This is the base class for all new
// Core Data managed object types. Make
// sure you subclass from this class.
//
extension ManagedObjectType where Self: ManagedObject {

    // returns just the entity name of the managed object type
    //
    public static var entityName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }
    
    // Finds object matching the given predicate
    // and creates a new object if it does not exist
    //
    public static func findOrCreate(inContext moc: NSManagedObjectContext,
                                    matchingPredicate predicate: NSPredicate) -> Self? {
        if let obj = findOrFetch(inContext: moc,
                                 matchingPredicate: predicate) {
            return obj
        }
        
        if let newObject: Self = moc.insertObject() {
            return newObject
        }
        return nil
    }
    
    // Finds object matching the given predicate
    // and returns a nil object if it can't find it
    //
    public static func findOrFetch(inContext moc: NSManagedObjectContext,
                                   matchingPredicate predicate: NSPredicate) -> Self? {
        if let obj = materializedObject(inContext: moc,
                                        matchingPredicate: predicate) {
            return obj
        }
        
        let result = fetch(inContext: moc) { request in
            request.predicate = predicate
            request.returnsObjectsAsFaults = false
            request.fetchLimit = 2
        }
        
        // there should only be one instance
        // of these objects matching the given predicate
        //
        switch result.count {
        case 0: return nil
        case 1: return result.first
            
        default:
            assertionFailure("Returned multiple objects, expected max 1")
            return nil
        }
    }
    
    public static func fetch(inContext moc: NSManagedObjectContext,
                             configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        configurationBlock(request)
        
        do {
            if let result = try moc.fetch(request) as? [Self] {
                return result
            } else {
                assertionFailure("Fetched objects have wrong type")
            }
        } catch let e as NSError {
            assertionFailure("Fetched objects have wrong type due to error: \(e)")
        }
        
        return []
    }
    
    public static func materializedObject(inContext moc: NSManagedObjectContext,
                                          matchingPredicate predicate: NSPredicate) -> Self? {
        
        for object in moc.registeredObjects where !object.isFault && !object.isDeleted {
            guard let instance = object as? Self else { continue }
            
            if predicate.evaluate(with: instance) {
                return instance
            }
        }
        
        return nil
    }
}
