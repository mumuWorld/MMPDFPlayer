//
//  MMAssetCollectionCell.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/10.
//

import UIKit

class MMAssetCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var attrLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var itemSize: CGSize = .zero
    
    var item :MMAsset? {
        didSet {
            guard let tItem = item else {
                return
            }
            nameLabel.text = tItem.name
            attrLabel.text = tItem.sizeStr
            tItem.coverImage(size: itemSize) { [weak self] image in
                guard let self = self else { return }
                self.imageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupItem(item :MMAsset, size: CGSize) -> Void {
        itemSize = CGSize(width: size.width, height: size.height - 40)
        self.item = item
    }
}
