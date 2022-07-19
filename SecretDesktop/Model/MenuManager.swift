//
//  MenuManager.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2022/07/19.
//  Copyright 2022 Takuto Nakamura
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
import SpiceKey

final class MenuManager: NSObject {
    private let statusItem = NSStatusItem.default
    private let menu = NSMenu()
    private let hideItem: NSMenuItem
    private var panels = [SecretPanel]()
    private var spiceKey: SpiceKey? = nil

    override init() {
        hideItem = NSMenuItem(title: "hide".localized,
                              action: #selector(toggleHide(_:)),
                              keyEquivalent: "")
        hideItem.keyEquivalent = Key.h.string
        hideItem.keyEquivalentModifierMask = ModifierFlags.sftCmd.flags
        hideItem.state = .off
        super.init()
        menu.addItem(hideItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "about".localized,
                     action: #selector(openAbout(_:)),
                     keyEquivalent: "")
        menu.addItem(withTitle: "quit".localized,
                     action: #selector(quit(_:)),
                     keyEquivalent: "")
        menu.items.forEach { menuItem in
            menuItem.target = self
        }
        statusItem.menu = menu
        statusItem.button?.image = NSImage(named: "StatusIcon")
    }

    @objc func toggleHide(_ sender: NSMenuItem) {
        let isSecret = sender.isOn
        if isSecret {
            panels.forEach { panel in
                panel.fadeOut()
            }
            panels.removeAll()
            sender.state = .off
        } else {
            for screen in NSScreen.screens {
                let panel = SecretPanel(screen.displayID, screen.frame)
                panels.append(panel)
                panel.orderFrontRegardless()
                panel.setImage()
                panel.fadeIn()
            }
            sender.state = .on
        }
    }

    func toggleHide() {
        self.toggleHide(hideItem)
    }

    func closePanels() {
        if hideItem.isOn {
            toggleHide()
        }
    }

    func resetPanels() {
        panels.forEach { panel in
            panel.setImage()
        }
    }

    @objc func openAbout(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        let mutableAttrStr = NSMutableAttributedString()
        var attr: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.textColor]
        mutableAttrStr.append(NSAttributedString(string: "oss".localized, attributes: attr))
        let url = "https://github.com/Kyome22/SecretDesktop"
        attr = [.foregroundColor: NSColor.url, .link: url]
        mutableAttrStr.append(NSAttributedString(string: url, attributes: attr))
        let key = NSApplication.AboutPanelOptionKey.credits
        NSApp.orderFrontStandardAboutPanel(options: [key: mutableAttrStr])
    }

    @objc func quit(_ sender: Any?) {
        NSApp.terminate(nil)
    }
}
