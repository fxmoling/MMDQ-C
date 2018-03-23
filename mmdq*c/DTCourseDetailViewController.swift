//
//  DTScheduleDetailViewController.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/7/13.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import UIKit
import RealmSwift

class DTCourseDetailViewController: UITableViewController {
    
    var course: Course! = nil
    var curDate: Date { return Date() }
    
    fileprivate func registerCells() {
        tableView.register(UINib(nibName: "DTRightDetailCell", bundle: nil), forCellReuseIdentifier: "right detail")
        tableView.register(UINib(nibName: "DTDoubleRowsCell", bundle: nil), forCellReuseIdentifier: "double rows")
        tableView.register(UINib(nibName: "DTCourseInfoCell", bundle: nil), forCellReuseIdentifier: "course info")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - suitable cells
        registerCells()
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont(descriptor: UIFontDescriptor(), size: 12)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector(editButtonTouched))
        
        print("- course detail controller :: view did load. course: \(course)")
    }
    
    func editButtonTouched() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return 1 + (course != nil ? course.beginTimeInts.count : 0)
        case 1 : return 3
        case 2 : return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 52 }
        if indexPath.section == 1 {
            if indexPath.row == 2 { return 52 }
            return 44
        }
        if indexPath.section == 2 { return 200 }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 { return "备注" }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let course = course {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "course info") as! DTCourseInfoCell
                    cell.titleLabel.text = course.title
                    cell.leftDetailLabel.text = course.courseID
                    cell.rightDetailLabel.text = course.category
                    cell.selectionStyle = .none
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "double rows") as! DTDoubleRowsCell
                    cell.label1.text = "⚇ " + course.sites[indexPath.row - 1]
                    let formatter = DateFormatter()
                    let beginTime = course.beginTimes[indexPath.row - 1]
                    let endTime = course.endTimes[indexPath.row - 1]
                    formatter.locale = Locale.current
                    formatter.dateFormat = "EEE hh:mm"
                    cell.label2.text = "⚉ " + course.semesterString + formatter.string(from: beginTime)
                    formatter.dateFormat = "-hh:mm"
                    cell.label2.text = cell.label2.text! + formatter.string(from: endTime)
                    cell.selectionStyle = .none
                    return cell
                }
            }
            else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "right detail") as! DTRightDetailCell
                    cell.titleLabel.text = "教师"
                    cell.detailLabel.text = course.teacher
                    cell.selectionStyle = .none
                    return cell
                }
                else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "right detail") as! DTRightDetailCell
                    cell.titleLabel.text = "学分：" + String(course.credit)
                    cell.detailLabel.text = "成绩：" + "N/N"
                    cell.selectionStyle = .none
                    return cell
                }
                else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "double rows") as! DTDoubleRowsCell
                    cell.label1.text = "考试时间未知"
                    cell.label2.text = "考试地点未知"
                    cell.selectionStyle = .none
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "stf") as! SingleTextFieldCell
                cell.textWindow.text = course.remark
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell()
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 { return 36 }
        return 28
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
