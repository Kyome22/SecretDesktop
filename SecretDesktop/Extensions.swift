//
//  Extensions.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

extension NSColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
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
        for window in windowList {
            let bounds = window[kCGWindowBounds] as! NSDictionary
            let X = bounds["X"] as! CGFloat
            let Y = bounds["Y"] as! CGFloat
            let W = bounds["Width"] as! CGFloat
            let H = bounds["Height"] as! CGFloat
            let rect = CGRect(x: X, y: Y, width: W, height: H)
            if rect.contains(targetPoint) {
                let id = window[kCGWindowNumber] as! UInt32
                guard let cgImage = CGWindowListCreateImage(rect, .optionIncludingWindow, id, .boundsIgnoreFraming) else {
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

