//
//  MMTestViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/26.
//

import UIKit

class MMTestViewController: MMBaseViewController {

    lazy var tableView: UITableView = {
        let item = UITableView(frame: .zero)
        item.mm_register(nib: MMSingLabelCell.self)
        item.rowHeight = 40
        item.delegate = self
        item.dataSource = self
        return item
    }()
    
    lazy var _dataArray: [MMCellItem] = {
        let item = [
            MMCellItem(title: "webview", handleAction: { [weak self] _ in
            guard let self = self else { return }
            guard let path = Bundle.main.path(forResource: "Swift 开发者必备 Tips (第四版)", ofType: "pdf") else { return }
            let wkVC = MMWKWebViewController()
            wkVC.url = URL(fileURLWithPath: path)
            self.navigationController?.pushViewController(wkVC, animated: true)}),
            MMCellItem(title: "CoreGraphics", handleAction: { [weak self] _ in
            guard let self = self else { return }

            self.navigationController?.pushViewController(MMCoreGraphicViewController(), animated: true)}),
        ]
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

extension MMTestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mm_dequeueReusableCell(withClass: MMSingLabelCell.self, for: indexPath)
        cell.titleLabel.text = _dataArray[indexPath.row].title
        cell.contentView.backgroundColor = MMColors.color_bg_2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = _dataArray[indexPath.row]
        if let handle = item.handleAction {
            dismiss(animated: true, completion: nil)
            handle(item)
        }
    }
}
