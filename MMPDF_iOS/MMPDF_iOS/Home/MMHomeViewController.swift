//
//  MMHomeViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/5.
//

import UIKit


class MMHomeViewController: MMBaseViewController {
    
    let itemWidth = floor((kScreenWidth - vNormalSpacing * 5) / 3)
    var itemHeight: CGFloat = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = vNormalSpacing
        layout.minimumInteritemSpacing = vNormalSpacing
        layout.sectionInset = UIEdgeInsets(top: vNormalSpacing, left: vNormalSpacing, bottom: kBottomSafeSpacing + 20, right: vNormalSpacing)
        
        let item = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        item.register(UINib(nibName: "MMAssetCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MMAssetCollectionCell")
        item.bounces = true
        item.delegate = self
        item.dataSource = self
        item.backgroundColor = .clear
        return item
    }()
    
    lazy var assetsArray: [MMAsset] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        itemHeight = floor(itemWidth / 111 * 150)
        naviBar.titleLabel.text = "本地文件"
        naviBar.backBtn.isHidden = true
//        containerView.isHidden = true
        containerView.addSubview(collectionView)
        containerView.backgroundColor = .lightGray
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
        }
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
            return
        }
        mm_print(path)
        // file:///var/mobile/Containers/Data/Application/C7596598-A4E8-4F5E-A3CB-089B2EE2D092/Documents/
        let fileUrl = URL(fileURLWithPath: path)
        // /var/mobile/Containers/Data/Application/C7596598-A4E8-4F5E-A3CB-089B2EE2D092/Documents
//        let url = URL(string: path)
        do {
            let documents = try FileManager.default.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: [], options: .skipsSubdirectoryDescendants)
            
            for document in documents {
                let item = MMAsset(path: document)
                assetsArray.append(item)
            }
            mm_print("")
            collectionView.reloadData()
        } catch let e {
            mm_print(e)
        }
        
        let float = String(format: "%.1f",  Float(10/3))
        mm_print(float)
    }


    @IBAction func handleClick(_ sender: UIButton) {
//        navigationController?.pushViewController(MMPDFDetailViewController(), animated: true)
    }
}

extension MMHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMAssetCollectionCell", for: indexPath) as! MMAssetCollectionCell
        cell.contentView.backgroundColor = .yellow
        cell.setupItem(item: assetsArray[indexPath.row], size: CGSize(width: itemWidth, height: itemHeight))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = assetsArray[indexPath.row]
        let detail = MMPDFDetailViewController(asset: item)
        navigationController?.pushViewController(detail, animated: true)
    }
}
