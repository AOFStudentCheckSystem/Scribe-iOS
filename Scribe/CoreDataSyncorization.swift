//
//  CoreDataSyncorization.swift
//  Scribe
//
//  Created by Codetector on 2017/4/27.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import CoreData
import ReachabilitySwift

class CoreDataSyncorization {
    static let sharedCoreDataSyncorization = CoreDataSyncorization()
    private let reachability = Reachability()!
    
    private let updateLock = NSLock()
    
    private init() {
        reachability.whenReachable = { r in
            self.attemptDataSyncorization((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext, callback: nil)
        }
        updateLock.name = "CoredataSyncLock"
    }
    
    func attemptDataSyncorization(_ context : NSManagedObjectContext,
                                  pirorityLevel: DispatchQoS.QoSClass = DispatchQoS.QoSClass.background,
                                  callback: (() -> ())?) {
        DispatchQueue.global(qos: pirorityLevel).async {
            if (self.updateLock.lock(before: Date.init(timeIntervalSinceNow: 0.5))) {
                self.updateAllEvents(context: context)
                DispatchQueue.main.async {
                        callback?()
                }
                self.updateLock.unlock()
            }
        }
    }
    
    private func updateAllEvents(context: NSManagedObjectContext) -> Void {
        NSLog("Fetching latest events from server...")
        let allEventJsonArray = ScribeAPI.sharedInstance.listAllEvents()
        NSLog("Server responded with %i events", allEventJsonArray.count)
        let eventIds = NSMutableArray()
        context.performAndWait {
            for item in allEventJsonArray {
                let event: NSDictionary = item as! NSDictionary
                let eventId = event.object(forKey: "eventId") as! String
                eventIds.add(eventId)
                let eventObject = Event.fetchOrCreateWithEventId(eventId: eventId, context: context)
                if (eventObject?.eventId != eventId) {
                    eventObject?.eventId = eventId
                }
                if (eventObject?.eventName != (event.object(forKey: "eventName") as! String)) {
                    eventObject?.eventName = (event.object(forKey: "eventName") as! String)
                }
                if (eventObject?.eventDescription != (event.object(forKey: "eventDescription") as! String)) {
                    eventObject?.eventDescription = (event.object(forKey: "eventDescription") as! String)
                }
                let eventStatus = Int32(event["eventStatus"] as! Int)
                if (eventObject?.eventStatus != eventStatus) {
                    eventObject?.eventStatus = eventStatus
                }
            }
            let removedEventsFetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            removedEventsFetchRequest.predicate = NSPredicate.init(format: "NOT (eventId in %@)", argumentArray: [eventIds])
            do {
                let removeArray = try context.fetch(removedEventsFetchRequest)
                removeArray.forEach({ (evnt) in
                    context.delete(evnt)
                })
            } catch {
                NSLog("Failed to execute fetch request: \(removedEventsFetchRequest), \nERROR: \(error)")
            }
            do {
                try context.save()
            } catch {
                NSLog("Failed to save context: \(error)")
            }
        }
    }
}
