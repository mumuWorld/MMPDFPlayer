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
        
        selectedIndex = 0
    }
}
