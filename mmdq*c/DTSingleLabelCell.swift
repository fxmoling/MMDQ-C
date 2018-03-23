//
//  DTSingleLabelCellTableViewCell.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/7/13.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class DTSingleLabelCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func setLabelFont(_ font: UIFont) {
        label.font = font
    }
    
    func setLabelText(_ text: String) {
        label.text = text
    }
    
    func setLabelTextColor(_ color: UIColor) {
        label.textColor = color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
