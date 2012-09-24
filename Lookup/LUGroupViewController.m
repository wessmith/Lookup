//
//  LUGroupViewController.m
//  Lookup
//
//  Created by Wesley Smith on 9/23/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUGroupViewController.h"
#import "MUOAuth2Client.h"
#import "LULoginViewController.h"
#import "LUMeetupAPIClient.h"

@interface LUGroupViewController () <LULoginViewControllerDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) MUOAuth2Credential *credential;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LUGroupViewController

- (void)fetchData
{
    [self.fetchedResultsController performSelectorOnMainThread:@selector(performFetch:) withObject:nil waitUntilDone:YES modes:@[NSRunLoopCommonModes]];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSManagedObjectContext *context = [(id)[UIApplication sharedApplication].delegate managedObjectContext];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchData)];
    
    [self setupFetchedResultsController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MUOAuth2Client *client = [MUOAuth2Client sharedClient];
    
    // Attempt to unarchive an existing credential.
    self.credential = [client credentialWithClientID:@"ojtt0avlqe41hq4or07ovdforp"];
    
    if (!self.credential) {
        
        // Show the login view.
        LULoginViewController *controller =
        [self.storyboard instantiateViewControllerWithIdentifier:@"LULoginView"];
        controller.delegate = self;
        [self presentViewController:controller animated:NO completion:NULL];
        
    } else if (self.credential.isExpired) {
        
        // Refresh the credential.
        [client refreshCredential:self.credential success:^(MUOAuth2Credential *credential) {
            
            NSLog(@"\nRefreshed Credential: \n%@\n", [credential description]);
            
        } failure:^(NSError *error) {
            
            NSLog(@"Authorization error -> %@", error);
        }];
        
    } else {
        
        [LUMeetupAPIClient sharedClient].credential = self.credential;
        
        [self fetchData];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Login View Controller Delegate -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginViewController:(LULoginViewController *)sender
            didAuthenticate:(MUOAuth2Credential *)credential
{
    NSLog(@"\nCredential: \n%@\n", [credential description]);
    
    [LUMeetupAPIClient sharedClient].credential = credential;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LUGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [obj valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [obj valueForKey:@"city"], [obj valueForKey:@"state"]];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Fetched Results Controller Delegate -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
