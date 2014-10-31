//
//  CustomInfix.swift
//  VTDT
//
//  Created by Ragan Walker on 10/31/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import Foundation

infix operator ~> { }

//func ~> <R> (backGroundClosure: () -> R, mainClosure: (result: R) -> () ) {
//    
//    dispatch_async(queue) {
//        let result = backGroundClosure()
//        dispatch_async(dispatch_get_main_queue(), mainClosure(result: result))
//    }
//}
//
//func execute(backGroundClosure: () -> NSArray, mainClosure: (result:NSArray) -> () ) {
//    
//    dispatch_async(queue) {
//        let result = backGroundClosure()
//        dispatch_async(dispatch_get_main_gueue(), mainClosure(result: result))
//        
//    }

//}

