//
//  Schedule.swift
//  mmdq*c
//
//  Created by 丁汀 on 17/7/9.
//  Copyright © 2017年 丁汀. All rights reserved.
//

import Foundation
import RealmSwift

enum ScheduleType: Int {
    case course     = 0
    case exam       = 1
    case schedule   = 2
    case activity   = 3
}

enum RepeationMode: Int {
    case never = 0, every_day, every_week, every_two_weeks, every_month
}

enum NoticeTimeMode: Int {
    case never = 0, on_time, five, ten, fifteen, thirty, hour, day
}

class Schedule: Object {
    
    // 唯一id，方便统一管理（删除）
    dynamic var createDate = 0.0
    
    dynamic var type = 0
    
    dynamic var beginTimeInt = 0.0
    
    dynamic var endTimeInt = 0.0
    
    dynamic var untilTimeInt = 0.0
    
    dynamic var title = ""
    
    dynamic var site = ""
    
    dynamic var info = ""
    
    dynamic var remark = ""
    
    dynamic var all_day = false
    
    dynamic var repeation = 0
    
    dynamic var notice = 0
    
    var beginTime: Date {
        get { return Date(timeIntervalSince1970: beginTimeInt) }
        set { beginTimeInt = newValue.timeIntervalSince1970 }
    }
    
    var endTime: Date {
        get { return Date(timeIntervalSince1970: endTimeInt) }
        set { endTimeInt = newValue.timeIntervalSince1970 }
    }
    
    var untilTime: Date {
        get { return Date(timeIntervalSince1970: untilTimeInt) }
        set { untilTimeInt = newValue.timeIntervalSince1970 }
    }
    
    var id: Double {
        get { return createDate }
        set { createDate = newValue }
    }
    
    var repeationMode: RepeationMode {
        get { return RepeationMode(rawValue: repeation)! }
        set { repeation = newValue.rawValue }
    }
    
    var noticeMode: NoticeTimeMode {
        get { return NoticeTimeMode(rawValue: notice)! }
        set { notice = newValue.rawValue }
    }
    
    override class func ignoredProperties() -> [String] {
        return ["beginTime", "endTime", "untilTime", "id", "repeationMode", "noticeMode"]
    }
    
}
