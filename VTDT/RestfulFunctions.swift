//
//  RestfulFunctions.swift
//  VTDT
//
//  Copyright (c) 2014 Sanchit Chadha and Ragan Walker. All rights reserved.
//

import Foundation


func sendData (url:String, params:Dictionary<String, AnyObject>, type:String) {
	let request = NSMutableURLRequest(URL: NSURL(string: url)!)
	
	request.HTTPMethod = type
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	request.addValue("application/json", forHTTPHeaderField: "Accept")
	do {
		request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
	}catch {
		request.HTTPBody = nil
	}
	
	NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
		response, data, error in
		
		do {
			try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
		} catch {
		}
	}
}

func deleteData (url:String, type:String) {
	let request = NSMutableURLRequest(URL: NSURL(string: url)!)
	
	request.HTTPMethod = type
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	request.addValue("application/json", forHTTPHeaderField: "Accept")
	//    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
	
	
	NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
		response, data, error in
		
		//        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
		do {
			try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
		} catch {
		}
	}
}



func getData (url: String) -> NSArray {
	
	//    var jsonResult:NSArray = NSArray()
	let requestUrl = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!)!
	
	let jsonData:NSData?
	do {
		jsonData = try NSData(contentsOfURL: requestUrl, options:NSDataReadingOptions.DataReadingMapped)
	} catch {
		jsonData = nil
	}
	
	if let jsonDataFromDB = jsonData {
		
		if (jsonDataFromDB.length == 0) {
			return NSArray()
		}
		
		let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonDataFromDB, options: NSJSONReadingOptions.MutableContainers)
		
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