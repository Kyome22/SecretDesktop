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
import Combine
import SpiceKey

class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuManager: MenuManager?
    private var spiceKey: SpiceKey?
    private var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menuManager = MenuManager()

        spiceKey = SpiceKey(KeyCombination(.h, .sftCmd), keyDownHandler: { [weak self] in
            self?.menuManager?.toggleHide()
        })
        spiceKey?.register()

        let wsnc = NSWorkspace.shared.notificationCenter
        wsnc.publisher(for: NSWorkspace.activeSpaceDidChangeNotification)
            .sink(receiveValue: { [weak self] notification in
                self?.menuManager?.resetPanels()
            })
            .store(in: &cancellables)
        wsnc.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink(receiveValue: { [weak self] notification in
                self?.menuManager?.closePanels()
            })
            .store(in: &cancellables)

        DispatchQueue.main.async {
            self.menuManager?.toggleHide()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        spiceKey?.unregister()
    }
}
