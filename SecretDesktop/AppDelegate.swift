//
//  AppDelegate.swift
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
import SpiceKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var hideItem: NSMenuItem!
    private var panels = [SecretPanel]()
    private var isSecret: Bool = false
    private var spiceKey: SpiceKey?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = menu
        statusItem.button?.image = NSImage(named: "StatusIcon")
        hideItem = menu.item(withTag: 0)!
        hideItem.setAction(target: self, selector: #selector(toggleHide))
        menu.item(withTag: 1)?.setAction(target: self, selector: #selector(openAbout))
        
        spiceKey = SpiceKey(KeyCombination(Key.h, ModifierFlags.sftCmd), keyDownHandler: {
            self.toggleHide()
        })
        spiceKey?.register()
        
        let wsnc = NSWorkspace.shared.notificationCenter
        wsnc.addObserver(self, selector: #selector(changedActiveSpace(_:)),
                         name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
        DispatchQueue.main.async {
            self.toggleHide()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        spiceKey?.unregister()
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        if isSecret {
            toggleHide()
        }
    }
    
    @objc func toggleHide() {
        if isSecret {
            panels.forEach { (panel) in
                panel.close()
            }
            panels.removeAll()
            hideItem.state = NSControl.StateValue.off
        } else {
            for screen in NSScreen.screens {
                let panel = SecretPanel(screen.displayID, screen.frame)
                panels.append(panel)
                panel.orderFrontRegardless()
            }
            panels.forEach { (panel) in
                panel.setImage()
            }
            hideItem.state = NSControl.StateValue.on
        }
        isSecret = !isSecret
    }
    
    @objc func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let mutableAttrStr = NSMutableAttributedString()
        var attr: [NSAttributedString.Key : Any] = [
            .foregroundColor : NSColor.textColor,
            .paragraphStyle : paragraph
        ]
        mutableAttrStr.append(NSAttributedString(string: "oss".localized, attributes: attr))
        let url = "https://github.com/Kyome22/SecretDesktop"
        attr = [.foregroundColor : NSColor.url, .link : url, .paragraphStyle : paragraph]
        mutableAttrStr.append(NSAttributedString(string: url, attributes: attr))
        let key = NSApplication.AboutPanelOptionKey.credits
        NSApp.orderFrontStandardAboutPanel(options: [key: mutableAttrStr])
    }
    
    @objc func changedActiveSpace(_ notification: NSNotification) {
        panels.forEach { (panel) in
            panel.setImage()
        }
    }
    
}
