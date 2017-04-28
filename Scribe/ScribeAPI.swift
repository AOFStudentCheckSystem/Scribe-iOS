//
//  ScribeAPI.swift
//  Scribe
//
//  Created by Codetector on 2017/4/27.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import Just

class ScribeNotification {
    static let AuthenticationSucceed = Notification.Name("AuthenticationSucceed")
    static let AuthenticationFailed = Notification.Name("AuthenticationFailed")
}

class ScribeAPI {
    
    static let sharedInstance = ScribeAPI()
    private let rootURL: String = "https://api.aofactivities.com"
    
    static func getCurrentUser() -> String {
        return UserDefaults.standard.string(forKey: "AuthorizedUser") ?? ""
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "Authorization")
        NotificationCenter.default.post(name: ScribeNotification.AuthenticationSucceed, object: nil)
    }
    
    func isAuthenticated() -> Bool {
        let auth = authorizationString()
        return auth != nil && (!(auth!.isEmpty))
    }
    
    private func authorizationString() -> String? {
        return UserDefaults.standard.string(forKey: "Authorization")
    }
    
    func currentUser() -> String? {
        return UserDefaults.standard.string(forKey: "currentUser")
    }
    
    func listAllEvents() -> NSArray {
        let rtn = NSMutableArray()
        let r = Just.get(rootURL.appending("/event/listall"))
        if (r.ok) {
            return (r.json as! NSDictionary).value(forKey: "content") as! NSArray
        }
        return rtn
    }
    
    func authenticate(username: String?, password: String?) -> Bool {
        if (username == nil || password == nil || username!.isEmpty || password!.isEmpty) {
            return false
        }
        let r = Just.post(rootURL.appending("/auth/auth"),
                  data: ["email":username!, "password": password!],
                  timeout: 5)
        NSLog("\(String(describing: r))")
        if r.ok {
            let dict = (r.json as! NSDictionary)
//            let stu = dict.value(forKeyPath: "user.student")
            let userEmail = dict.value(forKeyPath: "user.email")
            let token = dict.object(forKey: "token") as! String
            let ndefault = UserDefaults.standard
            if (userEmail != nil && userEmail is String) {
                ndefault.set(userEmail as! String, forKey: "currentUser")
            }
            ndefault.set(token, forKey: "Authorization")
            NotificationCenter.default.post(name: ScribeNotification.AuthenticationFailed, object: nil)
        } else {
            self.signOut()
        }
        UserDefaults.standard.synchronize()
        return r.ok
    }
}
