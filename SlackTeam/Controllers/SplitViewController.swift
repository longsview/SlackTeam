//
//  SplitViewController.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/12/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    override var shouldAutorotate: Bool {
        // disable rotation on iPhone
        //
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return true
        }
        return false
    }
}
