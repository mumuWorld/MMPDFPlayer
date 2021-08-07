//
//  MMPDFOutlineView.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/7.
//

import UIKit
import PDFKit

struct MMPDFOutlineItem {
    
    var level: Int = 0
    
    var outline: PDFOutline
    
    init(ol: PDFOutline, lv: Int) {
        outline = ol
        level = lv
    }
}

class MMPDFOutlineView: UIView {
    
    var clickHandle: ((_ item: MMPDFOutlineItem) -> Void)?

    weak var _manager: MMPopManager?
    
    lazy var tableView: UITableView = {
        let item = UITableView(frame: .zero)
        item.mm_register(nib: MMOutlineItemCell.self)
        item.rowHeight = 40
        item.delegate = self
        item.dataSource = self
        return item
    }()

    var dataArray: [MMPDFOutlineItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MMPDFOutlineView: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mm_dequeueReusableCell(withClass: MMOutlineItemCell.self, for: indexPath)
        cell.item = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataArray[indexPath.row]
        mm_print(item)
        clickHandle?(item)
        _manager?.dissmiss()
    }
}

extension MMPDFOutlineView: MMPopProtocol {
    func viewWillShow(manager: MMPopManager) {
        _manager = manager
    }
}
