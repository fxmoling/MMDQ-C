//
//  DTTodayViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 2017/8/13.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class DTTodayViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    let schedule = Schedule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CurrentPageChanged(notification:)),
                                               name: Notification.Name(rawValue: "CurrentPageChanged"),
                                               object: nil)
        
        pageControl.numberOfPages = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        
    }
    
    func CurrentPageChanged(notification: Notification) {
        let info = notification.userInfo as! [String : Any]
        let curPage = info["curPage"] as! Int
        let numPage = info["numPage"] as! Int
        let schedule = info["schedule"] as! Schedule
        
        pageControl.numberOfPages = numPage
        pageControl.currentPage = curPage
        print("current page has been changed (\(curPage))")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE (HH:mm"
        let bDate = formatter.string(from: schedule.beginTime as Date)
        formatter.dateFormat = "-HH:mm)"
        let eDate = formatter.string(from: schedule.endTime as Date)
        
        label1.text = schedule.title
        label2.text = schedule.site + " " + bDate + eDate
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
