//
//  SettingsTableViewController.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        NotificationCenter.default.addObserver(forName: ScribeNotification.AuthenticationSucceed, object: nil, queue: OperationQueue.current) { (n) in
            self.reloadView()
        }
        
        NotificationCenter.default.addObserver(forName: ScribeNotification.AuthenticationFailed, object: nil, queue: OperationQueue.current) { (n) in
            self.reloadView()
        }
        
        self.setupData()
    }

    private func reloadView() {
        self.setupData()
        self.tableView.reloadData()
    }
    
    private func setupData() {
        usernameLabel.text = ScribeAPI.sharedInstance.currentUser() ?? "example@examle.com"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if (ScribeAPI.sharedInstance.isAuthenticated()) {
                    return 0
                }
            } else {
                if (!ScribeAPI.sharedInstance.isAuthenticated()) {
                    return 0
                } else {
                    return 80
                }
            }
        }
        return -1
    }
    
    private func handleAccountSectionActions (row: Int) {
        switch row {
        case 0:
            Login.launchLoginScreen(inViewController: self, onConfirm: { (isLogin, username, password) in
                if (isLogin) {
                    DispatchQueue.global(qos: .background).async {
                        if (!ScribeAPI.sharedInstance.authenticate(username: username!, password: password!)) {
                            let ctrl = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Failed to Authorize", comment: ""), preferredStyle: .alert)
                            ctrl.addAction(UIAlertAction.init(title: NSLocalizedString("Retry", comment: ""), style: .default, handler: { (action) in
                                DispatchQueue.main.async {
                                    self.handleAccountSectionActions(row: 0)
                                }
                            }))
                            ctrl.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                            DispatchQueue.main.async {
                                self.present(ctrl, animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            break
        case 1:
            Login.launchSignoutScreen(inViewController: self, onAction: { (result) in
                if (result) {
                    ScribeAPI.sharedInstance.signOut()
                }
            })
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            handleAccountSectionActions(row: indexPath.row)
            break
        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
