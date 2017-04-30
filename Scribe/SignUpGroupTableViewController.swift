//
//  SignUpGroupTableViewController.swift
//  Scribe
//
//  Created by Codetector on 2017/4/29.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit

class SignUpGroupTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Select the group you want to sign up.", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventSignUp.sharedInstance.signupSheets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventGroupOption", for: indexPath)
        cell.textLabel?.text = EventSignUp.sharedInstance.signupSheets[indexPath.row].sheetName
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender is UITableViewCell && segue.destination is SignUpTableViewController) {
            (segue.destination as! SignUpTableViewController).targetSheet = EventSignUp.sharedInstance.signupSheets[(self.tableView.indexPath(for: sender as! UITableViewCell)?.row)!]
        }
    }
 

}
