//
//  MMWKWebViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/26.
//

import UIKit
import WebKit

class MMWKWebViewController: MMBaseViewController {

    var url: URL?
    
    lazy var wkWebView: WKWebView = {
        let item = WKWebView()
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard let _url = url else { return }
        wkWebView.load(URLRequest(url: _url))
    }
}
