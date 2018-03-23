//
//  DTNoticeMeViewControllerTableViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/22.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class DTNoticeMeViewController: UITableViewController {
    
    var mode: NoticeTimeMode {
        get {
            for i in 0 ..< 8 {
                let path = IndexPath(row: i, section: 0)
                if tableView.cellForRow(at: path)?.accessoryType == .checkmark { return noticeTimeModes[i] }
            }
            return .on_time
        }
        set {
            for i in 0 ..< 8 {
                let path = IndexPath(row: i, section: 0)
                switch noticeTimeModes[i] {
                case newValue: tableView.cellForRow(at: path)?.accessoryType = .checkmark
                default: tableView.cellForRow(at: path)?.accessoryType = .none
                }
            }
        }
    }
    
    var modeName: String {
        for i in 0 ..< 8 {
            let path = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: path)?.accessoryType == .checkmark { return modeNames[noticeTimeModes[i]]! }
        }
        return "实时"
    }
    
    fileprivate let noticeTimeModes = [NoticeTimeMode.never, .on_time, .five, .ten, .fifteen, .thirty, .hour, .day]
    fileprivate let modeNames       = [NoticeTimeMode.never :"永不",
                                   .on_time             :"实时",
                                   .five                :"5分钟前",
                                   .ten                 :"10分钟前",
                                   .fifteen             :"15分钟前",
                                   .thirty              :"30分钟前",
                                   .hour                :"1小时前",
                                   .day                 :"1天前"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MarkCell", bundle:nil), forCellReuseIdentifier: "mark")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

extension DTNoticeMeViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mark") as! MarkCell
        cell.textLabel?.text = modeNames[noticeTimeModes[indexPath.row]]
        if indexPath.row == 1 { cell.accessoryType = .checkmark }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for i in 0 ..< 8 {
            let path = IndexPath(row: i, section: 0)
            tableView.cellForRow(at: path)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        _ = navigationController?.popViewController(animated: true)
    }
    
}







