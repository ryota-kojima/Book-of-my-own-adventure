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

class ViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate,UITextFieldDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    //Realmのインスタンス
    let realm = try! Realm()
    let task = try! Realm().objects(Task.self).sorted(byKeyPath: "order", ascending: true)
    var cellColor: UIColor!
    
    let userDefaults:UserDefaults = UserDefaults.standard
    var taskid:Task!
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var DreamtextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DreamtextField.delegate = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 175, right: 0)
        
        //テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableviewのおおよその高さを導き出す。これでスクロールの値などが予測される
        //高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = 1000
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController: SeondViewController! = segue.destination as! SeondViewController
        
        secondViewController.taskid = self.taskid
    }
    
    @IBAction func addTopButton(_ sender: Any) {
        
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
        
        
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue){
        
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
       
        
        return cell
    }
    
    @objc func handleButton(_ sender:UIButton, forEvent event: UIEvent){
        
        let touch = event.allTouches?.first
        let point = touch?.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point!)
        
        taskid = task[indexPath!.row]
        
        performSegue(withIdentifier: "secondSegue", sender: nil)

    }
    
   
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let destructiveAction = UIContextualAction(style: .normal,
                                                   title: "Delete") { (action, view, completionHandler) in
                                                
                                                    
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
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //チェックマークの画像を挿入予定
        
        let destructiveAction = UIContextualAction(style: .destructive,
                                                   title: "") { (action, view, completionHandler) in
                                                    completionHandler(true)
                                                    try! self.realm.write {
                                                        self.realm.delete(self.task[indexPath.row])
                                                    }
                                                    UIView.animate(withDuration: 0, animations: {
                                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                                    }, completion: {finished in
                                                        if (finished){
                                                            tableView.reloadData()
                                                        }
                                                        
                                                    })
                                                    
                                                    
        }
        
        destructiveAction.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        
        return configuration
    }
    
    
    
    
    
    func cellDidBeginEditing(editingCell: TaskTableViewCell) {
        
        
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
