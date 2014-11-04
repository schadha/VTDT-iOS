// Playground - noun: a place where people can play

import Cocoa

var date = "2014-11-02T19:09:20"
var dateFormatter:NSDateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
var yesterday:NSDate = dateFormatter.dateFromString(date)!

var today = NSDate()

let calendar = NSCalendar.currentCalendar()
let todayComponents = calendar.components(.CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
let yesterdayComponents = calendar.components(.CalendarUnitMonth | .CalendarUnitDay, fromDate: yesterday)
println(yesterdayComponents.month)
println(yesterdayComponents.day)
println(todayComponents.month)
println(todayComponents.day)
//    if todayComponents.month > yesterdayComponents.month {
//
//        return true
//
//    }
if todayComponents.month <= yesterdayComponents.month && todayComponents.day <= yesterdayComponents.day {
    "true"
}

//"false"
