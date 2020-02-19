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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setImage()
    }
    
    func setImage() {
        let image = NSImage.desktopPicture(targetPoint: self.view.window!.frame.origin)
        imageView.image = image?.resize(targetSize: self.view.bounds.size)
    }

}

