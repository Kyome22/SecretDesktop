//
//  SecretWC.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class SecretWC: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.isOpaque = false
        let level = 1 + Int(CGWindowLevelForKey(CGWindowLevelKey.desktopIconWindow))
        self.window!.level = NSWindow.Level(level)
        self.window!.collectionBehavior = [.canJoinAllSpaces,
                                           .ignoresCycle,
                                           .transient,
                                           .fullScreenAuxiliary,
                                           .fullScreenDisallowsTiling]
        self.window?.backgroundColor = NSColor.yellow.withAlphaComponent(0.4)
    }
    
    func set(_ frame: CGRect) {
        self.window!.setFrame(frame, display: true)
        setImage(frame)
    }
    
    func setImage(_ frame: CGRect) {
        (self.contentViewController as! SecretVC).setImage(frame)
    }

}

