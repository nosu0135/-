//
//  sellTitleViewController.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/05/28.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit

class sellTitleViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var cellTitleText: UITextField!
    @IBOutlet var cellNumberButton: UIButton!
    var celectNum: Int?
    var textTitleArray = [String]()
    var cellNumber: Int? = 0
    var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

       cellTitleText.returnKeyType = UIReturnKeyType.done
       cellTitleText.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       print("viewWillAppear")
        
        if saveData.array(forKey: "title") != nil {
           textTitleArray = saveData.object(forKey: "title") as! [String]
        }
        
        if celectNum != nil{
            cellTitleText.text = textTitleArray[celectNum!]
        }
        
  }
 
    
     
    
    @IBAction func save(){
        guard cellTitleText.text?.isEmpty == false else {
            
            let alert: UIAlertController = UIAlertController(title:"失敗", message: "文字を入力してください",preferredStyle: .alert)
            //OKボタン
            alert.addAction(
                UIAlertAction(title: "OK",
                              style: .default,
                              handler: {action in
                                //ボタンが押された時の動作
                }))
            //アラートを表示
            present(alert,animated: true, completion: nil)
            return
        }
        textTitleArray.append(cellTitleText.text!)
        saveData.set(cellNumber, forKey: String(cellTitleText.text!)+"cell")
        saveData.set(textTitleArray, forKey: "title")
        //alertを出す
        let alert: UIAlertController = UIAlertController(title:"保存", message: "保存が完了しました",
                                                         preferredStyle: .alert)
        //OKボタン
        alert.addAction(
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: {action in
                            //ボタンが押された時の動作
                            self.navigationController?.popViewController(animated: true)
            }))
        //アラートを表示
        present(alert,animated: true, completion: nil)
        
    }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
            
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
