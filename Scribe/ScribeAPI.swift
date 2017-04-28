//
//  ScribeAPI.swift
//  Scribe
//
//  Created by Codetector on 2017/4/27.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import Just

class ScribeAPI {
    static let sharedInstance = ScribeAPI()
    private let rootURL: String = "https://api.aofactivities.com"
    
    func listAllEvents() -> NSArray {
        let rtn = NSMutableArray()
        let r = Just.get(rootURL.appending("/event/listall"))
        if (r.ok) {
            return (r.json as! NSDictionary).value(forKey: "content") as! NSArray
        }
        return rtn
    }
}
