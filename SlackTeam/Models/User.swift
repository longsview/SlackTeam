//
//  User.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/10/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation
import CoreData

public final class User: ManagedObject {
    
    static func createOrUpdate(inMoc moc: NSManagedObjectContext,
                                  userId: String,
                                    data: [String: Any]? = nil) -> User? {

        let predicate = NSPredicate(format: "userID = %@", userId)
        guard let user = User.findOrCreate(inContext: moc,
                                   matchingPredicate: predicate,
                                  configureNewObject: { user in
                                    
        }) else { return nil }
        
        if let data = data {
            user.loadFromData(data)
        }
        
        return user
    }
    
    func loadFromData(_ data: [String: Any]) {
        userID = data["id"] as? String
        name = data["name"] as? String
        realName = data["real_name"] as? String
        
        // initialize the color components
        //
        //UIColor * color = [UIColor colorFromHexString:dictionary[@"color"]];
        //const CGFloat *components = CGColorGetComponents(color.CGColor);
        //self.colorR = [NSNumber numberWithFloat:components[0]];
        //self.colorG = [NSNumber numberWithFloat:components[1]];
        //self.colorB = [NSNumber numberWithFloat:components[2]];
        
        // store profile information
        //
        if let profile = data["profile"] as? [String: Any] {
            title = profile["title"] as? String
            firstName = profile["first_name"] as? String
            lastName = profile["last_name"] as? String
            skype = profile["skype"] as? String
            email = profile["email"] as? String
            phone = profile["phone"] as? String
            
            icon24 = profile["image_24"] as? String
            icon32 = profile["image_32"] as? String
            icon48 = profile["image_48"] as? String
            icon72 = profile["image_72"] as? String
            icon192 = profile["image_192"] as? String
        }
        
        userDeleted = data["deleted"] as? NSNumber
    }
}
