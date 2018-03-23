//
//  DTCourseInfoCell.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/7/14.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class DTCourseInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftDetailLabel: UILabel!
    @IBOutlet weak var rightDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
