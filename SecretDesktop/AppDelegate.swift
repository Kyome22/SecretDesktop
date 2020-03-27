//
//  AppDelegate.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa
import SpiceKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var hideItem: NSMenuItem!
    private var desktops = [SecretWC]()
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
        toggleHide()
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
            desktops.forEach { (wc) in
                wc.close()
            }
            desktops.removeAll()
            hideItem.state = NSControl.StateValue.off
        } else {
            let sb = NSStoryboard(name: "Secret", bundle: nil)
            for screen in NSScreen.screens {
                let wc = sb.instantiateInitialController() as! SecretWC
                wc.set(screen.frame)
                wc.showWindow(nil)
                desktops.append(wc)
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
        guard let screen = NSScreen.main else { return }
        desktops.forEach { (wc) in
            guard let window = wc.window else { return }
            if window.frame.origin.equalTo(screen.frame.origin) {
                wc.setImage(window.frame)
            }
        }
    }
    
}
