//
//  SwitchBarCell.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/21.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class SwitchBarCell: UITableViewCell {

    @IBOutlet weak var switchBar: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
