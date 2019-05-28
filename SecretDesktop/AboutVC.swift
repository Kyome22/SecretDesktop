//
//  AboutVC.swift
//  SecretDesktop
//
//  Created by Takuto Nakamura on 2019/05/28.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class AboutVC: NSViewController {

    @IBOutlet weak var versionLbl: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            versionLbl.stringValue = version as! String
        }
    }
    
}
