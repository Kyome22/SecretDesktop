//
//  SecretWC.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class SecretWC: NSWindowController, NSWindowDelegate {
    
    private var frame = NSRect.zero

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.delegate = self
        self.window!.isOpaque = false
        self.window!.backgroundColor = NSColor(hex: "000000", alpha: 0.01)
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
    
    func windowWillClose(_ notification: Notification) {
        self.contentViewController = nil
    }
    
    func changedActiveSpace() {
        guard let vc = self.contentViewController as? SecretVC else {
            return
        }
        vc.changedActiveSpace()
    }

}

