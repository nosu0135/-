//
//  urlDetailsViewController.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/06/07.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit

class urlDetailsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var urlImage: UIImageView!
    @IBOutlet var urlNameLabel: UILabel!
    
    var urlcelectNum: Int?
    var nameArrey = [String]()
    var imageArrey = [Data]()
    var urlArrey = [String]()
 
    let keyName: String = "shareData"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameText.returnKeyType = UIReturnKeyType.done
        nameText.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlDefaults : UserDefaults = UserDefaults(suiteName: "group.com.litech.kennsakuhozonn")!
        if urlDefaults.object(forKey: "number") != nil {
            nameArrey = urlDefaults.object(forKey: "number") as! [String]
            
        }
        if urlDefaults.object(forKey: "image") != nil {
            imageArrey = urlDefaults.object(forKey: "image") as! [Data]
        }
        if urlDefaults.object(forKey: self.keyName) != nil{
            urlArrey = urlDefaults.object(forKey: self.keyName) as! [String]
        }
        
        if urlcelectNum != nil {
            nameText.text = nameArrey[urlcelectNum!]
            urlImage.image = UIImage(data: imageArrey[urlcelectNum!])
            urlNameLabel.text = urlArrey[urlcelectNum!]
        }
    }
    @IBAction func go(){
        let url = urlArrey[urlcelectNum!]
        // Safari を起動してそのURLに飛ぶ
                     UIApplication.shared.open(URL(string: url)!)
    }
    
    @IBAction func save(){
        guard nameText.text?.isEmpty == false else {
            
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
        
        let urlDefaults : UserDefaults = UserDefaults(suiteName: "group.com.litech.kennsakuhozonn")!
        nameArrey[urlcelectNum!] = nameText.text!
        urlDefaults.set(nameArrey, forKey: "number")
        
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
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


