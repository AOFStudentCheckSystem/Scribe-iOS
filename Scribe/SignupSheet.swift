//
//  SignupSheet.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation

class EventGroup {
    var groupName: String = ""
    var groupId: Int64 = 0
    var events = Array<Event>()
    
    init(id: Int64, name: String = "") {
        self.groupId = id
        self.groupName = name
    }
}

class SignupSheet {
    var sheetId: Int64
    var sheetName: String
    var groups = Array<EventGroup> ()

    init(id: Int64, name: String = "") {
        self.sheetId = id
        self.sheetName = name
    }
        
}
