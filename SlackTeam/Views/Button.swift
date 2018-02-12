//
//  Button.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/11/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    fileprivate var handler: (() -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
    }
    
    convenience init(_ handler: @escaping (() -> Void)) {
        self.init(coder: NSCoder())
        self.handler = handler
        addTarget(self, action: #selector(execute), for: .touchUpInside)
    }
    
    @objc
    func execute() {
        guard let handler = handler else { return }
        handler()
    }
}
