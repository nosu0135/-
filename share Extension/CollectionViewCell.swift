//
//  CollectionViewCell.swift
//  share Extension
//
//  Created by 小田島康之介 on 2020/06/28.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var imageView: UIImageView!{
        didSet{
            // 角を丸くする
            imageView.layer.cornerRadius = 77 * 0.5
            imageView.clipsToBounds = true
        }
    }
       
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
