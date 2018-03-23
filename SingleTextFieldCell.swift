//
//  SingleTextFieldCell.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/21.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class SingleTextFieldCell: UITableViewCell {

    @IBOutlet weak var textWindow: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textWindow.frame.size.height = 44
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
