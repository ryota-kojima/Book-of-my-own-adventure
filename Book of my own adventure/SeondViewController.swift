//
//  SeondViewController.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/29.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import UIKit
import SwiftReorder
import RealmSwift
import MCSwipeTableViewCell
import BubbleTransition
import LTMorphingLabel
import  AudioToolbox


class SeondViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,TableViewReorderDelegate,SecondTableViewCellDelegate,LTMorphingLabelDelegate {
    
    @IBOutlet weak var TopView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var DreamtextField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var levelButton: UIButton!
    
    @IBOutlet weak var levelLaebl: LTMorphingLabel!
    
    
    
    let transition = BubbleTransition()
    //Realmのインスタンス
    let realm = try! Realm()
    var task = try! Realm().objects(SecondTask.self).sorted(byKeyPath: "order", ascending: true)
    var cellColor: UIColor!
    
    let userDefaults:UserDefaults = UserDefaults.standard
    
    var taskid: Task!
    var nowEditing = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DreamtextField.delegate = self
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: DreamtextField.frame.width+3, y: 0, width: 0.5, height:DreamtextField.frame.height)
        rightBorder.backgroundColor = UIColor.darkGray.cgColor
        
        let leftBorder = CALayer()
        leftBorder.frame = CGRect(x: -3, y: 0, width: 0.3, height:DreamtextField.frame.height)
        leftBorder.backgroundColor = UIColor.darkGray.cgColor
        
        DreamtextField.layer.addSublayer(rightBorder)
        DreamtextField.layer.addSublayer(leftBorder)
        
        //separateを端まで引く
        if tableView.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero;
        }
        
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 175, right: 0)
        
        //テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableviewのおおよその高さを導き出す。これでスクロールの値などが予測される
        //高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = 44
        
        //ステータスバーの色を変更
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        statusBar.backgroundColor = UIColor.black
        
        view.addSubview(statusBar)
        
        
        //nibファイルの生成
        let nib = UINib(nibName: "SecondTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let tapGesture:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(addCell))
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.reorder.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("DEBUG_PRINT:update")
        try! realm.write {
            let sourceObject = task[sourceIndexPath.row]
            let destinationObject = task[destinationIndexPath.row]
            
            let destinationObjectOrder = destinationObject.order
            
            // 移動したセルの並びを移動先に更新
            destinationObject.order = sourceObject.order
            sourceObject.order = destinationObjectOrder
            
        }
        
        //tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    @IBAction func addTopButton(_ sender: Any) {
        
        if nowEditing == true{
            self.view.endEditing(true)
            return
        }
        
        
        print("DEBUG_PRINT:addCell")
        //タスクの設定とリストの追加
        let taskdata = SecondTask()
        
        let allTask = realm.objects(SecondTask.self)
        if allTask.count != 0{
            taskdata.id = allTask.max(ofProperty: "id")!+1
            
            taskdata.order = allTask.min(ofProperty: "order")!-1
        }
        
        //おやたすくのIDをカテゴリ名とする
        taskdata.editCell = true
        taskdata.category = taskid.id
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userDefaults.set(DreamtextField.text, forKey: "DREAM")
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let dream = userDefaults.string(forKey: "DREAM")
        if dream != nil{
        DreamtextField.text = dream
        
            
        }
        
        let levelCount = userDefaults.integer(forKey: "LEVEL")
        
        levelLaebl.text = "Lv.\(levelCount)"
        
        
        task = realm.objects(SecondTask.self).filter("category=%@",taskid.id).sorted(byKeyPath: "order", ascending: true)
        
        categoryButton.setTitle(taskid.text, for: .normal)
        
    }
    
    
    @objc func addCell(){
        
        if nowEditing == true{
            self.view.endEditing(true)
            return
        }
        
        print("DEBUG_PRINT:addCell")
        //タスクの設定とリストの追加
        let taskdata = SecondTask()
        
        let allTask = realm.objects(SecondTask.self)
        if allTask.count != 0{
            taskdata.id = allTask.max(ofProperty: "id")!+1
            
            taskdata.order = allTask.max(ofProperty: "order")!+1
        }
        
        taskdata.editCell = true
        taskdata.category = taskid.id
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return task.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SecondTableViewCell
        
        let taskdata = task[indexPath.row]
        
        cell.task = (taskdata)
        cell.delegate = self as? SecondTableViewCellDelegate
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.tableview = self.tableView
        cell.setCell()
        
        cell.insertButton.addTarget(self, action: #selector(insertCell(_:forEvent:)), for: .touchUpInside)
        
        
        
        return cell
    }
    
    @objc func insertCell(_ sender:UIButton, forEvent event: UIEvent){
        if nowEditing == true{
            self.view.endEditing(true)
            return
        }
        
        let touch = event.allTouches?.first
        let point = touch?.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point!)
        
        let taskdata = SecondTask()
        
        let allTask = realm.objects(SecondTask.self)
        if allTask.count != 0{
            taskdata.id = allTask.max(ofProperty: "id")!+1
            
            if indexPath!.row != 0{
            
            try! realm.write {
                
                let destinationorder = task[indexPath!.row-1].order
            
                // 下から上に移動した場合、間の項目を下にシフト
                for indexrow in 0 ... indexPath!.row-1{
                    let object = task[indexrow]
                    object.order -= 1
                    }
            
            // 移動したセルの並びを移動先に更新
                taskdata.order = destinationorder
                }
                
            }else{
                
                
                try! realm.write {
                    
                    taskdata.order = allTask.min(ofProperty: "order")!-1
                }
        }
}
        
        
        taskdata.editCell = true
        taskdata.category = taskid.id
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let destructiveAction = UIContextualAction(style: .destructive,
                                                   title: "") { (action, view, completionHandler) in
                                                    completionHandler(true)
                                                    
                                                    try! self.realm.write {
                                                        self.realm.delete(self.task[indexPath.row])
                                                    }
                                                    //削除のアニメーション入れてから、データを更新。
                                                    UIView.animate(withDuration: 0, animations: {
                                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                                    }, completion: {finished in
                                                        if (finished){
                                                            tableView.reloadData()
                                                            
                                                        }
                                                    })
                                                    
                                                    
        }
        
        let trash = UIImage(named: "trashBox")
        
        destructiveAction.image = trash?.scaleImage(scaleSize: 0.15)
        destructiveAction.backgroundColor = UIColor(red: 244, green: 0, blue: 0, alpha: 0)
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //チェックマークの画像を挿入予定
        
        let destructiveAction = UIContextualAction(style: .destructive,
                                                   title: "") { (action, view, completionHandler) in
                                                    completionHandler(true)
                                                    
                                                    //バイブを鳴らす
                                                    self.shortVibrate()
                                                    
                                                    let allTask = self.realm.objects(SecondTask.self).filter("check=1")
                                                    
                                                    
                                                    try! self.realm.write {
                                                        self.task[indexPath.row].check = 1
                                                        self.task[indexPath.row].category = 999999
                                                        //カテゴリーからは消したいが、次に追加されるものと被らないようするため
                                                        
                                                        if allTask.count != 0{
                                                            
                                                            self.task[indexPath.row].order = allTask.min(ofProperty: "order")!-1
                                                        }//levelviewで達成した順に上から表示されるようにする
                                                        
                                                    }
                                                    
                                                    var levelCount = self.userDefaults.integer(forKey: "LEVEL")
                                                    levelCount += 1 //レベルアップ
                                                    self.userDefaults.set(levelCount, forKey: "LEVEL")
                                                    
                                                    self.levelLaebl.morphingEffect = .sparkle

                                                    self.levelLaebl.text = "Lv.\(levelCount)"
                                                    
                                                    
                                                    
                                                    
                                                    UIView.animate(withDuration: 0, animations: {
                                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                                    }, completion: {finished in
                                                        if (finished){
                                                            tableView.reloadData()
                                                        }
                                                        
                                                    })
                                                    
                                                    
        }
        
        destructiveAction.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
        
        let Check = UIImage(named: "check")
        destructiveAction.image = Check?.scaleImage(scaleSize: 0.4)
        
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        
        return configuration
    }
    
    
    
    
    
    func secondCellDidBeginEditing(editingCell: SecondTableViewCell) {
        
        nowEditing = true
        
        DispatchQueue.main.async {
            
            
            let editingOffset = self.tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
            let visibleCells = self.tableView.visibleCells as! [SecondTableViewCell]
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.transform = CGAffineTransform(translationX: 0, y: editingOffset)
            })
            for cell in visibleCells {
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    //cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                    
                    if cell != editingCell {
                        
                        self.cellColor = cell.backgroundColor!
                        
                        cell.contentView.alpha = 0.3
                    }
                })
            }
        }
    }
    
    func secondCellDidEndEditing(editingCell: SecondTableViewCell) {
        
        nowEditing = false
        
        let visibleCells = tableView.visibleCells as! [SecondTableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as SecondTableViewCell
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.transform = CGAffineTransform.identity
        })
        
        for cell: SecondTableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                cell.transform = CGAffineTransform.identity
                if cell != editingCell {
                    cell.contentView.alpha  = 1.0
                    
                }
            }, completion: { (Finished: Bool) -> Void in
                if cell == lastView {
                    self.tableView.reloadData()
                }
            })
        }
    }
    

    @IBAction func transition(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func shortVibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
