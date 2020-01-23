//
//  Node.swift
//  PhotoViewer
//
//  Created by SEHUN KIM on 2020/01/18.
//  Copyright © 2020 SEHUN KIM. All rights reserved.
//

import Cocoa

enum NodeType: Int, Codable {
    case container
    case document
    case separator
    case unknown
}

class Node: NSObject, Codable {
    var type: NodeType = .unknown
    var title = ""
    var identifier = ""
    var url: URL?
    @objc dynamic var children = [Node]()
}

extension Node {
    @objc dynamic var isLeaf: Bool {
        return type == .document || type == .separator
    }
    
    var isURLNode: Bool {
        return url != nil
    }
    
    var isSpecialGroup: Bool {
        return (!isURLNode && (title == TreeViewController.NameConstants.pictures || title == TreeViewController.NameConstants.places))
    }
    
    override class func description() -> String {
        return "Node"
    }
    
    var nodeIcon: NSImage {
        var icon = NSImage()
        if let nodeURL = url {
            icon = nodeURL.icon
        } else {
            let osType = isDirectory ? kGenericFolderIcon : kGenericDocumentIcon
            let iconType = NSFileTypeForHFSTypeCode(OSType(osType))
            icon = NSWorkspace.shared.icon(forFileType: iconType!)
        }
        return icon
    }
    
    var canChange: Bool {
        return isDirectory && url == nil
    }
    
    var canAddTo: Bool {
        return isDirectory && canChange
    }
    
    var isSeparator: Bool {
        return type == .separator
    }
    
    var isDirectory: Bool {
        return type == .container
    }
}
