//
//  sellTitleViewController.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/05/28.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class sellTitleViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var cellTitleText: UITextField!
    @IBOutlet var cellImageButton: UIButton!
    @IBOutlet var cellImageView: UIImageView!{
        didSet{
            cellImageView.image = UIImage(named: "images.png")
         
            // 角を丸くする
            cellImageView.layer.cornerRadius = 153 * 0.5
            cellImageView.clipsToBounds = true
         
        }
    }
    var cellImage: UIImage!
    var celectNum: Int?
    var textTitleArray = [String]()
    var imageArrey = [Data]()
    var cellNumber: Int? = 0
    var outout: AVCapturePhotoOutput?
    var photoData: Data!
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
            imageArrey = saveData.object(forKey:"image") as! [Data]
            cellTitleText.text = textTitleArray[celectNum!]
            cellImage = UIImage(data:imageArrey[celectNum!])
            cellImageView.image = cellImage
        }
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
 
    //PhotoLibraryにアクセスする処理。
     @IBAction func pictureSetting(_ sender: UIButton) {
//           let ipc = UIImagePickerController()
//           ipc.delegate = self
//           ipc.sourceType = UIImagePickerController.SourceType.photoLibrary
//           //編集を可能にする
//           ipc.allowsEditing = true
//           self.present(ipc,animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        
        let piker = UIImagePickerController()
        piker.sourceType = .photoLibrary
        piker.delegate = self
        
        piker.allowsEditing = true
        
        present(piker,animated: true, completion: nil)
         print("ssss")
        }

       }
    
    
    //写真を選択した時の処理を書く。
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print("llll")
        //編集機能を表示させたい場合
        //UIImagePickerControllerEditedImageはallowsEditingをYESにした場合に用いる。
        //allowsEditingで指定した範囲を画像として取得する事ができる。
        //UIImagePickerControllerOriginalImageはallowsEditingをYESにしていたとしても編集機能は表示されない。
        if info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] != nil {
            let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as! UIImage
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height
            //画像を設定する
            cellImageView.image = image
            photoData = image.pngData()
            print(photoData!)
           
                let bgImageWidth = image.size.width
                     let bgImageHeight = image.size.height
                     let scale = height / bgImageHeight
                     // 画像表示サイズの設定("scale"で倍率調整)
                     image.draw(in: CGRect(x: 0,y: 0,
                     width: bgImageWidth * scale,
                     height: bgImageHeight * scale))
                     // 画像表示の中心を画面の中心に
                     image.draw(at: CGPoint(x: (width / 2),
                     y: (height / 2)))
            // 角を丸くする
            self.cellImageView.layer.cornerRadius = 153 * 0.5
            self.cellImageView.clipsToBounds = true
           self.view.addSubview(cellImageView)
           self.view.clipsToBounds = true
         }
     
     
         dismiss(animated: true,completion: nil)
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

//        cellImage = cellImageView.image
//        let data = cellImage.pngData()!

        if celectNum == nil {
            print("aaaa")
            textTitleArray.append(cellTitleText.text!)
            imageArrey.append(photoData!)
        } else {
            textTitleArray[celectNum!] =  cellTitleText.text!
            imageArrey[celectNum!] = photoData
        }
        print(imageArrey.count)
        
        saveData.set(textTitleArray, forKey: "title")
        saveData.set(imageArrey, forKey: "image")
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
