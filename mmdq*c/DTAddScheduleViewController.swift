//
//  ViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/19.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit
import RealmSwift

// TODO: 添加类型选择，(popover)
// TODO: 时间处理

class DTAddScheduleViewController: UITableViewController {
    
    var event_title: String {
        get { return title_field.text ?? "" }
        set { title_field.text = newValue }
    }
    var event_site: String {
        get { return site_field.text ?? "" }
        set { site_field.text = newValue }
    }
    
    var all_day       = false
    var begin_time    = Date()
    var end_time      = Date()
    var until_time    = Date()
    
    // 在alter schedule时，需要确定是哪一个schedule. 这是一个无奈之举
    var scheduleTag = 0.0
    
    var remark: String {
        get { return remarkView.text }
        set { remarkView.text = newValue }
    }
    
    var repeationModeName: String { return alterRepeationVC.modeName }
    var repeationMode: RepeationMode {
        get { return alterRepeationVC.mode }
        set { alterRepeationVC.mode = newValue }
    }
    
    var noticeMode: NoticeTimeMode {
        get { return noticeMeVC.mode }
        set { noticeMeVC.mode = newValue }
    }
    var noticeModeName: String { return noticeMeVC.modeName }
    
    fileprivate var begin_visible = false
    fileprivate var end_visible   = false
    fileprivate var until_visible = false
    fileprivate var begin_label   = UILabel()
    fileprivate var end_label     = UILabel()
    fileprivate var until_label   = UILabel()
    
    fileprivate var title_field   = UITextField()
    fileprivate var site_field    = UITextField()
    
    fileprivate var remarkView = UITextView()
    
    fileprivate let alterRepeationVC = DTAlterRepeationViewController()
    
    fileprivate let noticeMeVC = DTNoticeMeViewController()
    
    @IBAction func CancelBtnTouched(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneBtnTouched(_ sender: UIBarButtonItem) {
        let id = Date().timeIntervalSince1970
        
        if event_title != "" {
            let realm = try! Realm()
            
            // 当前schedule. 仅当在alter schedule时不为nil
            var staySchedule: Schedule? = nil
            
            // alter schedule时，将除此schedule以外全delete，并发出deleted通知
            // 但仅此schedule会被保留并做修改
            if self.navigationItem.title! != "add schedule" {
                let result = realm.objects(Schedule.self).filter("createDate = %@", scheduleTag)
                print("count : \(result.count)")
                try! realm.write {
                    for s in result {
                        if s.beginTime != begin_time {
                            realm.delete(s)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "schedule deleted"), object: self)
                        }
                        else {
                            staySchedule = s
                            print("stay schedule \(s.title)")
                        }
                    }
                }
            }
            var bt = begin_time
            var et = end_time
            
            var step = 60 * 60 * 24 * 10000 * 1.0 // 10000 years!
            switch repeationMode {
            case .every_day: step = 60 * 60 * 24 * 1.0
            case .every_week: step = 60 * 60 * 24 * 7 * 1.0
            case .every_two_weeks: step = 60 * 60 * 24 * 7 * 2 * 1.0
//            case .every_month: step = 60 * 60 * 24 * 30 * 1.0
            default: break
            }
            
            try! realm.write {
                print("new et: \(et), ut: \(until_time)")
                // 如果是alter schedule的情况，则更改这个schedule，并直接跳过
                if let schedule = staySchedule {
                    print("aha!")
                    schedule.id = id
                    schedule.type = ScheduleType.schedule.rawValue
                    schedule.beginTime = bt
                    schedule.endTime = et
                    schedule.untilTime = until_time
                    schedule.title = event_title
                    schedule.site = event_site
                    schedule.info = ""
                    schedule.remark = remark
                    schedule.repeationMode = repeationMode
                    schedule.noticeMode = noticeMode
                    
                    bt += step
                    et += step
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "schedule altered"),
                                                    object: self,
                                                    userInfo: ["schedule" : schedule])
                }
                repeat {
                    if et > until_time && staySchedule != nil { break }
                    let schedule = Schedule()
                    schedule.id = id
                    schedule.type = ScheduleType.schedule.rawValue
                    schedule.beginTime = bt
                    schedule.endTime = et
                    schedule.untilTime = until_time
                    schedule.title = event_title
                    schedule.site = event_site
                    schedule.info = ""
                    schedule.remark = remark
                    schedule.repeationMode = repeationMode
                    schedule.noticeMode = noticeMode
                    
                    realm.add(schedule)
                    
                    bt += step
                    et += step
                    
                    print("new data addition success: \(schedule.title)")
                    
                    NotificationCenter.default.post(
                        name: NSNotification.Name(rawValue: "schedule created"),
                        object: self,
                        userInfo: ["schedule" : schedule])
                } while et < until_time && repeationMode != .never
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = true
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont(descriptor: UIFontDescriptor(), size: 12)
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.title_field.addTarget(self, action: #selector(TitleUpdated(_:)), for: UIControlEvents.editingChanged)
        RegisterCells()
    }
    
    // var notice
    
    fileprivate func RegisterCells() {
        tableView.register(UINib(nibName: "SingleTextFieldCell", bundle:nil), forCellReuseIdentifier: "stf")
        tableView.register(UINib(nibName: "SwitchBarCell", bundle:nil), forCellReuseIdentifier: "sb")
        tableView.register(UINib(nibName: "ChooseTimeCell", bundle:nil), forCellReuseIdentifier: "ct")
        tableView.register(UINib(nibName: "GoToNextVCCell", bundle:nil), forCellReuseIdentifier: "gtnvc")
        tableView.register(UINib(nibName: "TextViewCell", bundle:nil), forCellReuseIdentifier: "tv")
        tableView.register(UINib(nibName: "StartDatePickCell", bundle:nil), forCellReuseIdentifier: "sdp")
        tableView.register(UINib(nibName: "EndDatePickCell", bundle:nil), forCellReuseIdentifier: "edp")
        tableView.register(UINib(nibName: "UntilDatePickCell", bundle:nil), forCellReuseIdentifier: "udp")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AllDaySwitchBarStateChanged() {
        self.all_day = !self.all_day
    }
    
    func GetString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    func GetDate(from s: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.date(from: s)!
    }
    
    // MARK: - because of the reuse of cell, begin_label and end_label share the same picker, which
    //         will cause some unexcepted changes, that will be repaired soon.
    func UpdateBeginTime(_ picker: UIDatePicker) {
        self.begin_label.text = GetString(from: picker.date)
        self.begin_time = GetDate(from: begin_label.text!)
    }
    
    func UpdateEndTime(_ picker: UIDatePicker) {
        self.end_label.text = GetString(from: picker.date)
        self.end_time = GetDate(from: end_label.text!)
    }
    
    func UpdateUntilTime(_ picker: UIDatePicker) {
        self.until_label.text = GetString(from: picker.date)
        self.until_time = Date(timeIntervalSince1970: GetDate(from: until_label.text!).timeIntervalSince1970 + 24 * 60 * 60)
    }
    
    func TitleUpdated(_ field: UITextField) {
        print("title field updated text: \(field.text ?? "nil")")
        if field.text != nil {
            navigationItem.rightBarButtonItem!.isEnabled = true
        }
    }
    
}

extension DTAddScheduleViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : (section == 1 ? 8 : 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "stf") as! SingleTextFieldCell
            if indexPath.row == 0 {
                if event_title == "" {
                    cell.textWindow.placeholder = "title"
                }
                else {
                    cell.textWindow.text = event_title
                }
                self.title_field = cell.textWindow
            }
            else {
                if event_site == "" {
                    cell.textWindow.placeholder = "site"
                }
                else {
                    cell.textWindow.text = event_site
                }
                self.site_field = cell.textWindow
            }
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sb") as! SwitchBarCell
                cell.textLabel?.text = "all-day"
                cell.switchBar.isOn = false
                cell.switchBar.addTarget(self, action: #selector(AllDaySwitchBarStateChanged), for: UIControlEvents.touchUpInside)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ct") as! ChooseTimeCell
                cell.textLabel?.text = "begin"; begin_label = cell.detailTextLabel!
                
                cell.detailTextLabel?.text = GetString(from: begin_time)
                return cell
            }
            else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ct") as! ChooseTimeCell
                cell.textLabel?.text = "end"; end_label = cell.detailTextLabel!
                cell.detailTextLabel?.text = GetString(from: end_time)
                return cell
            }
            else if indexPath.row == 2 {
                if begin_visible {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "sdp") as! StartDatePickCell
                    cell.picker.addTarget(self, action: #selector(UpdateBeginTime(_:)), for: UIControlEvents.valueChanged)
                    cell.picker.date = begin_time
                    return cell
                }
                else { return UITableViewCell() }
            }
            else if indexPath.row == 4 {
                if end_visible {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "edp") as! EndDatePickCell
                    cell.picker.addTarget(self, action: #selector(UpdateEndTime(_:)), for: UIControlEvents.valueChanged)
                    return cell
                }
                else { return UITableViewCell() }
            }
            else if indexPath.row == 6 {
                switch repeationMode {
                case .never: until_visible = false
                default:     until_visible = true
                }
                if until_visible {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "udp") as! UntilDatePickCell
                    cell.picker.addTarget(self, action: #selector(UpdateUntilTime(_:)), for: UIControlEvents.valueChanged)
                    cell.picker.date = end_time
                    return cell
                }
                else { return UITableViewCell() }
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "gtnvc") as! GoToNextVCCell
                if indexPath.row == 5 { cell.textLabel?.text = "重复"; cell.detailTextLabel?.text = repeationModeName }
                else { cell.textLabel?.text = "提醒"; cell.detailTextLabel?.text = noticeModeName }
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tv") as! TextViewCell
            self.remarkView = cell.textView
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 1 { end_visible = false; begin_visible = !begin_visible }
        else if indexPath.section == 1 && indexPath.row == 3 { begin_visible = false; end_visible = !end_visible }
        else {
            begin_visible = false; end_visible = false
            // MARK: -jump
            if indexPath.section == 1 && indexPath.row == 5 {
                navigationController?.pushViewController(alterRepeationVC, animated: true)
            }
            if indexPath.section == 1 && indexPath.row == 7 {
                navigationController?.pushViewController(noticeMeVC, animated: true)
            }
        }
        tableView.reloadRows(at: [IndexPath(row: 2, section: 1), IndexPath(row: 4, section: 1)], with: UITableViewRowAnimation.top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 { return 220 }
        if indexPath.section == 1 {
            if (indexPath.row == 2 && begin_visible) || (indexPath.row == 4 && end_visible)
                || (indexPath.row == 6 && until_visible) { return 216 }
            else if indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 { return 0 }
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 { return "备注" }
        return " "
    }
    
}











