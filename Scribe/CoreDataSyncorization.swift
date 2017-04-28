//
//  CoreDataSyncorization.swift
//  Scribe
//
//  Created by Codetector on 2017/4/27.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSyncorization {
    static let sharedCoreDataSyncorization = CoreDataSyncorization()

    func updateAllEvents(context: NSManagedObjectContext) -> Void {
        context.performAndWait {
            
        }
    }
}
