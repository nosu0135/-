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

class ShareViewController: SLComposeServiceViewController,ListViewControllerDelegate {
    
    let suiteName: String = "group.com.litech.kennsakuhozonn"
    let keyName: String = "shareData"
    var titleArray = [String]()
    var imageArrey = [Data]()
    var cellArrey = [String]()
    var hozonNumber: Int?
    var saveData: UserDefaults = UserDefaults.standard
    lazy var ratingItem: SLComposeSheetConfigurationItem = {
        var item = SLComposeSheetConfigurationItem()
        item!.title = "カテゴリー"
        item!.value = "なし"
        item!.tapHandler = self.showListViewControllerOfRating
        return item!
    }()
    
    
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
    
    
    override func configurationItems() -> [Any]! {
        return [ratingItem]
    }
    
    //カテゴリーボタンを押した時
    func showListViewControllerOfRating() {
        performSegue(withIdentifier: "goImage", sender: nil)
    }
    
    func listViewController(sender: ListViewController, selectedValue: String) {
        ratingItem.value = selectedValue
        popConfigurationViewController()
    }
    override func isContentValid() -> Bool {
        
        
        self.charactersRemaining = self.contentText.count as NSNumber?
        print(self.contentText.count)
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
    
    @objc func openURL(a url: URL) {
        let _ = URL(string: "myapp://next")
        //UIApplication.shared.openURL(url!)
        // iOS 10以降利用可能
        
        return
    }
    
}


@objc(ListViewControllerDelegate)
protocol ListViewControllerDelegate {
    @objc optional func listViewController(sender: ListViewController, selectedValue: String)
}

class ListViewController:  UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: ListViewControllerDelegate?
    var itemList: [String] = []
    var selectedValue: String!
    var textTitleArrey = [String]()
    var imageArrey = [Data]()
    
    let suiteName: String = "group.com.litech.kennsakuhozonn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isUserInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        // レイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
        
        
        //        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if sharedDefaults.array(forKey: "mainImage") != nil{
            textTitleArrey = sharedDefaults.object(forKey: "mainTitle") as! [String]
            imageArrey = sharedDefaults.object(forKey: "mainImage") as! [Data]
            print(imageArrey.count)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CollectionViewCell
        print(textTitleArrey)
        cell.name?.text = textTitleArrey[indexPath.row]
        cell.imageView?.image = UIImage(data: imageArrey[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 10
        let cellSize : CGFloat = view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    //セルがタップされたら
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         print("ここにいるよ")
        if let theDelegate = delegate{
            theDelegate.listViewController?(sender: self, selectedValue: textTitleArrey[indexPath.row])
        }
       self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(){
        print("ここにいるよ")
       self.dismiss(animated: true, completion: nil)
    }
    
}
