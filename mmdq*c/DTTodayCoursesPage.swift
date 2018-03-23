//
//  DTTodayCoursePage.swift
//  mmdq*c
//
//  Created by 丁汀 on 2017/8/9.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit
import GaugeKit

class DTTodayCoursesPage: UIViewController {
    
    @IBOutlet weak var gauge: Gauge!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var courseSiteLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var courseDetailButton: UIButton!
    @IBAction func courseDetailButton(_ sender: UIButton) {
        switch ScheduleType(rawValue: course!.type)! {
        case .course:
            let detailVC = DTCourseDetailViewController()
            detailVC.course = course as! Course
            detailVC.navigationItem.leftBarButtonItem?.title = "today"
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        case .schedule: fallthrough
        default:
            let detailVC = DTScheduleDetailViewController()
            detailVC.schedule = course
            detailVC.navigationItem.leftBarButtonItem?.title = "today"
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentPageChanged"),
                                        object: self,
                                        userInfo: ["curPage" : curPage,
                                                   "numPage" : numOfPages,
                                                   "schedule" : course ?? Schedule()])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            weak var weakSelf = self
            weakSelf!.refresh()
        }
//        timer.invalidate()
        refresh()
    }
    
    var course: Schedule?
    var showCourseDetail: (()->())? = nil
    var numOfPages = 0
    var curPage = 0
    var timer: Timer! = nil
    
    var curDate: Date {
        return Date()
    }
    
    func startWork() {
        timer.fire()
    }
    
    func stopWork() {
        timer.invalidate()
    }
    
    func refresh() {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH : mm"
        
        tipsLabel.text = ""
        countDownLabel.text = formatter.string(from: curDate)
        courseTitleLabel.text = ""
        courseSiteLabel.text = ""
        
        if let course = course {
            courseDetailButton.isHidden = false
            courseTitleLabel.text = course.title
            
            formatter.dateFormat = "EEEE (HH:mm"
            let bDate = formatter.string(from: course.beginTime as Date)
            formatter.dateFormat = "-HH:mm)"
            let eDate = formatter.string(from: course.endTime as Date)
            
            courseSiteLabel.text = course.site + " " + bDate + eDate
                        
            // MARK: -time issue (22hours seems)
            if course.beginTimeInt > curDate.timeIntervalSince1970 {
                tipsLabel.text = "距离开始"
                let totSec = course.beginTime.timeIntervalSinceNow
                if totSec >= 3600 {
                    let h = Int(totSec / 3600.0)
                    let m = Int(totSec / 60.0) - h * 60
                    countDownLabel.text = (h < 10 ? "0\(h)" : "\(h)") + " : " + (m < 10 ? "0\(m)" : "\(m)")
                }
                else {
                    let m = Int(totSec / 60.0)
                    let s = Int(totSec) - m * 60
                    countDownLabel.text = (m < 10 ? "0\(m)" : "\(m)") + " : " + (s < 10 ? "0\(s)" : "\(s)")
                }
                
                gauge.maxValue = 1
                let todayInt = Double(Int(curDate.timeIntervalSince1970) - Int(curDate.timeIntervalSince1970) % 86400)
                gauge.rate = CGFloat((course.beginTimeInt - todayInt) / (course.endTimeInt - todayInt))
            }
            else if course.endTimeInt > curDate.timeIntervalSince1970 {
                tipsLabel.text = "距离结束"
                let totSec = course.endTime.timeIntervalSinceNow
                if totSec >= 3600 {
                    let h = Int(totSec / 3600.0)
                    let m = Int(totSec / 60.0) - h * 60
                    countDownLabel.text = (h < 10 ? "0\(h)" : "\(h)") + " : " + (m < 10 ? "0\(m)" : "\(m)")
                }
                else {
                    let m = Int(totSec / 60.0)
                    let s = Int(totSec) - m * 60
                    countDownLabel.text = (m < 10 ? "0\(m)" : "\(m)") + " : " + (s < 10 ? "0\(s)" : "\(s)")
                }
                
                gauge.maxValue = 1
                let curInt = curDate.timeIntervalSince1970
                gauge.rate = CGFloat((curInt - course.beginTimeInt) / (course.endTimeInt - course.beginTimeInt))
            }
            
            if Int(course.beginTime.timeIntervalSinceNow) == 0 && course.endTime.timeIntervalSinceNow >= 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "schedule starts"),
                                                object: self,
                                                userInfo: ["schedule" : course])
            }
            else if Int(course.endTime.timeIntervalSinceNow) == 0 && course.endTime.timeIntervalSinceNow <= 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "schedule finishes"),
                                                object: self,
                                                userInfo: ["schedule" : course])
            }
        }
        else if course == nil {
//            tipsLabel.text = "去浪吧"
            let formatter = DateFormatter()
            formatter.dateFormat = "HH : mm"
            countDownLabel.text = formatter.string(from: Date())
            formatter.dateFormat = "YYYY年MM月dd日"
            courseSiteLabel.text = formatter.string(from: Date())
            courseDetailButton.isHidden = true
        }
    }
    
}
