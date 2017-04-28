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
//        ScribeAPI.sharedInstance.listAllEvents()
//        self.navigationController?.tabBarItem.= UIColor.white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = #colorLiteral(red: 0.3900208806, green: 0.5891898534, blue: 1, alpha: 1)
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func getNSManagedObjectContextView() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func refresh() {
        // Do your job, when done:
        CoreDataSyncorization.sharedCoreDataSyncorization.attemptDataSyncorization(getNSManagedObjectContextView()) { 
            self.refreshControl?.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.fetchedResultsController.sections?.count) ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.fetchedResultsController.sections?[section].numberOfObjects) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventItemCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventItemCell
        
        cell.updateCell(withEvent: self.fetchedResultsController.object(at: indexPath))
        
        return cell
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
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
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
