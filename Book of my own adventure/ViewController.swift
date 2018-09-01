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
import MCSwipeTableViewCell
import BubbleTransition
import AudioToolbox

class ViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate,UITextFieldDelegate{
    

    @IBOutlet weak var tableView: UITableView!
    
    //Realmのインスタンス
    let realm = try! Realm()
    let task = try! Realm().objects(Task.self).sorted(byKeyPath: "order", ascending: true)
    var cellColor: UIColor!
    let transition = BubbleTransition()
    let userDefaults:UserDefaults = UserDefaults.standard
    var taskid:Task!
    var nowEditing = false
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var DreamtextField: UITextField!
    @IBOutlet weak var levelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
        //ボタンの幅に合わせてフォントサイズを変える
        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        
        
        DreamtextField.delegate = self
        
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
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let tapGesture:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(addCell))
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.reorder.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
        DreamtextField.text = dream
        
        let levelCount = userDefaults.integer(forKey: "LEVEL")
        
        levelButton.setTitle("Lv.\(levelCount)", for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "secondSegue"{
        let secondViewController: SeondViewController! = segue.destination as! SeondViewController
        
        secondViewController.taskid = self.taskid
        }
        //bubbletransition
        
        if segue.identifier == "levelSegue"{
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        }else{
        let vc = segue.destination
        
        vc.modalTransitionStyle = .coverVertical
        
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func addTopButton(_ sender: Any) {
        
        if nowEditing == true{
            self.view.endEditing(true)
            return
        }
        
        print("DEBUG_PRINT:addCell")
        //タスクの設定とリストの追加
        let taskdata = Task()
        
        let allTask = realm.objects(Task.self)
        if allTask.count != 0{
            taskdata.id = allTask.max(ofProperty: "id")!+1
            
            taskdata.order = allTask.min(ofProperty: "order")!-1
        }
        
        taskdata.editCell = true
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
            
        }
        
        
        
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue){
        
    }
    
    
    
    @objc func addCell(){
        
        if nowEditing == true{
            
            self.view.endEditing(true)
            return
        }
        
        print("DEBUG_PRINT:addCell")
        //タスクの設定とリストの追加
        let taskdata = Task()
        
        let allTask = realm.objects(Task.self)
        if allTask.count != 0{
            taskdata.id = allTask.max(ofProperty: "id")!+1
            
            taskdata.order = allTask.max(ofProperty: "order")!+1
        }
        
        taskdata.editCell = true
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        
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
        cell.delegate = self
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.tableview = self.tableView
        cell.setCell()
        
        
        cell.CategoryButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
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
        
        let taskdata = Task()
        
        let allTask = realm.objects(Task.self)
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
       
        
        try! realm.write {
            self.realm.add(taskdata,update:true)
        }
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
    }
    
    @objc func handleButton(_ sender:UIButton, forEvent event: UIEvent){
        
        if nowEditing == true{
            self.view.endEditing(true)
            return
        }
        
        let touch = event.allTouches?.first
        let point = touch?.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point!)
        
        taskid = task[indexPath!.row]
        
        performSegue(withIdentifier: "secondSegue", sender: nil)

    }
    
   
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let destructiveAction = UIContextualAction(style: .normal,
                                                   title: "") { (action, view, completionHandler) in
                                                
                                                    
                                                    // ① UIAlertControllerクラスのインスタンスを生成
                                                    // タイトル, メッセージ, Alertのスタイルを指定する
                                                    // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
                                                    let alert: UIAlertController = UIAlertController(title: "カテゴリー内のすべてのタスクが削除されます", message: "削除してもよろしいですか？", preferredStyle:  UIAlertControllerStyle.alert)
                                                    
                                                    // ② Actionの設定
                                                    // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                                                    // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                                                    // OKボタン
                                                    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                                                        // ボタンが押された時の処理を書く（クロージャ実装）
                                                        
                                                        (action: UIAlertAction!) -> Void in
                                                        
                                                        let deletearray = self.realm.objects(SecondTask.self).filter("category=%@",self.task[indexPath.row].id)
                                                        
                                                        try! self.realm.write {
                                                            self.realm.delete(self.task[indexPath.row])
                                                             //下にあるタスクも削除
                                                            for delete in deletearray{
                                                            self.realm.delete(delete)
                                                            }
                                                        }
                                                        //削除のアニメーション入れてから、データを更新。
                                                        UIView.animate(withDuration: 0, animations: {
                                                            tableView.deleteRows(at: [indexPath], with: .fade)
                                                        }, completion: {finished in
                                                            if (finished){
                                                                tableView.reloadData()
                                                            }
                                                        })
                                                        
                                                    })
                                                    
                                                    // キャンセルボタン
                                                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                                                        // ボタンが押された時の処理を書く（クロージャ実装）
                                                        (action: UIAlertAction!) -> Void in
                                                        
                                                    })
                                                    
                                                    // ③ UIAlertControllerにActionを追加
                                                    alert.addAction(cancelAction)
                                                    alert.addAction(okAction)
                                                    
                                                    // ④ Alertを表示
                                                        self.present(alert, animated: true, completion: nil)
        
                                                     completionHandler(true)
        }
        destructiveAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
        
        let trash = UIImage(named: "trashBox")
        
        destructiveAction.image = trash?.scaleImage(scaleSize: 0.15)
        
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        return configuration
    }
    
    func cellDidBeginEditing(editingCell: TaskTableViewCell) {
        
        nowEditing = true
        
        DispatchQueue.main.async {
            
        
        let editingOffset = self.tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = self.tableView.visibleCells as! [TaskTableViewCell]
        
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
    
    func cellDidEndEditing(editingCell: TaskTableViewCell) {
        
        nowEditing = false
        
        let visibleCells = tableView.visibleCells as! [TaskTableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TaskTableViewCell
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.transform = CGAffineTransform.identity
        })
        
        for cell: TaskTableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                cell.transform = CGAffineTransform.identity
                if cell != editingCell {
                    cell.contentView.alpha = 1.0
                    
                }
            }, completion: { (Finished: Bool) -> Void in
                if cell == lastView {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    

}
