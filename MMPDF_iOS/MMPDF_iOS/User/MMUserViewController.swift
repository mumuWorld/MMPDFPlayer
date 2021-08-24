//
//  MMUserViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/15.
//

import UIKit

class MMUserViewController: MMBaseViewController {
    
    lazy var tableView: UITableView = {
        let item = UITableView(frame: .zero)
        item.mm_register(nib: MMOutlineItemCell.self)
        item.rowHeight = 40
        item.delegate = self
        item.dataSource = self
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.isHidden = true
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension MMUserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}
