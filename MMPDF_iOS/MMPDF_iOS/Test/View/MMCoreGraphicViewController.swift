//
//  MMCoreGraphicViewController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/26.
//

import UIKit
import CoreGraphics

class MMCoreGraphicViewController: MMBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "BookName", ofType: "pdf") else { return }
        let cfString = CFStringCreateWithCString(.none, path, CFStringBuiltInEncodings.UTF8.rawValue)
        guard let cfUrl = CFURLCreateWithFileSystemPath(.none, cfString, .cfurlWindowsPathStyle, false) else {
            return
        }
        let document = CGPDFDocument(cfUrl)
        let context = UIGraphicsGetCurrentContext()
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
