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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setImage(_ frame: CGRect) {
        imageView.image = NSImage.background(frame)
    }

}
