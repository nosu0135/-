//
//  startTableViewCell.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/05/28.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit

class startTableViewCell: UITableViewCell {
    @IBOutlet var startTableViewCellLabel: UILabel!
    @IBOutlet var startTableViewImageView: UIImageView!{
           didSet{
               // 角を丸くする
               startTableViewImageView.layer.cornerRadius = 85 * 0.5
               startTableViewImageView.clipsToBounds = true
            
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
