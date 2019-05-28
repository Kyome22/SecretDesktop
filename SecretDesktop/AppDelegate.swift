//
//  AppDelegate.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let storyboard = NSStoryboard(name: "Main", bundle: nil)
    private var hideItem: NSMenuItem?
    private var desktops = [SecretWC]()
    private var isSecret: Bool = false
    public var aboutWC: AboutWC? = nil
    
    class var shared: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = menu
        statusItem.button?.image = NSImage(imageLiteralResourceName: "StatusIcon")
        
        hideItem = menu.item(withTag: 0)
        hideItem?.target = self
        hideItem?.action = #selector(AppDelegate.hide)
        
        let aboutItem = menu.item(withTag: 1)
        aboutItem?.target = self
        aboutItem?.action = #selector(AppDelegate.openAbout)
        
        let quitItem = menu.item(withTag: 2)
        quitItem?.target = self
        quitItem?.action = #selector(AppDelegate.quit)
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(changedActiveSpace(_:)),
                                                          name: NSWorkspace.activeSpaceDidChangeNotification,
                                                          object: nil)
        hide()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @objc func hide() {
        if isSecret {
            desktops.forEach { (wc) in
                wc.close()
            }
            desktops.removeAll()
            hideItem?.state = NSControl.StateValue.off
        } else {
            Swift.print(NSScreen.screens.count)
            for screen in NSScreen.screens {
                guard let wc = storyboard.instantiateController(withIdentifier: "SecretWindow") as? SecretWC else {
                    continue
                }
                desktops.append(wc)
                wc.setWindowFrame(screen.frame)
                wc.showWindow(self)
            }
            hideItem?.state = NSControl.StateValue.on
        }
        isSecret = !isSecret
    }
    
    @objc func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        if aboutWC == nil {
            aboutWC = storyboard.instantiateController(withIdentifier: "AboutWindow") as? AboutWC
            aboutWC?.showWindow(self)
        }
        aboutWC?.window?.orderFrontRegardless()
    }

    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func changedActiveSpace(_ notification: NSNotification) {
        let mainFrame = NSScreen.main!.frame
        desktops.forEach { (wc) in
            if wc.window!.frame == mainFrame {
                wc.changedActiveSpace()
            }
        }
    }

}

