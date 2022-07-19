//
//  AppKit+Extensions.swift
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

import AppKit

extension NSColor {
    static let url = NSColor(named: "url")!
}

extension NSScreen {
    var displayID: CGDirectDisplayID {
        let key = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
        return deviceDescription[key] as! CGDirectDisplayID
    }
}

extension NSStatusItem {
    static var `default`: NSStatusItem {
        return NSStatusBar.system.statusItem(withLength: Self.variableLength)
    }
}

extension NSMenuItem {
    var isOn: Bool {
        return self.state == .on
    }
}