//
//  MMColors.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/15.
//

import UIKit

let MMColors = MMColor.shared

class MMColor: NSObject {
    
    static var shared: MMColor = MMColor()
    
    var color_bg_1: UIColor? = UIColor(named: "color_bg_1")
    
    var color_bg_2: UIColor? = UIColor(named: "color_bg_2")
}
