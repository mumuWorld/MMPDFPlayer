//
//  MMHomeViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/5.
//

import UIKit

class MMHomeViewController: MMBaseViewController {
    
    lazy var detailVC: MMPDFDetailViewController = {
        let item = MMPDFDetailViewController(nibName: "MMPDFDetailViewController", bundle: nil)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
        // Do any additional setup after loading the view.
    }


    @IBAction func handleClick(_ sender: UIButton) {
        navigationController?.pushViewController(detailVC, animated: true)
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
