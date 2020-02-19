//
//  Extensions.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

extension NSMenuItem {
    func setAction(target: AnyObject, selector: Selector) {
        self.target = target
        self.action = selector
    }
}

extension NSImage {
    static func desktopPicture(targetPoint: CGPoint) -> NSImage? {
        guard let rawList: NSArray = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) else {
            return nil
        }
        var windowList = rawList as! [NSDictionary]
        windowList = windowList.filter { (data) -> Bool in
            if let owner = data[kCGWindowOwnerName] as? String, owner == "Dock" {
                if let name = data[kCGWindowName] as? String, name.contains("Desktop Picture") {
                    return true
                }
            }
            return false
        }
        var windows = [(rect: CGRect, id: UInt32)]()
        for window in windowList {
            let bounds = window[kCGWindowBounds] as! NSDictionary
            let X = bounds["X"] as! CGFloat
            let Y = bounds["Y"] as! CGFloat
            let W = bounds["Width"] as! CGFloat
            let H = bounds["Height"] as! CGFloat
            windows.append((rect: CGRect(x: X, y: Y, width: W, height: H),
                            id: window[kCGWindowNumber] as! UInt32))
        }
        let origin = windows.filter({ (window) -> Bool in
            return window.rect.origin == CGPoint.zero
        })[0]
        for n in (0 ..< windows.count) {
            var rect = windows[n].rect
            rect.origin.y = origin.rect.height - rect.origin.y - rect.height
            if rect.contains(targetPoint) {
                guard let cgImage = CGWindowListCreateImage(windows[n].rect, .optionIncludingWindow, windows[n].id, .boundsIgnoreFraming) else {
                    break
                }
                let nsImage = NSImage(cgImage: cgImage, size: rect.size)
                nsImage.resizingMode = NSImage.ResizingMode.stretch
                return nsImage
            }
        }
        return nil
    }
    
    public func resize(targetSize: CGSize) -> NSImage? {
        let wRatio = targetSize.width / self.size.width
        let hRatio = targetSize.height / self.size.height
        var newSize: CGSize
        if(wRatio > hRatio) {
            newSize = CGSize(width: self.size.width * hRatio,
                             height: self.size.height * hRatio)
        } else {
            newSize = CGSize(width: self.size.width * wRatio,
                             height: self.size.height * wRatio)
        }
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let cgImage = NSBitmapImageRep(data: imageData)?.cgImage else { return nil }
        guard let bitmapContext = CGContext(data: nil,
                                            width: Int(newSize.width),
                                            height: Int(newSize.height),
                                            bitsPerComponent: 8,
                                            bytesPerRow: 4 * Int(newSize.width),
                                            space: CGColorSpaceCreateDeviceRGB(),
                                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        bitmapContext.draw(cgImage, in: rect)
        guard let newImageRef = bitmapContext.makeImage() else { return nil }
        let newImage = NSImage(cgImage: newImageRef, size: newSize)
        return newImage
    }
}
