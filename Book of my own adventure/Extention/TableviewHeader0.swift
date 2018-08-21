//
//  TableviewHeader0.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/20.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import UIKit

extension ViewController{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
