//
//  MMPopManager.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/7.
//

import UIKit

protocol MMPopProtocol: UIView {
    func viewWillShow(manager: MMPopManager) -> Void
}

extension MMPopProtocol {
    func viewWillShow(manager: MMPopManager) -> Void {}
}

class MMPopManager {
    enum PopType {
        case left
    }
    
    lazy var popContainerView: UIView = {
        let item = UIView()
        return item
    }()
    
    lazy var maskView: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor(white: 0, alpha: 0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskTap(sender:)))
        item.addGestureRecognizer(tap)
        return item
    }()
    
    private var showAniBlock: (() -> Void)?
    
    private var dismissAniBlock: (() -> Void)?

    var curShowView: MMPopProtocol? {
        didSet {
            curShowView?.isHidden = false
        }
    }
    
    @objc func maskTap(sender: UITapGestureRecognizer) {
        dissmiss()
    }
}

extension MMPopManager {
    func show(view: MMPopProtocol, popType: PopType) -> Void {
        guard let vc = UIViewController.currentViewController() else {
            return
        }
        maskView.frame = vc.view.bounds
        vc.view.addSubview(maskView)
        maskView.alpha = 0
        
        curShowView = view
        popContainerView.addSubview(view)
        handlePopType(popType: popType, supView: vc.view)
        view.mm_size = popContainerView.mm_size
        vc.view.addSubview(popContainerView)
        view.viewWillShow(manager: self)

        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 1
            self.showAniBlock?()
        } completion: { _ in
        }
    }
    
    func handlePopType(popType: PopType, supView: UIView) {
        if popType == .left {
            popContainerView.mm_height = supView.mm_height
            popContainerView.mm_width = ceil(supView.mm_width * 0.7)
            popContainerView.mm_origin = CGPoint(x: -popContainerView.mm_width, y: 0)
            showAniBlock = { [weak self] in
                guard let self = self else { return }
                self.popContainerView.mm_x = 0
            }
            dismissAniBlock = { [weak self] in
                guard let self = self else { return }
                self.popContainerView.mm_x = -self.popContainerView.mm_width
            }
        }
    }
    
    func dissmiss() {
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 0
            self.dismissAniBlock?()
        } completion: { _ in
            self.curShowView?.isHidden = true
        }
    }
}
