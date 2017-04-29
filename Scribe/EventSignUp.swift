//
//  EventSignUp.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit

class EventSignUp {
    static let signupSheetRefreshed = Notification.Name("kSignupSheetRefreshed")
    
    
    static let sharedInstance = EventSignUp()
    
    private(set) var signupSheets = Array<SignupSheet>()
    
    private(set) var isSignupAvailiable: Bool = false
    
    func refreshStatus() {
        do {
            let dict = try ScribeAPI.sharedInstance.listCurrentSignUps()
            composeSheetArray (dataDict: dict)
        } catch APICallError.NotAuthenticatedException {
            NSLog("Authentication Required for this API Access")
        } catch {
            NSLog("\(error)")
        }
    }
    
    func composeSheetArray(dataDict: NSDictionary) -> Void {
        signupSheets.removeAll()
        let jsonSheets: NSArray = dataDict.object(forKey: "signUps") as! NSArray
    }
}
