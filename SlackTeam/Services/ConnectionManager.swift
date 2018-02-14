//
//  ConnectionManager.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/13/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import Foundation
import AFNetworking

enum ConnectionChanged: String {
    case connected = "ConnectionEstablishedMessage"
    case disconnected = "DisconnectedMessage"
    
    func notification() -> Notification {
        return Notification(name: notificationName())
    }

    func notificationName() -> Notification.Name {
        return Notification.Name(rawValue: rawValue)
    }
}

// Used to broadcast connection changes
// and to get the current state of the connection
//
class ConnectionManager {
    
    static let shared = ConnectionManager()
    
    init() {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { status in
            DispatchQueue.main.async {
                if status == .notReachable {
                    NotificationCenter.default.post(ConnectionChanged.disconnected.notification())
                } else {
                    NotificationCenter.default.post(ConnectionChanged.connected.notification())
                }
            }
        }
    }
    
    var hasConnection: Bool {
        return AFNetworkReachabilityManager.shared().isReachable
    }
}
