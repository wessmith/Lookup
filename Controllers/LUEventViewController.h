//
//  LUEventViewController.h
//  Lookup
//
//  Created by smith-work on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUCoreDataTableViewController.h"

@class Group;

@interface LUEventViewController : LUCoreDataTableViewController

@property (nonatomic, strong) Group *group;

@end
