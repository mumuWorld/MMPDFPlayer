//
//  MMPDFDetailViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import UIKit
import PDFKit

fileprivate let thumbnailHeight: CGFloat = 100

class MMPDFDetailViewController: MMBaseViewController {
    
    lazy var bottomToolView: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor.white
        return item
    }()
        
    var document: PDFDocument?
    
    lazy var pdfView: PDFView = {
        let item = PDFView()
        item.autoScales = true
        item.isUserInteractionEnabled = true
        return item
    }()
    
    lazy var thumbnaisView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: thumbnailHeight)
        layout.scrollDirection = .horizontal
        let item = UICollectionView(frame: .zero, collectionViewLayout: layout)
        item.backgroundColor = UIColor.clear
        item.register(UINib(nibName: "MMThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "MMThumbnailPageCell")
        item.delegate = self
        item.dataSource = self
        return item
    }()
    
    lazy var menuBtn: UIButton = {
        let item = UIButton(type: .custom)
        item.setImage(UIImage(named: "ic_menu"), for: .normal)
        item.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return item
    }()
    
    lazy var menuView: MMPDFOutlineView = {
        let item = MMPDFOutlineView()
        item.clickHandle = { [weak self] item in
            guard let self = self, let dest = item.outline.destination else { return }
            self.pdfView.go(to: dest)
        }
        return item
    }()
    
    lazy var popManager: MMPopManager = MMPopManager()
    
    lazy var dataArray: [MMPDFOutlineItem] = {
        guard let t_document = document, let outline = t_document.outlineRoot else { return [] }
        var item = [MMPDFOutlineItem]()
        
        createOutline(root: outline, level: 0, items: &item)
        
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .red
        setNaviBar()
        
        let path = Bundle.main.path(forResource: "Swift 开发者必备 Tips (第四版)", ofType: "pdf") ?? ""
        let url = URL(fileURLWithPath: path)
        document = PDFDocument(url: url)
        
        containerView.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pdfView.document = document
        
        bottomToolView.addSubview(thumbnaisView)
        containerView.addSubview(bottomToolView)
        bottomToolView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(thumbnailHeight)
        }
        //创建略缩图
        thumbnaisView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @discardableResult
    func createOutline(root: PDFOutline, level: Int, items: inout [MMPDFOutlineItem]) -> [MMPDFOutlineItem] {
        guard root.numberOfChildren > 0 else {
            return items
        }
        for index in  0..<root.numberOfChildren {
            if let cur = root.child(at: index) {
                let newItem = MMPDFOutlineItem(ol: cur, lv: level)
                items.append(newItem)
                createOutline(root: cur, level: level + 1, items: &items)
            }
        }
        return items
    }
}

extension MMPDFDetailViewController {
    @objc func showMenu() {
        menuView.dataArray = dataArray
        popManager.show(view: menuView, popType: .left)
    }
}

extension MMPDFDetailViewController {
    func setNaviBar() {
        naviBar.mm_addSubView(menuBtn)
        menuBtn.snp.makeConstraints { make in
            make.leading.equalTo(naviBar.backBtn.snp.trailing).offset(8)
            make.top.size.equalTo(naviBar.backBtn)
        }
    }
}
extension MMPDFDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        document?.pageCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMThumbnailPageCell", for: indexPath) as! MMThumbnailPageCell
        if let page = document?.page(at: indexPath.row) {
            let thum = page.thumbnail(of: CGSize(width: 50, height: thumbnailHeight), for: .mediaBox)
            cell.thumbnailImgView.image = thum
        }
        return cell
    }
}
