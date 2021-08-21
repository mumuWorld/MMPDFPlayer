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
    
    lazy var addBtn: UIButton = {
        let item = UIButton.create().image(UIImage(named: "ic_add"))
        item.addTarget(self, action: #selector(handleClick(sender:)), for: .touchUpInside)
        return item
    }()
    
    lazy var rootPath: String = {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first ?? ""
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviBar()
        containerView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
        }
        loadFile()
    }
}

extension MMHomeViewController {
    
    func loadFile() -> Void {
        mm_print(rootPath)
        // file:///var/mobile/Containers/Data/Application/C7596598-A4E8-4F5E-A3CB-089B2EE2D092/Documents/
        let fileUrl = URL(fileURLWithPath: rootPath)
        // /var/mobile/Containers/Data/Application/C7596598-A4E8-4F5E-A3CB-089B2EE2D092/Documents
//        let url = URL(string: path)
        assetsArray.removeAll()
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
    }
    
    func handleChooseFileFromLocal() -> Void {
        let docVC = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
//        let docVC2 = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        docVC.delegate = self
        navigationController?.present(docVC, animated: true, completion: nil)
    }
    
    @objc func handleClick(sender: UIButton) {
//        guard let widow = application.delegate?.window else { return }
        let dataArray = [MMCellItem(title: "从本地添加", handleAction: { [weak self] param in
            self?.handleChooseFileFromLocal()
        })]
        let moreVC = MMMorePopViewController(dataArray: dataArray)
        moreVC.preferredContentSize = CGSize(width: 100, height: 54)
        moreVC.modalPresentationStyle = .popover

        let popPC = moreVC.popoverPresentationController
        popPC?.permittedArrowDirections = .up
        popPC?.sourceView = sender
        popPC?.sourceRect = sender.frame
        popPC?.delegate = moreVC
        present(moreVC, animated: true, completion: nil)
    }
    
    func setNaviBar() -> Void {
        itemHeight = floor(itemWidth / 111 * 150)
        naviBar.titleLabel.text = "本地文件"
        naviBar.backBtn.isHidden = true
        naviBar.mm_addSubView(addBtn)
        addBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(30)
        }
    }
}

extension MMHomeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        mm_print("选择完成->\(urls)")
        var count = 0
        //将文件导入到 document
        for url in urls {
            let purposePath = rootPath.appendPathComponent(string: url.lastPathComponent)
            let purposeUrl = URL(fileURLWithPath: purposePath)
            do {
                try FileManager.default.moveItem(at: url, to: purposeUrl)
                count += 1
            } catch let e {
                mm_print(e)
            }
        }
        MMToastView.show(message: "\(count)个文件导入完成")
        loadFile()
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
