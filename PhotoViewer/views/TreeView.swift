//
//  TreeView.swift
//  PhotoViewer
//
//  Created by SEHUN KIM on 2020/01/18.
//  Copyright © 2020 SEHUN KIM. All rights reserved.
//

import SwiftUI

class TreeViewController: NSViewController {
    
    struct NameConstants {
        static let untitled = NSLocalizedString("untitled string", comment: "")
        static let places = NSLocalizedString("places string", comment: "")
        static let pictures = NSLocalizedString("pictures string", comment: "")
    }
    
    struct NotificationNames {
        static let selectionChanged = "selectionChangeNotification"
    }
    
    class func node(from item: Any) -> Node? {
        if let treeNode = item as? NSTreeNode, let node = treeNode.representedObject as? Node {
            return node
        } else {
            return nil
        }
    }
    
    let items: [String]? = ["test1", "test2", "test3", "test4", "test5", "test6", "test7"]
    
    var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.outlineView = NSOutlineView()
        self.outlineView.dataSource = self
        self.outlineView.delegate = self
    }
}

extension TreeViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        let node = TreeViewController.node(from: item)
        return node!.isSpecialGroup
    }
}

extension TreeViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let items = self.items {
            return items.count
        } else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let items = self.items {
            return items[index]
        } else {
            return item!
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
}

struct OutlineViewController: NSViewControllerRepresentable {
    
    typealias NSViewControllerType = TreeViewController
    
    func updateNSViewController(_ nsViewController: TreeViewController, context: NSViewControllerRepresentableContext<OutlineViewController>) {
        
    }
    
    func makeNSViewController(context: NSViewControllerRepresentableContext<OutlineViewController>) -> OutlineViewController.NSViewControllerType {
        
        let viewController = NSViewControllerType()
        return viewController
    }
}

//struct TreeView: NSViewRepresentable {
//
//    typealias NSViewType = NSOutlineView
//
//    var viewController = TreeViewController()
//
//    func makeNSView(context: Context) -> NSOutlineView {
//        let view = NSOutlineView()
//        view.dataSource = viewController
//        view.delegate = viewController
//        return view
//    }
//
//    func updateNSView(_ nsView: NSOutlineView, context: Context) {
//        return
//    }
//}
//
//struct TreeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeView()
//    }
//}
