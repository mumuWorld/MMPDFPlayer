//
//  UITableView+Extension.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/7/18.
//

import Foundation
import UIKit

extension UITableView {
    
    static var bundle: Bundle = Bundle(for: UITableView.classForCoder())
    
    public func mm_register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    public func mm_register<T: UITableViewCell>(nib: T.Type) {
        let cellName = String(describing: nib)
        register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    public func mm_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    
    public func mm_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
}
