//
//  User+CoreDataProperties.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/10/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation

extension User {
    
    @NSManaged public var userID: String?
    
    @NSManaged public var name: String?
    @NSManaged public var realName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var colorR: NSNumber?
    @NSManaged public var colorG: NSNumber?
    @NSManaged public var colorB: NSNumber?
    
    @NSManaged public var title: String?
    
    @NSManaged public var skype: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    
    @NSManaged public var icon24: String?
    @NSManaged public var icon32: String?
    @NSManaged public var icon48: String?
    @NSManaged public var icon72: String?
    @NSManaged public var icon192: String?
    
    @NSManaged public var userDeleted: NSNumber?
}
