//
//  Extensions.swift
//  PhotoViewer
//
//  Created by SEHUN KIM on 2020/01/18.
//  Copyright © 2020 SEHUN KIM. All rights reserved.
//

import Cocoa

extension NSImage {
    func pngData() -> Data? {
        var data: Data?
        if let tiffRep = tiffRepresentation {
            if let bitmap = NSBitmapImageRep(data: tiffRep) {
                data = bitmap.representation(using: .png, properties: [:])
            }
        }
        return data
    }
}


extension URL {
    var isFolder: Bool {
        var isFolder = false
        if let resources = try? resourceValues(forKeys: [.isDirectoryKey, .isPackageKey]) {
            let isURLDirectory = resources.isDirectory ?? false
            let isPackage = resources.isPackage ?? false
            isFolder = isURLDirectory && !isPackage
        }
        return isFolder
    }
    
    var isImage: Bool {
        var isImage = false
        if let typeIdentifierResource = try? resourceValues(forKeys: [.typeIdentifierKey]) {
            if let imageTypes = CGImageSourceCopyTypeIdentifiers() as? [Any] {
                let typeIdentifier = typeIdentifierResource.typeIdentifier
                for imageType in imageTypes {
                    if UTTypeConformsTo(typeIdentifier! as CFString, imageType as! CFString) {
                        isImage = true
                        break
                    }
                }
            }
        } else {
            let imageFormats = ["jpg", "jpeg", "png", "gif", "tiff"]
            let ext = pathExtension
            isImage = imageFormats.contains(ext)
        }
        return isImage
    }
    
    var fileType: String {
        var fileType = ""
        if let typeIdentifierResource = try? resourceValues(forKeys: [.typeIdentifierKey]) {
            fileType = typeIdentifierResource.typeIdentifier!
        }
        return fileType
    }
    
    var isHidden: Bool {
        let resource =  try? resourceValues(forKeys: [.isHiddenKey])
        return (resource?.isHidden)!
    }
    
    var icon: NSImage {
        var icon: NSImage!
        if let iconValues = try? resourceValues(forKeys: [.customIconKey, .effectiveIconKey]) {
            if let customIcon = iconValues.customIcon {
                icon = customIcon
            } else if let effectiveIcon = iconValues.effectiveIcon as? NSImage {
                icon = effectiveIcon
            }
        } else {
            let osType = isFolder ? kGenericFolderIcon : kGenericDocumentIcon
            let iconType = NSFileTypeForHFSTypeCode(OSType(osType))
            icon = NSWorkspace.shared.icon(forFileType: iconType!)
        }
        return icon
    }
    
    var localizedName: String {
        var localizedName = ""
        if let filenameResource = try? resourceValues(forKeys: [.localizedNameKey]) {
            localizedName = filenameResource.localizedName!
        } else {
            localizedName = lastPathComponent
        }
        return localizedName
    }
    
    var fileSizeString: String {
        var fileSizeString = "-"
        if let allocatedSizeResource = try? resourceValues(forKeys: [.totalFileAllocatedSizeKey]) {
            if let allocatedSize = allocatedSizeResource.totalFileAllocatedSize {
                let formattedNumberStr = ByteCountFormatter.string(fromByteCount: Int64(allocatedSize), countStyle: .file)
                let fileSizeTitle = NSLocalizedString("on disk", comment: "")
                fileSizeString = String(format: fileSizeTitle, formattedNumberStr)
            }
        }
        return fileSizeString
    }
    
    var modificationDate: Date? {
        var modificationDate: Date?
        if let modDateResource = try? resourceValues(forKeys: [.contentModificationDateKey]) {
            modificationDate = modDateResource.contentModificationDate
        }
        return modificationDate
    }
    
    var kind: String {
        var kind = "-"
        if let kindResource = try? resourceValues(forKeys: [.localizedTypeDescriptionKey]) {
            kind = kindResource.localizedTypeDescription!
        }
        return kind
    }
}
