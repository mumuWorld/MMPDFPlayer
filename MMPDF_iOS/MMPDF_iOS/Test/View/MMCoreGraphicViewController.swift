//
//  MMCoreGraphicViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/26.
//

import UIKit

class MMCoreGraphicViewController: MMBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "Swift 开发者必备 Tips (第四版)", ofType: "pdf") else { return }
//        let cfString = CFStringCreateWithCString(.none, &path.utf8, CFStringBuiltInEncodings.UTF8.rawValue)
//        let cfUrl = CFURLCreateWithFileSystemPath(.none, cfString, <#T##pathStyle: CFURLPathStyle##CFURLPathStyle#>, <#T##isDirectory: Bool##Bool#>)
//        CFURLCreateFileReferenceURL(kCFAllocatorDefault(), <#T##url: CFURL!##CFURL!#>, <#T##error: UnsafeMutablePointer<Unmanaged<CFError>?>!##UnsafeMutablePointer<Unmanaged<CFError>?>!#>)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
