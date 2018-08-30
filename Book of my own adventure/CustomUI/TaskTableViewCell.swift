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
import MCSwipeTableViewCell
import BubbleTransition

class TaskTableViewCell: UITableViewCell,UITextViewDelegate{

    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var CategoryButton: UIButton!
    
    
    var delegate: TableViewCellDelegate?
    var task:Task!
    var tableview: UITableView!
    let realm = try! Realm()
    let transition = BubbleTransition()
   

    
    
    override func prepareForReuse() {
        textField.delegate = self
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.delegate = self
        textField.font = UIFont.boldSystemFont(ofSize: CGFloat(24))
        textField.layer.borderWidth = 0
        
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

    
    
    
    func setCell(){
        textField.text = task.text
        
        if self.task.editCell{
            
            print("呼ばれたで")
            
            self.textField.becomeFirstResponder()
            
            try! realm.write {
                self.task.editCell = false
            }
        }
        
        let count = realm.objects(SecondTask.self).filter("category=%@",task.id).count
        CategoryButton.setTitle(String(count), for: .normal)
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            //あなたのテキストフィールド
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    //テキストフィールドが閉じられたら、データを追加、EndEditingを呼ぶ
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        try! realm.write {
            self.task.text = textField.text!
            }
        
        
        if delegate != nil {
            delegate?.cellDidEndEditing(editingCell:self)
            
            
        }
    }
    
    
    
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if delegate != nil {
            delegate?.cellDidBeginEditing(editingCell:self)
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableview.beginUpdates()
        tableview.endUpdates()
    }
    
    
}
