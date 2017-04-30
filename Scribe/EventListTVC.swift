//
//  EventListTVC.swift
//  Scribe
//
//  Created by Codetector on 2017/4/17.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit
import CoreData
import LoremIpsum

class EventListTVC: UITableViewController, NSFetchedResultsControllerDelegate{

    private lazy var fetchedResultsController: NSFetchedResultsController<Event> = {
        let fetchRequest = NSFetchRequest<Event>.init(entityName: "Event")
        fetchRequest.predicate = NSPredicate.init(format: "(eventStatus < 2)")
        let eventTimeSort = NSSortDescriptor.init(key: "eventTime", ascending: false)
        let eventIdSort = NSSortDescriptor.init(key: "eventId", ascending: false)
        fetchRequest.sortDescriptors = [eventTimeSort, eventIdSort]
        return NSFetchedResultsController<Event>.init(fetchRequest: fetchRequest , managedObjectContext: self.getNSManagedObjectContextView(), sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    private var perviousSignupStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 55
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barTintColor =  UIColor.colorWithRGB(color: 0x3d4351)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        do {
            try self.fetchedResultsController.performFetch()
            self.fetchedResultsController.delegate = self
        } catch {
            NSLog("Failed to perform fetch \(error)")
        }
        EventSignUp.sharedInstance.refreshStatus()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = #colorLiteral(red: 0.3900208806, green: 0.5891898534, blue: 1, alpha: 1)
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(forName: EventSignUp.signupSheetRefreshed, object: nil, queue: OperationQueue.main) { (n) in
            if (EventSignUp.sharedInstance.isSignupAvailable() && (!self.perviousSignupStatus)) {
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            } else if (!EventSignUp.sharedInstance.isSignupAvailable() && self.perviousSignupStatus) {
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        }
    }
    
    private func getNSManagedObjectContextView() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func refresh() {
        // Do your job, when done:
        CoreDataSyncorization.sharedCoreDataSyncorization.attemptDataSyncorization(getNSManagedObjectContextView()) {
            EventSignUp.sharedInstance.refreshStatus {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ((self.fetchedResultsController.sections?.count) ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section != 0) {
            return (self.fetchedResultsController.sections?[section - 1].numberOfObjects) ?? 0
        }
        perviousSignupStatus = EventSignUp.sharedInstance.isSignupAvailable()
        return perviousSignupStatus ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section != 0){
            let cell: EventItemCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventItemCell
            cell.updateCell(withEvent: self.fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1) ))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "signUpStatusCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("SignUpsAreOpenNowClickHereToSignUp", comment: "")
//            cell.textLabel?.size
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex + 1), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex + 1), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1)], with: .fade)
        case .delete:
            tableView.deleteRows(at: [IndexPath(row: indexPath!.row, section: indexPath!.section + 1)], with: .fade)
        case .update:
            tableView.reloadRows(at: [IndexPath(row: indexPath!.row, section: indexPath!.section + 1)], with: .fade)
        case .move:
            tableView.moveRow(at: IndexPath(row: indexPath!.row, section: indexPath!.section + 1), to: IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
