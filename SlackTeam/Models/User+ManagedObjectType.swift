//
//  User+ManagedObjectType.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/11/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import CoreData

extension User: ManagedObjectType {
    
    public static var entityName: String {
        return "User"
    }
}
