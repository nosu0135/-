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
    
    let suiteName: String = "group.com.litech.kennsakuhozonn"
    let keyName: String = "shareData"
    var saveData: UserDefaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        table.dataSource = self
        table.delegate = self
        table.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"Custom")
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")

        let titleDefaults : UserDefaults = UserDefaults(suiteName: "group.com.litech.kennsakuhozonn")!
        if titleDefaults.array(forKey: "number") != nil {
                  print("aaa")
                  cellArrey = titleDefaults.object(forKey: "number") as! [String]
                  table.reloadData()
              }
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
          //URLを取り出す
           let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        
        titleArrey = sharedDefaults.object(forKey: self.keyName) as! [String]
    
        print(titleArrey)
           
        let url = titleArrey[indexPath.row]
             print(url)
               // Safari を起動してそのURLに飛ぶ
               UIApplication.shared.open(URL(string: url)!)
               //                 // データの削除
               //                 sharedDefaults.removeObject(forKey: self.keyName)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
