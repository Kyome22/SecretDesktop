//
//  SecretWC.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright 2020 Takuto Nakamura
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
        self.window?.backgroundColor = NSColor.clear
    }
    
    func set(_ frame: CGRect) {
        self.window!.setFrame(frame, display: true)
        setImage(frame)
    }
    
    func setImage(_ frame: CGRect) {
        (self.contentViewController as! SecretVC).setImage(frame)
    }

}

