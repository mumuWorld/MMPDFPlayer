//
//  MMHomeTabBarController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import UIKit

class MMHomeTabBarController: UITabBarController {

    lazy var detailVC: MMPDFDetailViewController = {
        let item = MMPDFDetailViewController(nibName: "MMPDFDetailViewController", bundle: nil)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC()
    }
    
    func addChildVC() -> Void {
        let nav = MMBaseNavigationController(rootViewController: detailVC)
        nav.tabBarItem.title = "目录"
        nav.tabBarItem.image = UIImage(named: "ic_home")
        addChild(nav)
        
        selectedIndex = 0
    }
}
