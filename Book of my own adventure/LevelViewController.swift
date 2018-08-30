//
//  LevelViewController.swift
//  Book of my own adventure
//
//  Created by 小嶋暸太 on 2018/08/30.
//  Copyright © 2018年 小嶋暸太. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftReorder

class LevelViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TableViewReorderDelegate{
    
    
    

    @IBOutlet weak var DreamtextField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let task = try! Realm().objects(SecondTask.self).filter("check=1").sorted(byKeyPath: "order", ascending: true)
    let userDefaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableView.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero;
        }
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 175, right: 0)
        
        tableView.reorder.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        DreamtextField.delegate = self
        // Do any additional setup after loading the view.
        
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
        let nib = UINib(nibName: "CheckTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismisshundle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dream = DreamtextField.text
        
        userDefaults.set(dream, forKey: "DREAM")
        userDefaults.synchronize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DreamtextField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let dream = userDefaults.string(forKey: "DREAM")
        DreamtextField.text = dream
        
        let levelCount = userDefaults.integer(forKey: "LEVEL")
        categoryButton.setTitle("冒険の記録：（Lv\(levelCount)）", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CheckTableViewCell
        
        let taskdata = task[indexPath.row]
        
        cell.textLavel.text = taskdata.text
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
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
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            let sourceObject = task[sourceIndexPath.row]
            let destinationObject = task[destinationIndexPath.row]
            
            let destinationObjectOrder = destinationObject.order
            
            // 移動したセルの並びを移動先に更新
            destinationObject.order = sourceObject.order
            sourceObject.order = destinationObjectOrder
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
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
