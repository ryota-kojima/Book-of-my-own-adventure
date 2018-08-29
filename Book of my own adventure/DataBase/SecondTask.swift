//
//  SecondTask.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/29.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import RealmSwift

class SecondTask:Object{
    @objc dynamic var  id = 0
    
    @objc dynamic var text = ""
    
    @objc dynamic var category = 0
    
    @objc dynamic var order = 0
    
    @objc dynamic var editCell = false
    
    @objc dynamic var date=Date()
    
    //Idをプライマリーキーに設定
    override static func primaryKey()->String?{
        return "id"
    }
}
