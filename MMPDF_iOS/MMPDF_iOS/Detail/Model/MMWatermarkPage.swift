//
//  MMWatermarkPage.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/27.
//

import UIKit
import PDFKit

class MMWatermarkPage: PDFPage {
    
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        // 原始内容
        super.draw(with: box, to: context)

        // 自定义内容
        UIGraphicsPushContext(context)
        context.saveGState()
        
        let pageBounds = self.bounds(for: box)
        context.translateBy(x: 0.0, y: pageBounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: CGFloat.pi / 4.0)

        let string: NSString = "宇宙超级无敌"
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: MMColors.color_show_1 as Any,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 64)
        ]
        string.draw(at: CGPoint(x:250, y:40), withAttributes: attributes)

        context.restoreGState()
        UIGraphicsPopContext()
    }
}
