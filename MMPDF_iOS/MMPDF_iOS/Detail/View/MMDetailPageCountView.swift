//
//  MMDetailPageCountView.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/14.
//

import UIKit

class MMDetailPageCountView: UIView {

    lazy var countLabel: UILabel = {
        let item = UILabel()
        item.textAlignment = .center
        return item
    }()

    var maxWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        layer.cornerRadius = 15
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.height.centerY.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: maxWidth, height: 30)
    }
    
    var count: Int = 0 {
        didSet {
            countLabel.text = String(format: "%d/%d", count, count)
            maxWidth = countLabel.intrinsicContentSize.width + vNormalSpacing * 2
            invalidateIntrinsicContentSize()
        }
    }
    
    var curPage: Int = 0 {
        didSet {
            countLabel.text = String(format: "%d/%d", curPage, count)
        }
    }
    
}
