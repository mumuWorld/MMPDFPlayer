//
//  MMSearchTextViewController.swift
//  MMPDF_iOS
//
//  Created by 杨杰 on 2021/8/27.
//

import UIKit
import PDFKit

class MMSearchTextViewController: MMBaseViewController {
    
    var document: PDFDocument?
    
    var selectedCallBack: ((_ sel: PDFSelection) -> Void)?
    
    lazy var searchBar: UISearchBar = {
        let item = UISearchBar()
        item.placeholder = "输入关键字"
        item.delegate = self
        return item
    }()
    
    lazy var tableView: UITableView = {
        let item = UITableView(frame: .zero, style: .plain)
        item.delegate = self
        item.dataSource = self
        item.rowHeight = 52
        item.separatorStyle = .none
        item.backgroundColor = UIColor(white: 0, alpha: 0)
        item.mm_register(nib: MMSingLabelCell.self)
        return item
    }()
    
    lazy var dataArray: [PDFSelection] = []
    
    init(doc: PDFDocument?) {
        document = doc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.isHidden = false
        naviBar.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        containerView.backgroundColor = MMColors.color_bg_2
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotify(sender:)), name: NSNotification.Name.PDFDocumentDidFindMatch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotify(sender:)), name: NSNotification.Name.PDFDocumentDidEndFind, object: nil)
    }

    @objc func handleNotify(sender: Notification) {
        if sender.name == NSNotification.Name.PDFDocumentDidFindMatch {
            if let selection = sender.userInfo?["PDFDocumentFoundSelection"] as? PDFSelection {
                mm_print(selection)
                dataArray.append(selection)
                tableView.reloadData()
            }
        } else if sender.name == NSNotification.Name.PDFDocumentDidEndFind {
            mm_print("搜索结束")
        }
    }
    
}

extension MMSearchTextViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        dataArray.removeAll()
        tableView.reloadData()
        //开始搜索,忽略大小写 https://blog.csdn.net/CX_NO1/article/details/82429648
        document?.beginFindStrings([text], withOptions: .caseInsensitive)
        mm_print("搜索开始")
    }
}

extension MMSearchTextViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mm_dequeueReusableCell(withClass: MMSingLabelCell.self, for: indexPath)
        let selection = dataArray[indexPath.row]
        cell.titleLabel.attributedText = selection.attributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selection = dataArray[indexPath.row]
        dismiss()
        selectedCallBack?(selection)
    }
}
