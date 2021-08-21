//
//  MMCurPageThumbnailView.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/21.
//

import UIKit

class MMCurPageThumbnailView: UIView {

    @IBOutlet weak var thunbnailImgView: UIImageView!

    private var touchPoint: CGPoint = .zero
    
    var touchChange: ((_ distance: CGFloat,_ showCancel: Bool) -> Void)?
    var touchBegin: (() -> Void)?
    var touchEnd: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        addGestureRecognizer(tap)
        backgroundColor = MMColors.color_bg_1?.withAlphaComponent(0.9)
    }
    
    @objc func handleGesture(sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        mm_print(point)
        switch sender.state {
        case .began:
            touchPoint = point
            touchBegin?()
        case .changed:
            let change = point.x - touchPoint.x
            sender.setTranslation(.zero, in: self)
            let showCancel = (touchPoint.y - point.y) > 10
            mm_print("变化->\(change)")
            touchChange?(change, showCancel)
        case .ended:
            mm_print("end")
            touchEnd?()
        case .cancelled:
            touchEnd?()
            mm_print("cancelled")
        default:
            break
        }
    }
}

class MMCurPageThumbnailTipView: UIView {
    
    lazy var thumView: MMCurPageThumbnailView = {
       let item = UINib.init(nibName: "MMCurPageThumbnailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MMCurPageThumbnailView
        return item
    }()
    
    @IBOutlet public weak var tipLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    var tipType: Int = 0 {
        didSet {
            if tipType == 0 {
                tipLabel.text = "上划取消跳转"
            } else {
                tipLabel.text = "松手取消跳转"
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        insertSubview(thumView, at: 0)
        thumView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipLabel.text = "上划取消跳转"
        tipLabel.backgroundColor = MMColors.color_bg_1?.withAlphaComponent(0.6)
        tipLabel.textAlignment = .center
        tipLabel.mm_cornerRadius(8)
        countLabel.backgroundColor = MMColors.color_bg_1?.withAlphaComponent(0.6)
        countLabel.textAlignment = .center
        countLabel.mm_cornerRadius(8)
    }
}
