//
//  DTScheduleDetailViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 2017/8/13.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit
import RealmSwift

class DTScheduleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var schedule: Schedule! = nil
    var curDate: Date { return Date() }
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(origin: CGPoint.zero,
                                              size: CGSize(width: self.view.frame.width, height: self.view.frame.height*0.95)))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        registerCells()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouched))
//        let backButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(backButtonTouched))
        self.navigationItem.rightBarButtonItem = editButton
//        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "schedule detail"
        
        let deletionButton = UIButton(type: .custom)
        deletionButton.frame = CGRect(x: 0,
                                      y: self.view.frame.height*0.95,
                                      width: self.view.frame.width,
                                      height: self.view.frame.height*0.05)
        deletionButton.addTarget(self, action: #selector(deleteButtonTouched), for: .touchUpInside)
        deletionButton.backgroundColor = .white
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: deletionButton.frame.size))
        deletionButton.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = "delete"
        titleLabel.textColor = .orange
        self.view.addSubview(deletionButton)
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont(descriptor: UIFontDescriptor(), size: 12)
    }
    
    fileprivate func registerCells() {
        tableView.register(UINib(nibName: "DTRightDetailCell", bundle: nil), forCellReuseIdentifier: "right detail")
        tableView.register(UINib(nibName: "SingleTextFieldCell", bundle: nil), forCellReuseIdentifier: "stf")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func editButtonTouched() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "add schedule") as! DTAddScheduleViewController
        _ = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = "alter schedule"
        
        vc.event_title = schedule.title
        vc.event_site = schedule.site
        vc.all_day = schedule.all_day
        vc.begin_time = schedule.beginTime
        vc.end_time = schedule.endTime
        vc.until_time = schedule.untilTime
        vc.repeationMode = schedule.repeationMode
        vc.noticeMode = schedule.noticeMode
        vc.remark = schedule.remark
        vc.scheduleTag = schedule.id
        // 直到此时，vc的viewDidLoad()才被调用
        vc.tableView.reloadData()
        
        self.navigationController?.present(vc.navigationController!, animated: true, completion: nil)
    }
    
    func deleteButtonTouched() {
        let id = schedule.id
        let realm = try! Realm()
        let result = realm.objects(Schedule.self).filter("createDate = %@", id)
        try! realm.write {
            for s in result {
                realm.delete(s)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "schedule deleted"),
                                                object: nil,
                                                userInfo: nil)
            }
        }
        self.tabBarController?.tabBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        //        case 0 : return 1 + (schedule != nil ? schedule.times.count : 0)
        case 0 : return 2
        case 1 : return 4
        case 2 : return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 44 }
        if indexPath.section == 1 { return 44 }
        if indexPath.section == 2 { return 200 }
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 { return "备注" }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let schedule = schedule {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "right detail") as! DTRightDetailCell
                if indexPath.row == 0 {
                    cell.titleLabel.text = schedule.title
                }
                else {
                    cell.titleLabel.text = schedule.site
                }
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "right detail") as! DTRightDetailCell
                let formatter = DateFormatter()
                formatter.locale = Locale.current
                
                if indexPath.row == 0 {
                    formatter.dateFormat = "YYYY年MM月dd日 HH:mm"
                    let dateString = formatter.string(from: schedule.beginTime)
                    cell.titleLabel.text = "开始"
                    cell.detailLabel.text = dateString
                }
                else if indexPath.row == 1 {
                    formatter.dateFormat = "HH:mm"
                    let dateString = formatter.string(from: schedule.endTime)
                    cell.titleLabel.text = "结束"
                    cell.detailLabel.text = dateString
                }
                else if indexPath.row == 2 {
                    cell.titleLabel.text = "重复"
                    switch schedule.repeationMode {
                    case .every_day : cell.detailLabel.text = "每天"
                    case .every_week: cell.detailLabel.text = "每周"
                    case .every_two_weeks: cell.detailLabel.text = "每两周"
                    case .never: cell.detailLabel.text = "永不"
                    case .every_month: cell.detailLabel.text = "每月"
                    }
                }
                else if indexPath.row == 3 {
                    cell.titleLabel.text = "提醒"
                    switch schedule.noticeMode {
                    case .on_time: cell.detailLabel.text = "实时"
                    case .five: cell.detailLabel.text = "五分钟前"
                    case .ten: cell.detailLabel.text = "十分钟前"
                    case .fifteen: cell.detailLabel.text = "十五分钟前"
                    case .thirty: cell.detailLabel.text = "三十分钟前"
                    case .never: cell.detailLabel.text = "从不"
                    case .hour: cell.detailLabel.text = "一小时前"
                    case .day: cell.detailLabel.text = "一天前"
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "stf") as! SingleTextFieldCell
                cell.textWindow.text = schedule.remark
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell()
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 { return 26 }
        return 18
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 2 { return 500 }
        return 0
    }

}
