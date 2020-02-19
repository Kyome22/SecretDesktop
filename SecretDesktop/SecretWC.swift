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
        self.window!.level = NSWindow.Level(Int(CGWindowLevelForKey(CGWindowLevelKey.normalWindow)) - 1)
        self.window!.collectionBehavior = [.canJoinAllSpaces,
                                           .ignoresCycle,
                                           .transient,
                                           .fullScreenAuxiliary,
                                           .fullScreenDisallowsTiling]
    }
    
    func setWindowFrame(_ frame: NSRect) {
        self.window!.setFrame(frame, display: true)
    }
    
    func changedActiveSpace() {
        (self.contentViewController as! SecretVC).setImage()
    }

}

