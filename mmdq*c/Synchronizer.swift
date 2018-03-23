//
//  Synchronizer.swift
//  mmdq*c
//
//  Created by 丁汀 on 2018/3/11.
//  Copyright © 2018年 丁汀. All rights reserved.
//

import Foundation
import Alamofire

//class Synchronizer {
//    
//    private static var port = 8000
//    private static var url = "http://127.0.0.1:\(port)/)"
//    
//    static func getCoursesList(_ id: String) -> [Course] {
//        let courses = [Course]()
//        
//        Alamofire.request(url + id)
//            .validate(statusCode: 200...200)
//            .responseJSON { response in
//            
//            if let json = response.result.value {
//                let cours = json["data"]["courses"]
//                
//                let c = Course()
//                
//                courses.append(c)
//            }
//            
//        }
//        
//        return courses
//    }
//    
//}
