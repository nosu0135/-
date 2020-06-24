//
//  ShareViewController.swift
//  share Extension
//
//  Created by 小田島康之介 on 2020/02/23.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    let suiteName: String = "group.com.litech.kennsakuhozonn"
    let keyName: String = "shareData"
    var titleArray = [String]()
    var imageArrey = [Data]()
    var cellArrey = [String]()
    var hozonNumber: Int?
    var saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // titleName
        self.title = "保存"
        
        // color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red:1.0, green:0.75, blue:0.5, alpha:1.0)
        
        // postName
        let controller: UIViewController = self.navigationController!.viewControllers.first!
        controller.navigationItem.rightBarButtonItem!.title = "保存"
    }
    
    override func isContentValid() -> Bool {
        
        self.charactersRemaining = self.contentText.count as NSNumber?
        print(self.contentText.count)
        let canPost: Bool = self.contentText.count > 0
        
        /*
         let inputItem: Bool = (self.extensionContext?.inputItems.count)! > 0
         
         guard inputItem == true else {
         let alert: UIAlertController = UIAlertController(title:"失敗", message: "画像がありません",preferredStyle: .alert)
         //OKボタン
         alert.addAction(
         UIAlertAction(title: "OK",
         style: .default,
         handler: {action in
         //ボタンが押された時の動作
         }))
         //アラートを表示
         present(alert,animated: true, completion: nil)
         //うまく機能しなかったため返り値を失敗にさせる
         return false
         }
         */
        
        
        if canPost {
            return true
        }
        
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    /**
     * Postを押した後の処理
     */
    override func didSelectPost() {
        
        
        
        guard self.contentText.isEmpty == false else {
            let alert: UIAlertController = UIAlertController(title:"失敗", message: "文字を入力してください",preferredStyle: .alert)
            //OKボタン
            alert.addAction(
                UIAlertAction(title: "OK",
                              style: .default,
                              handler: {action in
                                //ボタンが押された時の動作
                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                }))
            //アラートを表示
            present(alert,animated: true, completion: nil)
            return
        }

        
        
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first!
        
        let puclicURL = String(kUTTypeURL)  // "public.url"
        
        
        let titleDefaults : UserDefaults = UserDefaults(suiteName:"group.com.litech.kennsakuhozonn")!
        
        
        if titleDefaults.object(forKey: "number") as? [String] != nil{
            cellArrey = titleDefaults.object(forKey: "number") as! [String]
        }
        
        cellArrey.append(contentText!)
        
        print(cellArrey)
        titleDefaults.set(cellArrey, forKey:"number")
        
        // shareExtension で NSURL を取得
        if (itemProvider?.hasItemConformingToTypeIdentifier(puclicURL))! {
            itemProvider?.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
                // NSURLを取得する
                if let url: NSURL = item as? NSURL {
                    // ----------
                    // 保存処理
                    // ----------
                    let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
                    
                    if sharedDefaults.object(forKey: self.keyName) as? [String] != nil{
                        self.titleArray = sharedDefaults.object(forKey: self.keyName) as! [String]
                    }
                    self.titleArray.append(url.absoluteString!)
                    sharedDefaults.set(self.titleArray, forKey: self.keyName)
                    print(self.titleArray)
                    print(self.titleArray.count)
                    sharedDefaults.synchronize()
                }
                
            })
            
            
        }
        
        // shareExtension で NSURL を取得
        if (itemProvider?.hasItemConformingToTypeIdentifier(puclicURL))! {
            itemProvider?.loadPreviewImage(options: nil, completionHandler: { (item, error) in
                // 画像を取得する
                if let image = item as? UIImage {
                    // ----------
                    // 保存処理
                    // ----------
                    let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
                    if sharedDefaults.object(forKey: "image") != nil {
                        self.imageArrey = sharedDefaults.object(forKey: "image") as! [Data]
                    }
                    self.imageArrey.append(image.pngData()!)
                    sharedDefaults.setValue(self.imageArrey, forKey: "image")  // そのページの画像をPNGで保存
                    print(self.imageArrey)
                    sharedDefaults.synchronize()
                } else {
                    //画像無しの写真を使う
                    let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
                    let image = UIImage(named: "images.png")
                    let imageData = image!.pngData()
                    if sharedDefaults.object(forKey: "image") != nil {
                        self.imageArrey = sharedDefaults.object(forKey: "image") as! [Data]
                    }
                    self.imageArrey.append(imageData!)
                    sharedDefaults.setValue(self.imageArrey, forKey: "image")
                    sharedDefaults.synchronize()
                }
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            })
        }
        
        
        print("asdf")
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(a:))
        
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: URL(string: "myapp://next")!)
                return
            }
            responder = responder?.next
        }
        
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    @objc func openURL(a url: URL) {
        let _ = URL(string: "myapp://next")
        //UIApplication.shared.openURL(url!)
        // iOS 10以降利用可能
        
        return
    }
    
}
