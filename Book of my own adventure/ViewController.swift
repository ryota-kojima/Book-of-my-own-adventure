//
//  ViewController.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/18.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import UIKit
import SwiftReorder
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    //Realmのインスタンス
    let realm = try! Realm()
    let task = try! Realm().objects(Task.self).sorted(byKeyPath: "order", ascending: true)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //nibファイルの生成
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let tapGesture:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(addCell))
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.reorder.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @objc func addCell(){
        
        print("DEBUG_PRINT:addCell")
        //タスクの設定とリストの追加
        let taskdata = Task()
        
        let allTask = realm.objects(Task.self)
        if allTask.count != 0{
            taskdata.id = allTask.max(ofProperty: "id")!+1
            
            taskdata.order = allTask.max(ofProperty: "order")!+1
        }
        
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        
       tableView.reloadData()
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return task.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskTableViewCell
        
        let taskdata = task[indexPath.row]
        
        cell.task = (taskdata)
        cell.setCell(taskdata)
        cell.delegate = self
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    
    
    
    
    func cellDidBeginEditing(editingCell: TaskTableViewCell) {
        let editingOffset = self.tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = self.tableView.visibleCells as! [TaskTableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell != editingCell {
                    cell.alpha = 0.3
                }
            })
        }
        
    }
    
    func cellDidEndEditing(editingCell: TaskTableViewCell) {
        
        let visibleCells = tableView.visibleCells as! [TaskTableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TaskTableViewCell
        for cell: TaskTableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                cell.transform = CGAffineTransform.identity
                if cell != editingCell {
                    cell.alpha = 1.0
                }
            }, completion: { (Finished: Bool) -> Void in
                if cell == lastView {
                    self.tableView.reloadData()
                }
            })
        }
    }

}
