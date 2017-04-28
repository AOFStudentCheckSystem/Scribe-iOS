//
//  Event+CoreDataProperties.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventDescription: String?
    @NSManaged public var eventId: String?
    @NSManaged public var eventName: String?
    @NSManaged public var eventStatus: Int32
    @NSManaged public var eventTime: NSDate?
    @NSManaged public var isSubscribed: Bool

}
