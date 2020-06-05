//
//  TableViewController.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/02/22.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit
import MobileCoreServices

class TableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
   
    var titleArrey = [String]()
    var cellArrey = [String]()
    var rowNumber: Int?
    let suiteName: String = "group.com.litech.kennsakuhozonn"
    let keyName: String = "shareData"
    var saveData: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        table.dataSource = self
        table.delegate = self
        table.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"Custom")
       navigationController?.isNavigationBarHidden = false
       navigationItem.rightBarButtonItem = editButtonItem
       tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
     
        let titleDefaults : UserDefaults = UserDefaults(suiteName: "group.com.litech.kennsakuhozonn")!
        if titleDefaults.array(forKey: "number") != nil {
                  print("aaa")
                  cellArrey = titleDefaults.object(forKey: "number") as! [String]
                  table.reloadData()
              }
        rowNumber = cellArrey.count
        
        //URLを取り出す
                let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
             
             titleArrey = sharedDefaults.object(forKey: self.keyName) as! [String]
        
//        if saveData.array(forKey: "title") != nil {
//            titleArrey = saveData.array(forKey: "title") as! [String]
//            table.reloadData()
//        }
    }

    
    
  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellArrey.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 85
       }
          

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom") as? TableViewCell

        cell?.cellLabel?.text = cellArrey[indexPath.row]
        return cell!
    }
    
     //セルがタップされたら
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    
        print(titleArrey)
           
        let url = titleArrey[indexPath.row]
             print(url)
               // Safari を起動してそのURLに飛ぶ
               UIApplication.shared.open(URL(string: url)!)
               //                 // データの削除
               //                 sharedDefaults.removeObject(forKey: self.keyName)

    }
    
    //並び替え機能
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let title = cellArrey[sourceIndexPath.row]
        cellArrey.remove(at: sourceIndexPath.row)
        cellArrey.insert(title, at: destinationIndexPath.row)
        
        let url = titleArrey[sourceIndexPath.row]
        titleArrey.remove(at: sourceIndexPath.row)
        titleArrey.insert(url, at: destinationIndexPath.row)
        
        let chengeDefaults : UserDefaults = UserDefaults(suiteName: self.suiteName)!
          
          chengeDefaults.set(cellArrey, forKey: "number")
          chengeDefaults.set(titleArrey, forKey: self.keyName)
    }
    //削除機能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cellArrey.remove(at: indexPath.row)
        titleArrey.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        let deleteDefaults : UserDefaults = UserDefaults(suiteName: self.suiteName)!
        
        deleteDefaults.set(cellArrey, forKey: "number")
        deleteDefaults.set(titleArrey, forKey: self.keyName)
        print(cellArrey)
        print(titleArrey)
    }
      //削除スワイプ機能
     override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         if tableView.isEditing {
             return .delete
         }
         return .none
     }

}
