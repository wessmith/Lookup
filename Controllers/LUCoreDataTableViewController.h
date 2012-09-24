//
//  LUCoreDataTableViewController.h
//  Lookup
//
//  Created by Wesley Smith on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)fetchData;

@end
