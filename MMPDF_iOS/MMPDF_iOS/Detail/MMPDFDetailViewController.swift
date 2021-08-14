//
//  MMPDFDetailViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import UIKit
import PDFKit


class MMPDFDetailViewController: MMBaseViewController {
    
    let asset: MMAsset
    
    lazy var bottomToolView: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor.white
        return item
    }()
        
    var document: PDFDocument?
    
    lazy var pdfView: PDFView = {
        let item = PDFView()
        item.displayMode = .singlePage
        item.displayDirection = .horizontal
//        item.canGoBack = true
//        item.canGoForward = true
        item.displaysAsBook = false
        item.delegate = self
        item.autoScales = true
        item.isUserInteractionEnabled = true
        item.usePageViewController(true, withViewOptions: [:])
        return item
    }()
    
    lazy var thumbnailView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: thumbnailWidth, height: thumbnailHeight)
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .horizontal
        let item = UICollectionView(frame: .zero, collectionViewLayout: layout)
        item.backgroundColor = UIColor.clear
        item.register(UINib(nibName: "MMThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "MMThumbnailPageCell")
        item.delegate = self
        item.dataSource = self
        return item
    }()
    
    lazy var thumnailTouchView: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor(white: 0, alpha: 0.01)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        item.addGestureRecognizer(pan)
        return item
    }()
    
    lazy var menuBtn: UIButton = {
        let item = UIButton(type: .custom)
        item.setImage(UIImage(named: "ic_menu"), for: .normal)
        item.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return item
    }()
    
    lazy var menuView: MMPDFOutlineView = {
        let item = MMPDFOutlineView()
        item.clickHandle = { [weak self] item in
            guard let self = self, let dest = item.outline.destination else { return }
            self.pdfView.go(to: dest)
        }
        return item
    }()
    
    lazy var pageCountView: MMDetailPageCountView = MMDetailPageCountView()
    
    lazy var popManager: MMPopManager = MMPopManager()
    
    lazy var dataArray: [MMPDFOutlineItem] = {
        guard let t_document = document, let outline = t_document.outlineRoot else { return [] }
        var item = [MMPDFOutlineItem]()
        createOutline(root: outline, level: 0, items: &item)
        return item
    }()
    
    var pageCount = 0
    
    var thumbnailWidth: CGFloat = 0
    
    var thumbnailHeight: CGFloat = 0

    init(asset: MMAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
        guard let url = asset.path else {
            return
        }
        document = PDFDocument(url: url)
        pageCount = min(10, document?.pageCount ?? 0)
        thumbnailWidth = floor((kScreenWidth - vNormalSpacing * 2 - 9 * 2) / 10)
        thumbnailHeight = floor(thumbnailWidth * 1.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .red
        setNaviBar()
        
        pdfView.frame = CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: kScreenHeigh - kNavigationBarHeight - thumbnailHeight)
        containerView.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
            make.bottom.equalToSuperview().offset(-thumbnailHeight)
        }
        pdfView.document = document
        
        //创建略缩图
        bottomToolView.addSubview(thumbnailView)
        containerView.addSubview(bottomToolView)
        bottomToolView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(thumbnailHeight + kBottomSafeSpacing)
        }
        thumbnailView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(thumbnailHeight)
        }
        //页数指示器
        containerView.addSubview(pageCountView)
        pageCountView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(naviBar.snp.bottom).offset(20)
        }
        pageCountView.count = document?.pageCount ?? 0
        pageCountView.curPage = 1
        //隐藏滚动条
        if let pdfScrollView = pdfView.subviews.first?.subviews.first as? UIScrollView {
            pdfScrollView.showsHorizontalScrollIndicator = false
            pdfScrollView.showsVerticalScrollIndicator = false
        }
        
        registreNotify()
        
        thumbnailView.isUserInteractionEnabled = pageCount > 10
        if document?.pageCount ?? 0 > 10 {
            bottomToolView.addSubview(thumnailTouchView)
            thumnailTouchView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let pageNumber = UserDefaults.standard.integer(forKey: asset.name)
        if pageNumber > 0, let pdfPage = document?.page(at: pageNumber) {
            pdfView.go(to: pdfPage)
            pageCountView.curPage = pageNumber + 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1) - 1
        UserDefaults.standard.set(page, forKey: asset.name)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_print("")
    }
        
    /// 创建大纲
    @discardableResult
    func createOutline(root: PDFOutline, level: Int, items: inout [MMPDFOutlineItem]) -> [MMPDFOutlineItem] {
        guard root.numberOfChildren > 0 else {
            return items
        }
        for index in  0..<root.numberOfChildren {
            if let cur = root.child(at: index) {
                let newItem = MMPDFOutlineItem(ol: cur, lv: level)
                items.append(newItem)
                createOutline(root: cur, level: level + 1, items: &items)
            }
        }
        return items
    }
    
    var touchPoint: CGPoint = .zero
    
}

extension MMPDFDetailViewController {
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let point = sender.location(in: thumnailTouchView)
        switch sender.state {
        case .began:
            touchPoint = point
        case .changed:
            let change = point.x - touchPoint.x
        default:
            break
        }
        mm_print(point)
    }
    
    @objc func showMenu() {
        menuView.dataArray = dataArray
        popManager.show(view: menuView, popType: .left)
    }
    
    func setNaviBar() {
        naviBar.mm_addSubView(menuBtn)
        menuBtn.snp.makeConstraints { make in
            make.leading.equalTo(naviBar.backBtn.snp.trailing)
            make.top.size.equalTo(naviBar.backBtn)
        }
        
        if let title = document?.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String {
            naviBar.titleLabel.text = title
        } else {
            naviBar.titleLabel.text = asset.name
        }
    }
}

extension MMPDFDetailViewController : PDFViewDelegate {
//    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
//        mm_print("点击链接->\(url)")
//    }
    
    func pdfViewParentViewController() -> UIViewController {
        mm_print("->")
        return self
    }
    
    func pdfViewPerformFind(_ sender: PDFView) {
        mm_print("->")
    }
    
    func pdfViewPerformGo(toPage sender: PDFView) {
        mm_print("->")
    }
    
    func pdfViewOpenPDF(_ sender: PDFView, forRemoteGoToAction action: PDFActionRemoteGoTo) {
        mm_print("->")
    }
}

extension MMPDFDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMThumbnailPageCell", for: indexPath) as! MMThumbnailPageCell
        if let page = document?.page(at: indexPath.row) {
            let size = CGSize(width: thumbnailWidth, height: thumbnailHeight)
            let thum = page.thumbnail(of: size, for: .artBox)
            cell.thumbnailImgView.image = thum
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let page = document?.page(at: indexPath.row) {
            pdfView.go(to: page)
        }
    }
}

extension MMPDFDetailViewController {
    
    @objc func handleNotify(sender: Notification) {
        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1) - 1
        UserDefaults.standard.set(page, forKey: asset.name)
    }
    
    @objc func handlePageChange(sender: Notification) {
        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1)
        mm_print("当前page=\(page)")
        pageCountView.curPage = page
    }
    
    @objc func handlePageClick(sender: Notification) {
        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1)
        mm_print("当前2page=\(page)")
        pageCountView.curPage = page
    }
    
    func registreNotify() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotify(sender:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //page改变
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(sender:)), name: NSNotification.Name.PDFViewPageChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageClick(sender:)), name: NSNotification.Name.PDFViewAnnotationHit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageClick(sender:)), name: NSNotification.Name.PDFViewAnnotationWillHit, object: nil)

    }
}
