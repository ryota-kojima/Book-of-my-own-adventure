//
//  TaskTableViewCell.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/18.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

protocol TableViewCellDelegate {
    
    // Indicates that the edit process has begun for the given cell
    func cellDidBeginEditing(editingCell: TaskTableViewCell)
    // Indicates that the edit process has committed for the given cell
    func cellDidEndEditing(editingCell: TaskTableViewCell)
}

import UIKit
import RealmSwift

class TaskTableViewCell: UITableViewCell,UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    
    var delegate: TableViewCellDelegate?
    var task:Task!
    let realm = try! Realm()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.delegate = self
        textField.becomeFirstResponder()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCell(_ task:Task){
        textField.text = task.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //テキストフィールドが閉じられたら、データを追加、EndEditingを呼ぶ
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text != ""{
        try! realm.write {
            self.task.text = textField.text!
            }
        }
        
        if delegate != nil {
            delegate?.cellDidEndEditing(editingCell:self)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate!.cellDidBeginEditing(editingCell:self)
        }
    }
    
    
}
