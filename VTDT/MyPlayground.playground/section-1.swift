// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var today:NSDate = NSDate()
var dateFormatter:NSDateFormatter = NSDateFormatter()

dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
//"2014-10-30T10:19:02"
var timePosted:String = dateFormatter.stringFromDate(today)