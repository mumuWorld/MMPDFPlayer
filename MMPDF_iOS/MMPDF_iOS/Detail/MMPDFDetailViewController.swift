//
//  MMPDFDetailViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import UIKit
import PDFKit
import SnapKit

class MMPDFDetailViewController: MMBaseViewController {
    
    enum ViewType {
        case normal, fullText
    }
    
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
        item.displaysAsBook = false
        item.delegate = self
        item.autoScales = true
        item.isUserInteractionEnabled = true
        item.usePageViewController(true, withViewOptions: [:])
        return item
    }()
    
    /// 底部略缩图
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
        let pan = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        item.addGestureRecognizer(pan)
        item.addSubview(curPageView)
        curPageView.frame = CGRect(x: 0, y: 0, width: thumbnailWidth, height: thumbnailHeight)
        return item
    }()
    
    var touchPage: Int = 0
    var isTouchCancel: Bool = false {
        didSet {
            self.curPreviewPageView.tipType = isTouchCancel ? 1 : 0
        }
    }
    ///滑动跳转交互视图
    lazy var curPageView: MMCurPageThumbnailView = {
        let item = UINib.init(nibName: "MMCurPageThumbnailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MMCurPageThumbnailView
        item.alpha = 0.9
        item.touchChange = { [weak self] change, showCancel in
            guard let self = self else { return }
            self.handlePanChange(change: change, isShowCancel: showCancel)
        }
        item.touchBegin = { [weak self] in
            guard let self = self else { return }
            self.curPreviewPageView.isHidden = false
        }
        item.touchEnd = { [weak self] in
            guard let self = self else { return }
            self.curPreviewPageView.isHidden = true
            mm_print("是否取消->\(self.isTouchCancel)")
            guard !self.isTouchCancel else { return }
            mm_print("跳转->\(self.touchPage)")
            self.gotoPage(pageNumber: self.touchPage)
        }
        return item
    }()
    /// 预览跳转试图
    lazy var curPreviewPageView: MMCurPageThumbnailTipView = {
        let item = UINib.init(nibName: "MMDetailSubViews", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MMCurPageThumbnailTipView
        item.backgroundColor = MMColors.color_bg_1?.withAlphaComponent(0.4)
        item.isHidden = true
        return item
    }()
    
    lazy var menuBtn: UIButton = {
        let item = UIButton(type: .custom)
        item.setImage(UIImage(named: "ic_menu"), for: .normal)
        item.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return item
    }()
    
    lazy var settingBtn: UIButton = {
        let item = UIButton(type: .custom)
        item.setImage(UIImage(named: "ic_setting"), for: .normal)
        item.addTarget(self, action: #selector(showSetting), for: .touchUpInside)
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
    //MARK:- 需求2
    lazy var dataArray: [MMPDFOutlineItem] = {
        guard let t_document = document, let outline = t_document.outlineRoot else { return [] }
        var item = [MMPDFOutlineItem]()
        createOutline(root: outline, level: 0, items: &item)
        return item
    }()
    
    var viewtype: ViewType = .normal {
        didSet {
            let naviOffset: CGFloat
            let bottomOffset: CGFloat
            if viewtype == .normal {
                naviOffset = 0
                bottomOffset = 0
                pageCountView.isHidden = false
            } else {
                naviOffset = -kNavigationBarHeight
                bottomOffset = thumbnailHeight + kBottomSafeSpacing
                pageCountView.isHidden = true
            }
            UIView.animate(withDuration: 0.2) {
                self.naviBar.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(naviOffset)
                }
                self.bottomToolView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(bottomOffset)
                }
            }
        }
    }
        
    var thumbnailWidth: CGFloat = 0
    
    var thumbnailHeight: CGFloat = 0
    
    var touchPoint: CGPoint = .zero
    
    var pageCount: Int {
        get {
            document?.pageCount ?? 0
        }
    }
    
    var curPage: Int {
        get {
            return pdfView.currentPage?.pageRef?.pageNumber ?? 1
        }
    }

    init(asset: MMAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
        guard let url = asset.path else {
            return
        }
        document = PDFDocument(url: url)
        //MARK:- 需求4
//        document?.delegate = self
        thumbnailWidth = floor((kScreenWidth - vNormalSpacing * 2 - 9 * 2) / 10)
        thumbnailHeight = floor(thumbnailWidth * 1.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var perPageDistance: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = MMColors.color_bg_1
        setNaviBar()
        setupSubviews()
        let distance = kScreenWidth - thumbnailWidth
        perPageDistance = distance / CGFloat(pageCount)
        let pageNumber = UserDefaults.standard.integer(forKey: asset.name)
        if pageNumber > 0, let pdfPage = document?.page(at: pageNumber) {
            pdfView.go(to: pdfPage)
        } else {
            //处理不跳转时候的图片
            gotoPage(pageNumber: 1)
        }
        
        //MARK:- 需求6
//        test6()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1) - 1
        UserDefaults.standard.set(page, forKey: asset.name)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MMPDFDetailViewController {
    
    func handlePanChange(change: CGFloat, isShowCancel: Bool) -> Void {
        self.isTouchCancel = isShowCancel
        let curX = self.curPageView.mm_x + change
        self.curPageView.mm_x = curX
        let curPage = Int(curX / self.perPageDistance)
        self.touchPage = curPage
        self.handleCurPageOffset(page: curPage)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: thumnailTouchView)
        let curPage = max(Int(point.x / self.perPageDistance), 1)
        gotoPage(pageNumber: curPage)
        handleCurPageOffset(page: curPage)
        curPageView.mm_x = CGFloat(curPage) * perPageDistance
    }
    
    //MARK:- 展示大纲  需求2
    @objc func showMenu() {
        menuView.dataArray = dataArray
        popManager.show(view: menuView, popType: .left)
    }
    
    @objc func showSetting() {
        guard let window = application.delegate?.window else {
            return
        }
        let dataArray = [MMCellItem(title: "指定跳转", handleAction: { [weak self] param in
            guard let self = self else { return }
            self.showGotoAlert()
        })]
        let moreVC = MMMorePopViewController(dataArray: dataArray)
        moreVC.preferredContentSize = CGSize(width: 100, height: 54)
        moreVC.modalPresentationStyle = .popover

        let popPC = moreVC.popoverPresentationController
        popPC?.permittedArrowDirections = .up
        popPC?.sourceView = naviBar
        popPC?.sourceRect = settingBtn.superview?.convert(settingBtn.frame, to: window) ?? settingBtn.frame
        popPC?.delegate = moreVC
        navigationController?.present(moreVC, animated: true, completion: nil)
    }
}

extension MMPDFDetailViewController {
    
    func handleCurPageOffset(page: Int) -> Void {
        guard let pageView = document?.page(at: page - 1) else { return }
        if !curPreviewPageView.isHidden {
            let thum = pageView.thumbnail(of: curPreviewPageView.thumView.thunbnailImgView.mm_size, for: .artBox)
            curPreviewPageView.thumView.thunbnailImgView.image = thum
            curPreviewPageView.countLabel.text = String(format: "跳转页数 %d", page)
        }
        let thum = pageView.thumbnail(of: CGSize(width: thumbnailWidth - 8, height: thumbnailHeight - 8), for: .artBox)
        curPageView.thunbnailImgView.image = thum
    }
    
    func gotoPage(pageNumber: Int) -> Void {
        let page = min(max(pageNumber, 1), pageCount)
        mm_print("当前page=\(page)")
        pageCountView.curPage = page
        let savePage = page - 1
        if let pageView = document?.page(at: savePage) {
            pdfView.go(to: pageView)
        }
        UserDefaults.standard.set(savePage, forKey: asset.name)
    }
    
    @objc func handleGesture(sender: UIGestureRecognizer) {
        mm_print("切换模式")
        viewtype = viewtype == .fullText ? .normal : .fullText
    }
    
    func showGotoAlert() -> Void {
        guard let doc = document else { return }
        let message = String(format: "输入0-%d之间的页数", doc.pageCount)
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "输入要跳转的页数"
            field.keyboardType = .numberPad
        }
        let confirm = UIAlertAction(title: "确定", style: .default) { [weak alert, weak self] _ in
            guard let inputText = alert?.textFields?.first?.text, !inputText.isEmpty else { return }
            let inputV = inputText.intValue() - 1
            if let page = self?.document?.page(at: inputV) {
                self?.pdfView.go(to: page)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension MMPDFDetailViewController: PDFDocumentDelegate {
    
    func classForPage() -> AnyClass {
        return MMWatermarkPage.self
    }
}

//MARK:- PDFViewDelegate
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
//MARK:- Base
extension MMPDFDetailViewController {
    
    @objc func handleNotify(sender: Notification) {
        mm_print(sender.name)
    }
    
    @objc func handlePageChange(sender: Notification) {
        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1)
        gotoPage(pageNumber: page)
        handleCurPageOffset(page: page)
    }
    
    @objc func handlePageClick(sender: Notification) {
//        let page = max(pdfView.currentPage?.pageRef?.pageNumber ?? 1, 1)
        mm_print("PDFViewAnnotationHit")
//        pageCountView.curPage = page
    }
    
    func registreNotify() -> Void {
        //page改变
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(sender:)), name: NSNotification.Name.PDFViewPageChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageClick(sender:)), name: NSNotification.Name.PDFViewAnnotationHit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageClick(sender:)), name: NSNotification.Name.PDFViewAnnotationWillHit, object: nil)
    }
    
    func setNaviBar() {
        naviBar.mm_addSubView(menuBtn)
        menuBtn.snp.makeConstraints { make in
            make.leading.equalTo(naviBar.backBtn.snp.trailing)
            make.top.size.equalTo(naviBar.backBtn)
        }
        naviBar.mm_addSubView(settingBtn)
        settingBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-vNormalSpacing)
            make.top.size.equalTo(menuBtn)
        }
        
        if let title = document?.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String {
            naviBar.titleLabel.text = title
        } else {
            naviBar.titleLabel.text = asset.name
        }
    }
    
    func createMenuItem() -> Void {
        let menuC = UIMenuController.shared
        NotificationCenter.default.addObserver(self, selector: #selector(handleMenuShow(sender:)), name: UIMenuController.willShowMenuNotification, object: nil)
    }
    
    @objc func handleMenuShow(sender: Notification) {
        mm_print("willShowMenuNotification")
    }
    
    //MARK:- 需求6
    func test6() {
        //画一条线
        //获取要添加注解的page
        if let page = document?.page(at: 0) {
            let pageBounds = page.bounds(for: .cropBox)
            let changeBounds = CGRect(x: 0, y: 0, width: pageBounds.width - 100, height: pageBounds.height - 200)
            let line = PDFAnnotation(bounds: changeBounds, forType: .line, withProperties: nil)
            //用setValue
            line.setValue([0, 0, 500, 500], forAnnotationKey: .linePoints)
            line.setValue(["Closed", "Open"], forAnnotationKey: .lineEndingStyles)
            line.setValue(UIColor.red, forAnnotationKey: .color)
            //用PDFAnnotationUtilities 拓展
            line.startPoint = CGPoint(x: 0, y: 0)
            line.endPoint = CGPoint(x: 500, y: 500)
            line.startLineStyle = .closedArrow
            line.endLineStyle = .openArrow
            line.color = .red
            
            let border_ano = PDFAnnotation(bounds: changeBounds, forType: .square, withProperties: nil)
            let border = PDFBorder()
            border.lineWidth = 2.0
            border.style = .solid
            border_ano.color = UIColor.yellow
            border_ano.border = border
            
            let link_ano = PDFAnnotation(bounds: changeBounds, forType: .link, withProperties: nil)
            let link = PDFActionURL(url: URL(string: "http://www.youdao.com/")!)
            link_ano.action = link
            
            let goto_ano = PDFAnnotation(bounds: changeBounds, forType: .link, withProperties: nil)
            let destination = PDFDestination(page: (document?.page(at: 1))!, at: CGPoint(x: 35, y: 275))
            let actionGoTo = PDFActionGoTo(destination: destination)
            goto_ano.action = actionGoTo
            
            //当前page添加注解
            page.addAnnotation(line)
            page.addAnnotation(border_ano)
            page.addAnnotation(link_ano)
        }
    }
    
    //MARK:- 需求3: 2
    func createSystemThum() {
        //系统的略缩图
        let thumbnail = PDFThumbnailView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: thumbnailHeight))
        thumbnail.pdfView = pdfView
        thumbnail.layoutMode = .horizontal
        containerView.addSubview(thumbnail)
    }
    
    func setupSubviews() -> Void {
        //MARK:- 需求1
        pdfView.frame = CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: kScreenHeigh - kNavigationBarHeight - thumbnailHeight)
        containerView.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kBottomSafeSpacing)
        }
        pdfView.document = document
        //给pdfView加个手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        pdfView.addGestureRecognizer(tap)
        //MARK:- 需求3
        //创建略缩图
        bottomToolView.addSubview(thumbnailView)
        containerView.addSubview(bottomToolView)
        bottomToolView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
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
        //滚动提示
        containerView.addSubview(curPreviewPageView)
        curPreviewPageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.height.equalTo((kScreenWidth - 40) * 1.2)
        }
        //隐藏滚动条
        if let pdfScrollView = pdfView.subviews.first?.subviews.first as? UIScrollView {
            pdfScrollView.showsHorizontalScrollIndicator = false
            pdfScrollView.showsVerticalScrollIndicator = false
        }
        
        registreNotify()
        createMenuItem()
        thumbnailView.isUserInteractionEnabled = pageCount > 10
        if document?.pageCount ?? 0 > 10 {
            bottomToolView.addSubview(thumnailTouchView)
            thumnailTouchView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            handleCurPageOffset(page: curPage)
            DispatchQueue.main.async {
                self.curPageView.frame = CGRect(x: CGFloat(self.curPage) * self.perPageDistance, y: 0, width: self.thumbnailWidth, height: self.thumbnailHeight)
            }
        }
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
            // cropBox 默认 电子版、 mediaBox 纸质版
            let thum = page.thumbnail(of: size, for: .cropBox)
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
