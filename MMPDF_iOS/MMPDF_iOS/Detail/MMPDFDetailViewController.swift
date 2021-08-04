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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .red
        
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
