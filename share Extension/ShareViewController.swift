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

         let canPost: Bool = self.contentText.count > 0
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
               self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
           })
        
 
       }
      
    func openContainerApp() {
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

   
    }
    
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    @objc func openURL(a url: URL) {
            return
        }

}
