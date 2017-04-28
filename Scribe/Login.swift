//
//  LoginViewController.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit

class Login {
    static func launchLoginScreen(inViewController vc: UIViewController, onConfirm: @escaping ((Bool, String?, String?) -> Void)) {
        let ctrl = UIAlertController.init(title: NSLocalizedString("Login", comment: ""), message: NSLocalizedString("SignInToContinue", comment: ""), preferredStyle: .alert)
        
        ctrl.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
            onConfirm(false, nil, nil)
        }))
        ctrl.addAction(UIAlertAction.init(title: NSLocalizedString("Login", comment: ""), style: .default, handler: { (action) in
            onConfirm(true, ctrl.textFields![0].text, ctrl.textFields![1].text)
        }))
        
        ctrl.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("email", comment: "")
            textField.keyboardAppearance = .dark
            textField.keyboardType = .emailAddress
        }
        ctrl.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("password", comment: "")
            textField.isSecureTextEntry = true
            textField.keyboardType = .asciiCapable
            textField.keyboardAppearance = .dark
        }
        vc.present(ctrl, animated: true, completion: nil)
    }
    
    static func launchSignoutScreen(inViewController vc: UIViewController, onAction: @escaping ((Bool) -> Void)) {
        let ctrl = UIAlertController.init(title: NSLocalizedString("Sign Out?", comment: ""), message: NSLocalizedString("ClickSignOutToConfirm", comment: ""), preferredStyle: .alert)
        ctrl.addAction(UIAlertAction.init(title: NSLocalizedString("Sign Out", comment: ""), style: .destructive, handler: { (action) in
            onAction(true)
        }))
        ctrl.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
            onAction(false)
        }))
        vc.present(ctrl, animated: true, completion: nil)
    }
}
