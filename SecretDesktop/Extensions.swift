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
    static var mainHeight: CGFloat {
        return main?.frame.height ?? CGFloat.zero
    }
    static var totalRect: CGRect {
        return screens.reduce(CGRect.zero) { (result, screen) -> CGRect in
            return result.union(screen.frame)
        }
    }
}

extension NSImage {
    static func background(_ frame: CGRect) -> NSImage? {
        guard var list = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [NSDictionary] else {
            return nil
        }
        let origin = CGPoint(x: frame.minX, y: NSScreen.mainHeight - frame.maxY)
        list = list.compactMap({ (dict) -> NSDictionary? in
            guard let name = dict[kCGWindowName] as? String, name.contains("Desktop Picture") else { return nil }
            let bounds = dict[kCGWindowBounds] as! NSDictionary
            guard CGPoint(x: bounds["X"] as! CGFloat, y: bounds["Y"] as! CGFloat).equalTo(origin) else { return nil }
            return dict
        })
        guard
            let dict = list.first, let id = dict[kCGWindowNumber] as? CGWindowID,
            let cgImage = CGWindowListCreateImage(CGRect.null, .optionIncludingWindow, id, .boundsIgnoreFraming)
            else { return nil }
        return NSImage(cgImage: cgImage, size: frame.size)
    }
}
