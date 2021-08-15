//
//  MMMorePopViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/15.
//

import UIKit

class MMMorePopViewController: UITableViewController {
    
    let dataArray: [String] = ["从本地添加"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mm_register(nib: MMSingLabelCell.self)
        tableView.rowHeight = 44
        tableView.isScrollEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mm_dequeueReusableCell(withClass: MMSingLabelCell.self, for: indexPath)
        cell.titleLabel.text = dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension MMMorePopViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
