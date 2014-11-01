//
//  RestfulHandler.swift
//  VTDT
//
//  Created by Ragan Walker on 10/21/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class RestfulHandler: NSObject {
    
    typealias RegularCompletionHandler = (String, NSError) -> ()
    typealias DictionaryCompletionHandler = NSDictionary -> ()
    
    
    func requestToPath(path:String, completionHandler:RegularCompletionHandler) -> Void {
        
        var request:NSURLRequest = NSURLRequest(URL: NSURL(string:path))
        
         NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var result:NSString = NSString(data: data, encoding: UInt())
//            if (completionHandler) {
                completionHandler(result, error)
//            }
            
         })
    }
    
    func parseJSON(result:NSString) -> AnyObject {
        
        var data:NSData = result.dataUsingEncoding(NSUTF8StringEncoding)!
        return NSJSONSerialization.JSONObjectWithData(data,
            options:NSJSONReadingOptions.MutableContainers, error: nil)!
        
    }
   
}
