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

final class SecretPanel: NSPanel {
    private var displayID: CGDirectDisplayID
    private var imageView: NSImageView
    private var dummyImageView: NSImageView

    init(_ displayID: CGDirectDisplayID, _ frame: NSRect) {
        self.displayID = displayID
        imageView = NSImageView(frame: NSRect(origin: .zero, size: frame.size))
        dummyImageView = NSImageView(frame: NSRect(origin: .zero, size: frame.size))
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
        self.alphaValue = 0.0
        self.backgroundColor = NSColor(white: 0.0, alpha: 0.01)
        guard let contentView = self.contentView else { return }
        contentView.addSubview(dummyImageView)
        contentView.addSubview(imageView)

        dummyImageView.translatesAutoresizingMaskIntoConstraints = false
        dummyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dummyImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dummyImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dummyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func setImage() {
        let windowID = CGWindowID(windowNumber)
        guard let cgImage = CGImage.background(displayID, windowID) else {
            return
        }
        let nsImage = NSImage(cgImage: cgImage, size: frame.size)
        dummyImageView.image = nsImage
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            self.imageView.animator().alphaValue = 0.0
        } completionHandler: {
            self.imageView.image = nsImage
            self.imageView.alphaValue = 1.0
            self.dummyImageView.image = nil
        }
    }

    func fadeIn() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            self.animator().alphaValue = 1.0
        }
    }

    func fadeOut() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            self.animator().alphaValue = 0.0
        } completionHandler: {
            self.close()
        }
    }
}
