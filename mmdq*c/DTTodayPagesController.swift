//
//  DTTodayViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/22.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit
import GaugeKit
import RealmSwift

class DTTodayPagesController: UIPageViewController {
    
    var courses = [Schedule]()
    var pages = [DTTodayCoursesPage]()
    
    var curDate: Date { return Date() }
    
    func refresh() {
        pages.removeAll()
        courses = getTodayCourses()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if courses.count > 0 {
            for i in 0..<courses.count {
                let vc = sb.instantiateViewController(withIdentifier: "courses page") as! DTTodayCoursesPage
                vc.course = courses[i]
                vc.curPage = i
                vc.numOfPages = courses.count
                pages.append(vc)
            }
            self.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        }
        else {
            let page = sb.instantiateViewController(withIdentifier: "courses page") as! DTTodayCoursesPage
            page.course = nil
            page.curPage = -1
            page.numOfPages = 0
            self.setViewControllers([page], direction: .forward, animated: false, completion: nil)
        }
        
        var scroll: UIScrollView? = nil
        for view in self.view.subviews {
            if view is UIScrollView {
                scroll = view as? UIScrollView
                break
            }
        }
        if pages.count <= 1 {
            scroll!.isScrollEnabled = false
        }
        else {
            scroll!.isScrollEnabled = true
        }
    }
    
    func refresh(notification: Notification) {
        print("TodayPagesController Refreshed After Notification")
        refresh()
    }

    // 暂时放在这，到时候改到登录的controller里
    fileprivate func setDefaultRealm(username: String) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(username).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    // 有关realm的读取操作
    fileprivate func getTodayCourses() -> [Schedule] {
        // Mark: -Change the Schedules here to Courses
        var courses: [Schedule] = []
        let realm = try! Realm()
        let st = curDate.timeIntervalSince1970
        let nd = (floor(curDate.timeIntervalSince1970 / 86400) + 1) * 86400
        let todayRange = [st, nd]
        
        let resultSchedules = realm.objects(Schedule.self).filter("endTimeInt BETWEEN %@", todayRange)
        for s in resultSchedules {
            if s.isInvalidated { print("it's mystery") }
            else { courses.append(s) }
        }
        
        let resultCourses = realm.objects(Course.self).filter("endTimeInt BETWEEN %@", todayRange)
        for c in resultCourses {
            courses.append(c)
        }
        
        courses.sort { s1, s2 in
            if s1.beginTimeInt < s2.beginTimeInt { return true }
            else if s1.beginTimeInt == s2.beginTimeInt { return s1.endTimeInt < s2.endTimeInt }
            return false
        }
        
        return courses
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultRealm(username: "dt")
        
        dataSource = self
        delegate = self
        
        refresh()
        
        if courses.count > 0 {
            self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh(notification:)),
                                               name: NSNotification.Name(rawValue: "schedule created"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh(notification:)),
                                               name: NSNotification.Name(rawValue: "schedule deleted"),
                                               object: nil)
        // 接收自己发出的消息，是不是一个愚蠢的设计？
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh(notification:)),
                                               name: NSNotification.Name(rawValue: "schedule finishes"),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DTTodayPagesController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before")
        if let vc = viewController as? DTTodayCoursesPage {
            if vc.curPage == -1 {
                print("-1 (b")
                return nil
            }
            if vc.curPage > 0 && vc.curPage < courses.count {
                return pages[vc.curPage-1]
            }
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("after")
        if let vc = viewController as? DTTodayCoursesPage {
            if vc.curPage == -1 {
                print("-1")
                return nil
            }
            if vc.curPage < courses.count-1 && vc.curPage >= 0 {
                return pages[vc.curPage+1]
            }
        }
        return nil
    }
    
}









