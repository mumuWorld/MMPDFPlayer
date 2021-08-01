//
//  MMCustomNaviBar.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//  Copyright © 2021 MuMu. All rights reserved.
//

import UIKit

class MMCustomNaviBar: UIView {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var handleDismiss: (() -> Void)?
    

    @IBAction func handleClick(_ sender: UIButton) {
        handleDismiss?()
    }
}
