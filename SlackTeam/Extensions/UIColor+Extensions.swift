//
//  UIColor+Extensions.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/11/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }

    static func slackPurp(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 97.0/255.0, green: 92.0/255.0, blue: 110.0/255.0, alpha: alpha)
    }
}
