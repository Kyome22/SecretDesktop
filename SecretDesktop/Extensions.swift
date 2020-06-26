//
//  Extensions.swift
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

func logput(_ item: Any..., file: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
    Swift.print("Log: \(file):Line\(line):\(function)", item)
    #endif
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}

extension NSColor {
    static let url = NSColor(named: "url")!
}

extension NSMenuItem {
    func setAction(target: AnyObject, selector: Selector) {
        self.target = target
        self.action = selector
    }
}

extension NSScreen {
    var displayID: CGDirectDisplayID {
        let key = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
        return deviceDescription[key] as! CGDirectDisplayID
    }
}

extension CGImage {
    static func background(_ displayID: CGDirectDisplayID, _ windowID: CGWindowID) -> CGImage? {
        let dBounds = CGDisplayBounds(displayID)
        let windowOptions: CGWindowListOption = [.optionOnScreenOnly, .optionOnScreenBelowWindow]
        let list = CGWindowListCopyWindowInfo(windowOptions, windowID) as? [NSDictionary]
        let dict = list?.first { (dict) -> Bool in
            guard let owner = dict[kCGWindowOwnerName] as? String,
                let name = dict[kCGWindowName] as? String,
                let bounds = dict[kCGWindowBounds] as? NSDictionary,
                let x = bounds["X"] as? CGFloat,
                let y = bounds["Y"] as? CGFloat else {
                    return false
            }
            return owner == "Dock"
                && name.hasPrefix("Desktop")
                && CGPoint(x: x, y: y).equalTo(dBounds.origin)
        }
        guard let id = dict?[kCGWindowNumber] as? CGWindowID else { return nil }
        let imageOptions: CGWindowImageOption = [.bestResolution, .boundsIgnoreFraming]
        return CGWindowListCreateImage(dBounds, .optionIncludingWindow, id, imageOptions)
    }
}
