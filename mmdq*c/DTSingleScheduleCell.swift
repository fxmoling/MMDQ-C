//
//  DTSingleScheduleCellTableViewCell.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/25.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class DTSingleScheduleCell: UITableViewCell {

    @IBOutlet weak var scheduleName: UILabel!
    @IBOutlet weak var scheduleLocation: UILabel!
    @IBOutlet weak var scheduleTime: UILabel!
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.move(to: CGPoint(x: 20, y: 0))
        ctx?.addLine(to: CGPoint(x: 20, y: self.frame.height))
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        ctx?.strokePath()
        
        ctx?.addArc(center: CGPoint(x: 20, y: 8+14), radius: 4, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        ctx?.setFillColor(UIColor(red: 246.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1).cgColor)
        ctx?.fillPath()
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
