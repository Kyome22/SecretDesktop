//
//  SecretVC.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/07.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class SecretVC: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    private var image: NSImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        image = NSImage.desktopPicture(targetPoint: self.view.window!.frame.origin)
        imageView.image = image?.resize(targetSize: self.view.bounds.size)
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    func changedActiveSpace() {
        image = NSImage.desktopPicture(targetPoint: self.view.window!.frame.origin)
        imageView.image = image?.resize(targetSize: self.view.bounds.size)
    }

}

