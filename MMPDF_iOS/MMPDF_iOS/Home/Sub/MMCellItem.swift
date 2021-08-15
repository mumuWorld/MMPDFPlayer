//
//  MMCellItem.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/15.
//

import Foundation

struct MMCellItem {
    
    var title: String = ""
    
    var handleAction: ((_ param: Any) -> Void)?
}
