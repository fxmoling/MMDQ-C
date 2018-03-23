//
//  DTScheduleViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/22.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit
import CVCalendar
import RealmSwift

// TODO: -其他时间的日程
class DTScheduleViewController: UIViewController {
    
    let addScheduleVC = DTAddScheduleViewController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var monthNumberLabel: UILabel!
    @IBOutlet weak var yearNumberLabel: UILabel!
    
    // 所有当前日期schedules，包括已经结束了的
//    var schedules = [DTSchedule]()
    var schedules = [Schedule]()
    var curDate = Date()
    
    var curCalendar: Calendar!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBAction func TodayButtonTouched(_ sender: UIBarButtonItem) {
        curDate = Date(timeIntervalSinceNow: 0)
        calendarView.toggleViewWithDate(curDate)
    }
    
    func updateData(notification: Notification) {
        print("ScheduleViewController Refreshed After Notification")
        updateData()
    }
    
    func updateData() {
        let realm = try! Realm()
        let st = (floor(curDate.timeIntervalSince1970 / 86400) + 1) * 86400
        let nd = (floor(curDate.timeIntervalSince1970 / 86400) + 2) * 86400
        let todayRange = [st, nd]
        print("st nd \(st) \(nd)")
        let result = realm.objects(Schedule.self).filter("beginTimeInt BETWEEN %@ OR endTimeInt BETWEEN %@ OR beginTimeInt < %@ AND endTimeInt > %@", todayRange, todayRange, st, nd)
        print("result: \(result)")
        schedules.removeAll()
        for s in result {
            print("s bt et: \(s.beginTime) \(s.endTime)")
//            schedules.append(DTSchedule(basesOn: s))
            schedules.append(s)
        }
        schedules.sort { s1, s2 in
            if s1.beginTimeInt < s2.beginTimeInt { return true }
            else if s1.beginTimeInt == s2.beginTimeInt { return s1.endTimeInt < s2.endTimeInt }
            return false
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        dayNumberLabel.text = formatter.string(from: curDate)
        formatter.dateFormat = "MM月"
        monthNumberLabel.text = formatter.string(from: curDate)
        formatter.dateFormat = "yyyy"
        yearNumberLabel.text = formatter.string(from: curDate)
        tableView.reloadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    fileprivate func RegisterCells() {
        tableView.register(UINib(nibName: "DTSingleScheduleCell", bundle: nil), forCellReuseIdentifier: "schedule")
        tableView.register(UINib(nibName: "DTSingleLabelCell", bundle: nil), forCellReuseIdentifier: "label")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RegisterCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.separatorStyle = .none
        
        calendarView.delegate = self
        menuView.delegate = self
        
        // 转到当前日期
        calendarView.toggleViewWithDate(Date())
        
        // Do any additional setup after loading the view.
        updateData()
        
        // schedule被修改（在编辑页面），以及创建和删除的监听
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData(notification:)),
                                               name: NSNotification.Name(rawValue: "schedule created"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData(notification:)),
                                               name: NSNotification.Name(rawValue: "schedule deleted"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData(notification:)),
                                               name: NSNotification.Name(rawValue: "schedule altered"),
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //更新日历frame
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DTScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count + 3 - (schedules.count == 0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        }
        if indexPath.row <= 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "label") as! DTSingleLabelCell
            cell.isUserInteractionEnabled = false
            if indexPath.row == 1 {
                cell.setLabelFont(UIFont.systemFont(ofSize: 14))
                cell.setLabelText("2017春学期第四周")
                return cell
            }
            else {
                if schedules.count == 0 { return UITableViewCell() }
                cell.setLabelFont(UIFont.systemFont(ofSize: 12))
                cell.setLabelText("日程")
                cell.setLabelTextColor(.gray)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule") as! DTSingleScheduleCell
        
        let s = schedules[indexPath.row - 3]
        cell.scheduleName.text = s.title
        cell.scheduleLocation.text = "⚇ " + s.site
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE (HH:mm"
        let bDate = formatter.string(from: s.beginTime as Date)
        formatter.dateFormat = "-HH:mm)"
        let eDate = formatter.string(from: s.endTime as Date)
        cell.scheduleTime.text = "⚉ " + bDate + eDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 25 }
        if indexPath.row == 1 { return 48 }
        if indexPath.row == 2 { return 24 }
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < 2 { return }
        let schedule = schedules[indexPath.row-3]
//        let realm = try! Realm()
        switch ScheduleType(rawValue: schedule.type)! {
        case .schedule:
            let detailVC = DTScheduleDetailViewController()
            detailVC.schedule = schedule
            navigationController!.pushViewController(detailVC, animated: true)
        case .course:
            let detailVC = DTCourseDetailViewController()
            detailVC.course = schedule as! Course
            navigationController!.pushViewController(detailVC, animated: true)
        default: break
        }
    }
}

extension DTScheduleViewController: CVCalendarViewDelegate, MenuViewDelegate {
    func presentationMode() -> CalendarMode {
        return CalendarMode.weekView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.sunday
    }
    
    // 是否在每个日期上显示分割线
//    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        return true
//    }
    
    // 滑动到新的一周时，是否自动切换到这周的第一天（若为本周则是今天）
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        curDate = dayView.date.convertedDate()!
        print("date: \(curDate)")
        updateData()
        self.tableView.reloadData()
    }
    
    // 每月第一天前留空白或是以灰色显示上一月的日期
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
}





















