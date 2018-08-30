//
//  CheckTableViewCell.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/30.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textLavel: PaddingLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        textLavel.font = UIFont.boldSystemFont(ofSize: CGFloat(24))
        textLavel.layer.borderWidth = 0
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
