//
//  MMHomeViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/5.
//

import UIKit

class MMHomeViewController: MMBaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenWidth * 0.3, height: 200)
        let item = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        item.register(UINib(nibName: "MMAssetCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MMAssetCollectionCell")
        item.delegate = self
        item.dataSource = self
        item.backgroundColor = .clear
        return item
    }()
    
    lazy var assetsArray: [MMAsset] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        containerView.isHidden = true
        containerView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
            return
        }
        // file:///var/mobile/Containers/Data/Application/C7596598-A4E8-4F5E-A3CB-089B2EE2D092/Documents/
        let fileUrl = URL(fileURLWithPath: path)
        // /var/mobile/Containers/Data/Application/C7596598-A4E8-4F5E-A3CB-089B2EE2D092/Documents
//        let url = URL(string: path)
        do {
            let documents = try FileManager.default.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: [], options: .skipsSubdirectoryDescendants)
            
            for document in documents {
                let item = MMAsset(name: "", path: document)
                assetsArray.append(item)
            }
            mm_print("")
            collectionView.reloadData()
        } catch let e {
            mm_print(e)
        }
        
        
    }


    @IBAction func handleClick(_ sender: UIButton) {
//        navigationController?.pushViewController(MMPDFDetailViewController(), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MMHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMAssetCollectionCell", for: indexPath) as! MMAssetCollectionCell
        cell.contentView.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = assetsArray[indexPath.row]
        let detail = MMPDFDetailViewController(asset: item)
        navigationController?.pushViewController(detail, animated: true)
    }
}
