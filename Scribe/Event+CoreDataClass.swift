//
//  Event+CoreDataClass.swift
//  Scribe
//
//  Created by Codetector on 2017/4/27.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {
    static func fetchOrCreateWithEventId(eventId: String, context: NSManagedObjectContext) -> Event?{
        let entityDescription = NSEntityDescription.entity(forEntityName: "Event", in: context)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init()
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate.init(format: "eventId = %@", argumentArray: [eventId])
        do {
            let result: NSArray = try context.fetch(fetchRequest) as NSArray
            if (result.count > 0) {
                return (result[0] as! Event)
            } else {
                NSLog("Creating new event for Id: %@", eventId)
                return (NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event)
            }
        } catch {
            NSLog("Failed to fetch, \(error)")
        }
        return nil
    }
    
    static func find(by eventId: String, in context: NSManagedObjectContext) -> Event?{
        let fetch: NSFetchRequest<Event> = Event.fetchRequest()
        var event: Event? = nil
        fetch.predicate = NSPredicate.init(format: "eventId = %@", argumentArray: [eventId])
        context.performAndWait {
            do {
                let result = try context.fetch(fetch)
                if (result.count > 0) {
                    event = result[0]
                }
            } catch {
                NSLog("Error executing fetch request \(error)")
            }
        }
        return event
    }
}
