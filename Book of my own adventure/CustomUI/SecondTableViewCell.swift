//
//  SecondTableViewCell.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/29.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import UIKit
import RealmSwift
import MCSwipeTableViewCell

protocol SecondTableViewCellDelegate {
    
    // Indicates that the edit process has begun for the given cell
    func secondCellDidBeginEditing(editingCell: SecondTableViewCell)
    // Indicates that the edit process has committed for the given cell
    func secondCellDidEndEditing(editingCell: SecondTableViewCell)
}

class SecondTableViewCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var textField: UITextView!
    
    
    var delegate: SecondTableViewCellDelegate?
    var task:SecondTask!
    var tableview: UITableView!
    let realm = try! Realm()
    
    
    
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
        
        if textField.text != ""{
            try! realm.write {
                self.task.text = textField.text!
            }
        }else{
            try! realm.write {
                self.realm.delete(task)
            }
        }
        
        if delegate != nil {
            delegate?.secondCellDidEndEditing(editingCell:self)
        }
    }
    
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if delegate != nil {
            delegate?.secondCellDidBeginEditing(editingCell:self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableview.beginUpdates()
        tableview.endUpdates()
    }
    
    

    
}
