//
//  tableviewDrangSort.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/18.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import SwiftReorder
import RealmSwift

extension ViewController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data model
        
        print("DEBUG_PRINT:update")
        try! realm.write {
            let sourceObject = task[sourceIndexPath.row]
            let destinationObject = task[destinationIndexPath.row]
            
            let destinationObjectOrder = destinationObject.order
            
            // 移動したセルの並びを移動先に更新
            destinationObject.order = sourceObject.order
            sourceObject.order = destinationObjectOrder
            
        }
        
        tableView.reloadData()
    }
}
