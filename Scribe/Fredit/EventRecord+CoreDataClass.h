//
//  EventRecord+CoreDataClass.h
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Student;

NS_ASSUME_NONNULL_BEGIN

@interface EventRecord : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "EventRecord+CoreDataProperties.h"
