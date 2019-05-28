//
//  AboutWC.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/28.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class AboutWC: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.delegate = self
    }
    
    func windowWillClose(_ notification: Notification) {
        self.contentViewController = nil
        AppDelegate.shared.aboutWC = nil
    }

}
