//
//  MMMorePopViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/15.
//

import UIKit

class MMMorePopViewController: UITableViewController {
    
    let _dataArray: [MMCellItem]
    
    init(dataArray: [MMCellItem]) {
        _dataArray = dataArray
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = MMColors.color_bg_2
        tableView.mm_register(nib: MMSingLabelCell.self)
        tableView.rowHeight = 44
        tableView.isScrollEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mm_dequeueReusableCell(withClass: MMSingLabelCell.self, for: indexPath)
        cell.titleLabel.text = _dataArray[indexPath.row].title
        cell.contentView.backgroundColor = MMColors.color_bg_2
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
        let item = _dataArray[indexPath.row]
        if let handle = item.handleAction {
            dismiss(animated: true, completion: nil)
            handle(item)
        }
    }
}

extension MMMorePopViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
