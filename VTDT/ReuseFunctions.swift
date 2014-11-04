//
//  ReuseFunctions.swift
//  VTDT
//
//  Created by Ragan Walker on 11/3/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import Foundation
    
func isToday(date:String) -> Bool {
    
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    var yesterday = dateFormatter.dateFromString(date)!
    
    var today = NSDate()
    println(yesterday)
    if today.compare(yesterday) == NSComparisonResult.OrderedDescending {
        
        return true
        
    }
    return false
}

func getPostTimeAndLocation(timeElement:String, barLocation:String) -> String {
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    
    var timeArray:[String] = timeElement.componentsSeparatedByString("T")
    var time = dateFormatter.dateFromString(timeArray[1])
    
    dateFormatter.dateFormat = "h:mm a"
    var timePosted = dateFormatter.stringFromDate(time!)
    
    return "at \(barLocation) around \(timePosted)"
}
