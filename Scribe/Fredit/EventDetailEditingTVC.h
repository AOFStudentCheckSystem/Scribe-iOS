//
//  EventDetailEditingTVC.h
//  Fredit
//
//  Created by Codetector on 2017/4/14.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+CoreDataClass.h"

@interface EventDetailEditingTVC : UITableViewController

@property (strong, nonatomic, readonly) NSDate *eventDate;
@property (strong, nonatomic) Event* targetEvent;

@end
