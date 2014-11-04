//
//  DateTimeFunctions.swift
//  VTDT
//
//  Copyright (c) 2014 Sanchit Chadha and Ragan Walker. All rights reserved.
//

import Foundation
    
func isToday(date:String) -> String {
    
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    var yesterday:NSDate = dateFormatter.dateFromString(date)!
    
    var today = NSDate()
    
    let calendar = NSCalendar.currentCalendar()
    let todayComponents = calendar.components(.CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
    let yesterdayComponents = calendar.components(.CalendarUnitMonth | .CalendarUnitDay, fromDate: yesterday)

    if todayComponents.month <= yesterdayComponents.month && todayComponents.day <= yesterdayComponents.day {
        return "- today"
    }

    let daysAgo = calendar.components(.CalendarUnitDay, fromDate: yesterday, toDate: today, options: nil)
    let printDay = daysAgo.day == 1 ? "- \(daysAgo.day) day ago" : "- \(daysAgo.day) days ago"
    
    return printDay
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
