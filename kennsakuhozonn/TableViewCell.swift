//
//  TableViewCell.swift
//  kennsakuhozonn
//
//  Created by 小田島康之介 on 2020/02/22.
//  Copyright © 2020 小田島康之介. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
 
    @IBOutlet var cellLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
