//
//  MMThroughTouchView.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/18.
//

import UIKit

class MMThroughTouchView: UIView {
    
    var lastEvent: UIEvent?
    
    var touchHandle: ((_ point: CGPoint) -> Void)?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
             if lastEvent == event {
                return nil
            }
            lastEvent = event
            touchHandle?(point)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.secondTime(value: 1)) {
                self.lastEvent = nil
            }
            return nil
        }
        return hitView
    }
}
