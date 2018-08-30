//
//  peddingLabel.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/30.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    
    // paddingの値
    var padding = UIEdgeInsets(top: 10,left: 0,bottom: 10,right: 5)
    
    override func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
