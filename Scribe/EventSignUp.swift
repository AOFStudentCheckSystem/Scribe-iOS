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
    
    func isSignupAvailable() -> Bool {
        return signupSheets.count > 0
    }
    func refreshStatus(callback: @escaping (() -> Void) = {}) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let dict = try ScribeAPI.sharedInstance.listCurrentSignUps()
                self.composeSheetArray (dataDict: dict)
            } catch APICallError.NotAuthenticatedException {
                NSLog("Authentication Required for this API Access")
            } catch {
                NSLog("\(error)")
            }
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    
    func composeSheetArray(dataDict: NSDictionary) -> Void {
        signupSheets.removeAll()
        let jsonSheets: NSArray = dataDict.object(forKey: "signUps") as! NSArray
        jsonSheets.forEach { (it) in
            let jSheet = it as! NSDictionary
            let sheet = SignupSheet(id: (jSheet.value(forKey: "id") as! Int64), name: (jSheet.value(forKey: "name") as! String))
            
            let entries = jSheet.object(forKey: "entries") as! NSArray
            entries.forEach({ (entry) in
                let jEntry = (entry as! NSDictionary).object(forKey: "eventGroup") as! NSDictionary
                let eventGroup = EventGroup(id: (jEntry.object(forKey: "id") as! Int64), name: (jEntry.object(forKey: "name") as! String))
                let jEvents = jEntry.object(forKey: "events") as! NSArray
                jEvents.forEach({ (jEvent) in
                    let event = Event.find(by: ((jEvent as! NSDictionary).object(forKey: "eventId") as! String), in: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                    if (event != nil) {
                        eventGroup.events.append(event!)
                    }
                })
                sheet.groups.append(eventGroup)
            })
            signupSheets.append(sheet)
        }
        NotificationCenter.default.post(name: EventSignUp.signupSheetRefreshed, object: self)
    }
}
