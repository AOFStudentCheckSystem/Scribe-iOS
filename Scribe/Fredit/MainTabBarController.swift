//
//  MainTabBarController.swift
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

import UIKit
import JDStatusBarNotification

class MainTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(n:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func networkStatusChanged(n: Notification) {
        if n.object is Reachability {
            NSLog("Reachable: %i", (n.object as! Reachability).currentReachabilityStatus().rawValue)
            if ((n.object as! Reachability).currentReachabilityStatus().rawValue == 0) {
                JDStatusBarNotification.show(withStatus: "Disconnected", dismissAfter: 3, styleName: JDStatusBarStyleWarning)
            } else {
                JDStatusBarNotification.show(withStatus: "Connectoed", dismissAfter: 3, styleName: JDStatusBarStyleSuccess)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
