//
//  WebService.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/10/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation
import CoreData
import AFNetworking

class WebService {
    
    static let token = "xoxp-4698769766-4698769768-266771053075-66c3498cd17d3c736b94fdd14307ef20"

    static func getUsers(completion: @escaping ([User], Error?) -> Void) {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.get("https://slack.com/api/users.list",
            parameters: ["token": token],
            progress: nil,
            success: { (operation, responseObject) in
                let moc = CoreDataContextCoordinator.shared.backgroundContext
                moc.perform {
                    guard let responseObject = responseObject as? [String: Any],
                        let members = responseObject["members"] as? [[String: Any]] else { return }
                    
                    var result = [User]()
                    for member in members {
                        guard let userId = member["id"] as? String,
                            let user = User.createOrUpdate(inMoc: moc,
                                                           userId: userId,
                                                           data: member) else { continue }
                        result.append(user)
                    }
                    moc.saveOrRollback()
                    DispatchQueue.main.async {
                        completion(result, nil)
                    }
                }
        },
            failure: { (operation, error) in
                completion([User](), error)
        })
    }
}
