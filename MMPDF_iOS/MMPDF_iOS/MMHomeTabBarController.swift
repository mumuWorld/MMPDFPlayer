//
//  MMHomeTabBarController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import UIKit

class MMHomeTabBarController: UITabBarController {

    
    
    lazy var homeVC: MMHomeViewController = {
        let item = MMHomeViewController(nibName: "MMHomeViewController", bundle: nil)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC()
    }
    
    func addChildVC() -> Void {
        let nav = MMBaseNavigationController(rootViewController: homeVC)
        nav.tabBarItem.title = "目录"
        nav.tabBarItem.image = UIImage(named: "ic_home")
        addChild(nav)
        
        let nav_2 = MMBaseNavigationController(rootViewController: MMUserViewController())
        nav_2.tabBarItem.title = "其他"
        nav_2.tabBarItem.image = UIImage(named: "ic_other")
        addChild(nav_2)
        
        let nav_3 = MMBaseNavigationController(rootViewController: MMTestViewController())
        nav_3.tabBarItem.title = "测试"
        nav_3.tabBarItem.image = UIImage(named: "ic_test")
        addChild(nav_3)
        
        selectedIndex = 0
    }
}
