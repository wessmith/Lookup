//
//  LUEventViewController.m
//  Lookup
//
//  Created by smith-work on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUEventViewController.h"
#import "Group.h"

@interface LUEventViewController ()

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LUEventViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"group.groupID=%@", self.group.groupID];
    
    NSManagedObjectContext *context = [(id)[UIApplication sharedApplication].delegate managedObjectContext];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self fetchData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(fetchData)];
    [self setupFetchedResultsController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LUEventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [obj valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [obj valueForKey:@"time"]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate



@end
