//
//  RestfulFunctions.swift
//  VTDT
//
//  Created by Ragan Walker on 10/23/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import Foundation
    
    
    func postData (url:String, params:Dictionary<String, AnyObject>) -> Bool {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var err: NSError?
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
       
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
//        }
        })
        return true
    }
    
    func getData (url: String) -> NSArray {
        
        var jsonResult:AnyObject
        var requestUrl = NSURL(string: url)!
//        var request:NSURLRequest = NSURLRequest(URL: url)
        var jsonError:NSError?
        
        let jsonData:NSData? = NSData(contentsOfURL: requestUrl, options:NSDataReadingOptions.DataReadingMapped, error: &jsonError)
        
        if let jsonDataFromDB = jsonData {

            //parse json into array
            
            jsonResult = NSJSONSerialization.JSONObjectWithData(jsonDataFromDB,
                options:NSJSONReadingOptions.MutableContainers, error: nil)!
            
            if let nsDictionaryObject = jsonResult as? NSDictionary {
                if (nsDictionaryObject.count == 0) {
                    //handle json error here
                    print ("error parsing json file \n")
                }
                else {
                    return [nsDictionaryObject] as NSArray;
                }
            }
            else if let nsArrayObject = jsonResult as? NSArray {
                if (nsArrayObject.count == 0) {
                    //handle json error here
                    print ("error parsing json file \n")
                }
                else {
                    return nsArrayObject as NSArray;
                }
            }

        }
        println("here")
        return NSArray()
        
    }