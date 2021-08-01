//
//  MMBaseViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import Foundation
import UIKit
import SnapKit

class MMBaseViewController: UIViewController {
    
    lazy var naviBar: MMCustomNaviBar = {
        let item: MMCustomNaviBar = UINib.init(nibName: "MMBaseViews", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MMCustomNaviBar
        return item
    }()
    
    lazy var containerView: UIView = {
        let item = UIView()
        return item
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        view.addSubview(naviBar)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(kNavigationBarHeight)
        }
        naviBar.isHidden = isHideNavibar
    }
}

extension MMBaseViewController {
    open var isHideNavibar: Bool {
        return false
    }
    
    open var isHideBackBtn: Bool {
        return false
    }
    
}
