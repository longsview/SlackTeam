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

extension ManagedObjectType where Self: ManagedObject {

    public static var entityName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }
    
    public static func insertNewObject(inContext moc: NSManagedObjectContext,
                                       configure: (Self) -> ()) -> Self? {
        if let newObject: Self = moc.insertObject() {
            configure(newObject)
            return newObject
        }
        return nil
    }
    
    public static func findOrCreate(inContext moc: NSManagedObjectContext,
                                    matchingPredicate predicate: NSPredicate,
                                    configureNewObject: (Self) -> ()) -> Self? {
        if let obj = findOrFetch(inContext: moc,
                                 matchingPredicate: predicate) {
            return obj
        }
        
        if let newObject: Self = moc.insertObject() {
            configureNewObject(newObject)
            return newObject
        }
        return nil
    }
    
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
