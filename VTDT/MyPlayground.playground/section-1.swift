// Playground - noun: a place where people can play

import UIKit

//var today:NSDate = NSDate()
//"2014-10-30T10:19:02"

//var timeElement = "2014-10-30T10:19:02"

//var dateFormatter:NSDateFormatter = NSDateFormatter()
//dateFormatter.dateFormat = "HH:mm:ss"
//var timeArray:[String] = timeElement.componentsSeparatedByString("T")
//var time = dateFormatter.dateFromString(timeArray[1])
//dateFormatter.dateFormat = "h:mm a"
//var timePosted = dateFormatter.stringFromDate(time!)
//"at Sharkey's around \(timePosted)"

//var dateFormatter2:NSDateFormatter = NSDateFormatter()
//dateFormatter2.dateStyle = NSDateFormatterStyle.ShortStyle
//dateFormatter2.dateFormat = "YYYY-MM-DD HH:mma"
//timeArray[0]
//var date:NSDate = dateFormatter2.dateFromString(timeElement)!
//var date2 = dateFormatter2.stringFromDate(date)

var dateFormatter:NSDateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "E"
dateFormatter.shortWeekdaySymbols
let today:String = dateFormatter.stringFromDate(NSDate())