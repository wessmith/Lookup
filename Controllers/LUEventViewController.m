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
#import "LUTheme.h"

#define ROW_HEIGHT 70.f
#define SECTION_HEADER_HEIGHT 30.f

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
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hasPhotos" ascending:NO],
                                    [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"group.groupID=%@", self.group.groupID];
    
    NSManagedObjectContext *context = [(id)[UIApplication sharedApplication].delegate managedObjectContext];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:@"hasPhotos"
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self fetchData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LUTheme themeNavigationBar:self.navigationController.navigationBar];
    [LUTheme themeBarButtonItem:self.navigationItem.rightBarButtonItem];
    [LUTheme themeBackBarButtonItem];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
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
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
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
    [controller setValue:obj forKey:@"event"];
    
    NSLog(@"Event = %@", obj);
    
    [self.navigationController pushViewController:controller animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, SECTION_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LUTableSectionHeader"]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 20, 4)];
    CGRect labelFrame = headerLabel.frame;
    labelFrame.origin.y = 2;
    headerLabel.frame = labelFrame;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.f];
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor darkGrayColor];
    headerLabel.shadowOffset = CGSizeMake(0,-1);
    
    // Figure out the correct title for the section.
    NSString *value = [[self.fetchedResultsController.sections objectAtIndex:section] name];
    if ([value isEqualToString:@"0"]) {
       headerLabel.text = @"Events without photos";
    } else {
       headerLabel.text = @"Events with photos"; 
    }
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

@end
