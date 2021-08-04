//
//  MMPDFDetailViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import UIKit
import PDFKit

class MMPDFDetailViewController: MMBaseViewController {
    
    @IBOutlet weak var bottomToolView: UIView!
    
    lazy var pdfView: PDFView = {
        let item = PDFView()
        item.autoScales = true
        item.isUserInteractionEnabled = true
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .red
        
        let path = Bundle.main.path(forResource: "Swift 开发者必备 Tips (第四版)", ofType: "pdf") ?? ""
        let url = URL(fileURLWithPath: path)
        let document = PDFDocument(url: url)
        
        containerView.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pdfView.document = document
    }

    
}
