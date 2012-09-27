//
//  LUEventViewController.m
//  Lookup
//
//  Created by smith-work on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUEventViewController.h"
#import "LUEventTableViewCell.h"
#import "LUPhotoViewController.h"
#import "Group.h"
#import "Event.h"

#define ROW_HEIGHT 70.f

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

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LUBackgroundTexture"]];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    LUEventTableViewCell *eventCell = (LUEventTableViewCell *)cell;
    
    eventCell.nameLabel.text = event.name;
    [eventCell setTime:event.time];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    LUPhotoViewController *controller = [[LUPhotoViewController alloc] init];
    [controller setValue:obj forKey:@"Event"];
    
    NSLog(@"Event = %@", obj);
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
