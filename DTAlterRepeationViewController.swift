//
//  AlterRepeationViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/3/19.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit

class DTAlterRepeationViewController: UITableViewController {

    var mode: RepeationMode {
        get {
            for i in 0 ..< 5 {
                let path = IndexPath(row: i, section: 0)
                if tableView.cellForRow(at: path)?.accessoryType == .checkmark { return mode_types[i] }
            }
            return .never
        }
        set {
            for i in 0 ..< 5 {
                let path = IndexPath(row: i, section: 0)
                switch mode_types[i] {
                case newValue: tableView.cellForRow(at: path)?.accessoryType = .checkmark
                default: tableView.cellForRow(at: path)?.accessoryType = .none
                }
            }
        }
    }
    fileprivate let mode_types = [RepeationMode.never, .every_day, .every_week, .every_two_weeks, .every_month]
    fileprivate let mode_names = [RepeationMode.never   :"永不",
                                  .every_day            :"每天",
                                  .every_week           :"每周",
                                  .every_two_weeks      :"每两周",
                                  .every_month          :"每月"]
    
    var modeName: String {
        for i in 0 ..< 5 {
            let path = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: path)?.accessoryType == .checkmark { return mode_names[mode_types[i]]! }
        }
        return "永不"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MarkCell", bundle:nil), forCellReuseIdentifier: "mark")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension DTAlterRepeationViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mark") as! MarkCell
        cell.textLabel?.text = mode_names[mode_types[indexPath.row]]
        if indexPath.row == 0 { cell.accessoryType = .checkmark }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for i in 0 ..< 5 {
            let path = IndexPath(row: i, section: 0)
            tableView.cellForRow(at: path)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        _ = navigationController?.popViewController(animated: true)
    }
    
}
