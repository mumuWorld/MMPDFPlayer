//
//  MMAsset.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/10.
//

import UIKit
import Kingfisher
import PDFKit

/*
 🔨[MMAsset init(path:)](20): [[__C.NSFileAttributeKey(_rawValue: NSFileCreationDate): 2019-12-28 12:01:56 +0000, __C.NSFileAttributeKey(_rawValue: NSFileSize): 17757591, __C.NSFileAttributeKey(_rawValue: NSFileExtensionHidden): 0, __C.NSFileAttributeKey(_rawValue: NSFileModificationDate): 2019-12-28 12:01:56 +0000, __C.NSFileAttributeKey(_rawValue: NSFilePosixPermissions): 438, __C.NSFileAttributeKey(_rawValue: NSFileSystemNumber): 16777224, __C.NSFileAttributeKey(_rawValue: NSFileOwnerAccountID): 501, __C.NSFileAttributeKey(_rawValue: NSFileType): NSFileTypeRegular, __C.NSFileAttributeKey(_rawValue: NSFileReferenceCount): 1, __C.NSFileAttributeKey(_rawValue: NSFileGroupOwnerAccountName): staff, __C.NSFileAttributeKey(_rawValue: NSFileSystemFileNumber): 30282404, __C.NSFileAttributeKey(_rawValue: NSFileGroupOwnerAccountID): 20]]
 🔨[MMAsset init(path:)](21): [[__C.NSFileAttributeKey(_rawValue: NSFileSystemFreeNodes): 2496036733, __C.NSFileAttributeKey(_rawValue: NSFileSystemSize): 255743823872, __C.NSFileAttributeKey(_rawValue: NSFileSystemFreeSize): 66744733696, __C.NSFileAttributeKey(_rawValue: NSFileSystemNodes): 2497498280, __C.NSFileAttributeKey(_rawValue: NSFileSystemNumber): 16777224]]
 */
enum FileSizeUnit: Int {
    case GB = 1000000000
    case MB = 1000000
    case KB = 1000
    case BT = 1
}

enum FileType: String {
    case pdf = "pdf"
    case unkonwn =  ""
}

struct MMAsset {
    var name: String = ""
    var path: URL?
    var fileType: FileAttributeType = .typeUnknown
    var creationDate: Date?
    var modificationDate: Date?
    var size: Int = 0
    var extensionHidden: Bool = false
    
    /// 后缀名 eg: pdf
    var pathExtension: String = ""
    
    var modifDataStr: String {
        get {
            guard let modif = modificationDate else { return "" }
            return modif.dataStr(formatter: .ShortYMD)
        }
    }
    
    /// 24312724 = 24.3m  264344 = 264kb  b
    var sizeStr: String {
        let unit: String
        var level: Float
        if size > FileSizeUnit.GB.rawValue { // G
            unit = "G"
            level = Float(FileSizeUnit.GB.rawValue)
        } else if size > 1000000 { // M
            unit = "M"
            level = Float(FileSizeUnit.MB.rawValue)
        } else if size > 1000 {
            unit = "kb"
            level = Float(FileSizeUnit.KB.rawValue)
        } else {
            unit = "b"
            level = Float(FileSizeUnit.BT.rawValue)
        }
        let value = String(format: "%.1f%@", Float(size) / level, unit)
        return value
    }
    
    /// 资源封面缓存的key
    var imgCacheKey: String {
        if let arr = path?.path.components(separatedBy: "Documents/"), arr.count > 1 {
            let str = String(arr.last ?? "")
            return str.isEmpty ? name : str
        }
        return name
    }
    
    init(path: URL) {
        self.path = path
        name = path.lastPathComponent
        pathExtension = path.pathExtension
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path.path)
            
//            let sysAttr = try FileManager.default.attributesOfFileSystem(forPath: path.path)
//                mm_print(attr)
            if let type = attr[FileAttributeKey.type] as? FileAttributeType {
                fileType = type
            }
            if let cDate = attr[FileAttributeKey.creationDate] as? Date {
                creationDate = cDate
            }
            // eg: 24312724 = 24.3m  264344 = 264kb
            if let pSize = attr[FileAttributeKey.size] as? Int {
                size = pSize
                mm_print("size= \(size)")
            }
            
            if let mDate = attr[FileAttributeKey.modificationDate] as? Date {
                modificationDate = mDate
            }
            if let hidden = attr[FileAttributeKey.extensionHidden] as? Bool {
                extensionHidden = hidden
            }
            
//            mm_print(sysAttr)
            mm_print(path)
        } catch let e {
            mm_print(e)
        }
    }
}

extension MMAsset {
    private func _createCoverImage(size: CGSize) -> UIImage? {
        guard let _path = path else { return nil }
        if pathExtension.lowercased() == FileType.pdf.rawValue {
            let document = PDFDocument(url: _path)
            if let image = document?.page(at: 0)?.thumbnail(of: size, for: .mediaBox) {
                KingfisherManager.shared.cache.store(image, forKey: imgCacheKey)
                return image
            }
        }
        return nil
    }
}

extension MMAsset {
    
    /// 获取封面
    /// - Parameters:
    ///   - size: 封面大小
    ///   - complete: 回调
    func coverImage(size: CGSize, complete: @escaping (_ img: UIImage?) -> Void) {
        KingfisherManager.shared.cache.retrieveImage(forKey: imgCacheKey) { result in
            switch result {
            case .success(let imgResult):
                guard let img = imgResult.image else { return complete(_createCoverImage(size: size)) }
                complete(img)
            case .failure(let e):
                mm_print(e)
                complete(_createCoverImage(size: size))
            }
        }
    }
}
