//
//  SecretPanel.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2020/06/27.
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

class SecretPanel: NSPanel {

    var displayID: CGDirectDisplayID
    var imageView: NSImageView

    init(_ displayID: CGDirectDisplayID, _ frame: NSRect) {
        self.displayID = displayID
        imageView = NSImageView(frame: NSRect(origin: .zero, size: frame.size))
        super.init(contentRect: frame,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: true)
        let level = 1 + Int(CGWindowLevelForKey(CGWindowLevelKey.desktopIconWindow))
        self.level = NSWindow.Level(level)
        self.collectionBehavior = [.canJoinAllSpaces,
                                   .ignoresCycle,
                                   .transient,
                                   .fullScreenAuxiliary,
                                   .fullScreenDisallowsTiling]
        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor(white: 0.0, alpha: 0.01)
        self.contentView?.addSubview(imageView)
    }

    func setImage() {
        let windowID = CGWindowID(windowNumber)
        if let cgImage = CGImage.background(displayID, windowID) {
            imageView.image = NSImage(cgImage: cgImage, size: frame.size)
        }
    }

}
