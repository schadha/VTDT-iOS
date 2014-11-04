//
//  RestfulFunctions.swift
//  VTDT
//
//  Copyright (c) 2014 Sanchit Chadha and Ragan Walker. All rights reserved.
//

import Foundation


func sendData (url:String, params:Dictionary<String, AnyObject>, type:String) {
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    var err: NSError?
    
    request.HTTPMethod = type
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        
        if(err != nil) {
            
            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
        }
        else {
            
            if let parseJSON = json {
                var success = parseJSON["success"] as? Int
            }
            else {
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            }
        }
    })
}

func sendDataBool (url:String, params:Dictionary<String, AnyObject>, type:String) -> Bool {
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    var err: NSError?
    
    request.HTTPMethod = type
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        
        if(err != nil) {
            
            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            
        }
        else {
            
            if let parseJSON = json {
                var success = parseJSON["success"] as? Int
            }
            else {
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            }
            
        }
    })
    
    return true
}

func getData (url: String) -> NSArray {

    var jsonResult:NSArray = NSArray()
    var requestUrl = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    
    var jsonError:NSError?
    
    let jsonData:NSData? = NSData(contentsOfURL: requestUrl, options:NSDataReadingOptions.DataReadingMapped, error: &jsonError)
    
    if let jsonDataFromDB = jsonData {
        
        if (jsonDataFromDB.length == 0) {
            return NSArray()
        }
        
        let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(jsonDataFromDB, options: NSJSONReadingOptions.MutableContainers, error: nil)!
        
        if let nsDictionaryObject = jsonResult as? NSDictionary {
            if (nsDictionaryObject.count == 0) {
                return NSArray()
            }
            else {
                return [nsDictionaryObject] as NSArray;
            }
        }
        else if let nsArrayObject = jsonResult as? NSArray {
            if (nsArrayObject.count == 0) {
                return NSArray()
            }
            else {
                return nsArrayObject as NSArray;
            }
        }
        
    }
    return NSArray()
}