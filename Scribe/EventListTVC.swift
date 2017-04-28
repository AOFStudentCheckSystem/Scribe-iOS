//
//  EventListTVC.swift
//  Scribe
//
//  Created by Codetector on 2017/4/17.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit
import LoremIpsum

class EventListTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 55
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barTintColor =  UIColor.colorWithRGB(color: 0x3d4351)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
//        self.navigationController?.tabBarItem.= UIColor.white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        self.refreshControl = UIRefreshControl.init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventItemCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventItemCell

        NSLog("%@", LoremIpsum.paragraphs(withNumber: 1))
        cell.eventNameLabel.text = LoremIpsum.name()
        cell.eventDescriptionLabel?.text = LoremIpsum.paragraphs(withNumber: 5)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
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
