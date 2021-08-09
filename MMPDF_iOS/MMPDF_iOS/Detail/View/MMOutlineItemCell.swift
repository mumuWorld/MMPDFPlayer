//
//  MMOutlineItemCell.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/7.
//

import UIKit

class MMOutlineItemCell: UITableViewCell {
    
    var item: MMPDFOutlineItem? {
        didSet {
            guard let t_item = item else { return }
            titleLabel.font = getFitFont(item: t_item)
            titleLabel.text = t_item.outline.label
            title_leading.constant = CGFloat(t_item.level * 16 + 8)
            pageCountLabel.text = t_item.outline.destination?.page?.label
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var title_leading: NSLayoutConstraint!
    
    @IBOutlet weak var pageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getFitFont(item: MMPDFOutlineItem) -> UIFont {
        if item.level == 0 {
            return UIFont.systemFont(ofSize: 17, weight: .medium)
        } else {
            let size = max(10, 17 - item.level)
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
    }
}
