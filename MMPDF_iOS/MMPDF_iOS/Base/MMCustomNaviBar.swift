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
    
    @IBOutlet weak var containerView: UIView!
    
    var handleDismiss: (() -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = MMColors.color_nav_1
    }

    @IBAction func handleClick(_ sender: UIButton) {
        handleDismiss?()
    }
    
    func mm_addSubView(_ view: UIView) -> Void {
        containerView.addSubview(view)
    }
}
