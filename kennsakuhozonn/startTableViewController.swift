//
//  startTableViewController.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/05/28.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit

class startTableViewController: UITableViewController {
   
    @IBOutlet var startTable: UITableView!
    var titleArray = [String]()
    var saveData: UserDefaults = UserDefaults.standard
    var arreyNum: Int?
    var number: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTable.dataSource = self
        startTable.delegate = self
        startTable.register (UINib(nibName: "startTableViewCell", bundle: nil),forCellReuseIdentifier:"Customcell")
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = editButtonItem
        
         tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           arreyNum = nil
        if saveData.array(forKey: "title") != nil {
            titleArray = saveData.array(forKey: "title") as! [String]
            print(titleArray)
            startTable.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 113
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titleArray.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Customcell") as! startTableViewCell
        
        cell.startTableViewCellLabel?.text = titleArray[indexPath.row]
        
        return cell
    }
    
     //セルがタップされたら
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        performSegue(withIdentifier: "toUrlVC", sender: nil)
          
       }


    @IBAction func add(){
        saveData.set(arreyNum, forKey: "cellNumber")
        performSegue(withIdentifier: "toNew", sender: nil)
    }
    
    //並び替え機能
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = titleArray[sourceIndexPath.row]
        titleArray.remove(at: sourceIndexPath.row)
        titleArray.insert(todo, at: destinationIndexPath.row)
        self.saveData.set(titleArray, forKey: "title")
    }
     //削除機能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        titleArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        self.saveData.set(titleArray, forKey: "title")
    }
     //削除スワイプ機能
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    //左スワイプ
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "詳細") { (ctxAction, view, completionHandler) in
            self.arreyNum = indexPath.row
            self.goName()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    @objc func goName(){
        performSegue(withIdentifier: "toName", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toName"{
        let vc = segue.destination as! sellTitleViewController
        vc.celectNum = arreyNum
        }
    }
      //外部からアプリを開く
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //リクエストされたURLの中からhostの値を取得して変数に代入
        let urlHost : String = (url.host as String?)!

        //遷移させたいViewControllerが格納されているStoryBoardファイルを指定
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        //urlHostにnextが入っていた場合はmainstoryboard内のnextViewControllerのviewを表示する
        if(urlHost == "next"){
            let _: startTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "startTableViewController") as! startTableViewController
            
        }
       
        return true
    }
    
}
