//
//  Course.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/7/13.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import Foundation
import RealmSwift

enum Semester: Int {
    case other = 0
    case spring
    case summer
    case autumn
    case winter
    case summerShort
    case winterShort
}

class Course: Schedule {
    
    // 父类
//    dynamic var schedule: Schedule? = nil
    
    // 课程类型
    dynamic var category = ""
    
    // 开课学院
    dynamic var department = ""
    
    // 学期
    let semester: Array<Int> = [Semester.other.rawValue]
    
    // 课程号
    dynamic var courseID = ""
    
    // 教室名字
    dynamic var teacher = ""
    
    // 学分
    dynamic var credit = 0
    
    // 所有时间
    let beginTimeInts: Array<Double> = []
    let endTimeInts: Array<Double> = []
    
    // 所有地点(与时间一一对应) (在这里schedule中的site/time将失去意义)
    let sites: Array<String> = []
    
    var beginTimes: [Date] {
        return beginTimeInts.map {
            return Date(timeIntervalSince1970: $0)
        }
    }
    
    var endTimes: [Date] {
        return endTimeInts.map {
            return Date(timeIntervalSince1970: $0)
        }
    }
    
    var semesterString: String {
        var semesterStr = ""
        for sem in self.semester {
            switch Semester(rawValue: sem)! {
            case .spring: semesterStr += "春"
            case .summer: semesterStr += "夏"
            case .autumn: semesterStr += "秋"
            case .winter: semesterStr += "冬"
            case .summerShort: semesterStr += "夏短"
            case .winterShort: semesterStr += "冬短"
            default: semesterStr += "未知"
            }
        }
        return semesterStr
    }
    
    static func ==(op1: Course, op2: Course) -> Bool {
        return op1.courseID == op2.courseID
    }
    
    override class func ignoredProperties() -> [String] {
        return ["beginTimes", "endTimes", "semesterString"]
    }
    
}






