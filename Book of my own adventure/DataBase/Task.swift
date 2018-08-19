//
//  Task.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/18.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import RealmSwift

class Task:Object{
    @objc dynamic var  id = 0
    
    @objc dynamic var text = ""
    
    @objc dynamic var category = ""
    
    @objc dynamic var order = 0
    
    @objc dynamic var date=Date()
    
    //Idをプライマリーキーに設定
    override static func primaryKey()->String?{
        return "id"
    }
}

class TaskWrapper:Object{
    let list = List<Task>()
}
