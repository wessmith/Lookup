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
#import "LUGroupTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "LUTheme.h"

#define ROW_HEIGHT 70.f

static NSString *const kClientID = @"ojtt0avlqe41hq4or07ovdforp";

@interface LUGroupViewController () <LULoginViewControllerDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) MUOAuth2Credential *credential;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LUGroupViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
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
- (void)presentLoginViewAnimated:(BOOL)animated
{
    // Show the login view.
    LULoginViewController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"LULoginView"];
    controller.delegate = self;
    [self.navigationController presentViewController:controller animated:animated completion:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LUTheme themeNavigationBar:self.navigationController.navigationBar];
    [LUTheme themeBarButtonItem:self.navigationItem.leftBarButtonItem];
    [LUTheme themeBarButtonItem:self.navigationItem.rightBarButtonItem];
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
    
    MUOAuth2Client *client = [MUOAuth2Client sharedClient];
    
    // Attempt to unarchive an existing credential.
    self.credential = [client credentialWithClientID:kClientID];
    
    if (!self.credential) {
        
        [self presentLoginViewAnimated:NO];
        
    } else if (self.credential.isExpired) {
        
        // Refresh the credential.
        [client refreshCredential:self.credential success:^(MUOAuth2Credential *credential) {
            
            self.credential = credential;
            
            NSLog(@"\nRefreshed Credential: \n%@\n", [self.credential description]);
            
            [LUMeetupAPIClient sharedClient].credential = self.credential;
            
            [self fetchData];
            
        } failure:^(NSError *error) {
            
            NSLog(@"Authorization error -> %@", error);
        }];
        
    } else {
        
        [LUMeetupAPIClient sharedClient].credential = self.credential;
        
        [self fetchData];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)logOutAction:(UIBarButtonItem *)sender
{
    // Forget the credential.
    [[MUOAuth2Client sharedClient] forgetCredentialWithClientID:kClientID];
    
    [self presentLoginViewAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LUEventsSeque"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        id controller = segue.destinationViewController;
        [controller setGroup:obj];
    }
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
    
    [self fetchData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LUGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    LUGroupTableViewCell *groupCell = (LUGroupTableViewCell *)cell;
    groupCell.nameLabel.text = [obj valueForKey:@"name"];
    groupCell.locationLabel.text = [NSString stringWithFormat:@"%@, %@",
                                    [obj valueForKey:@"city"],
                                    [obj valueForKey:@"state"]];
    groupCell.numberOfMembersLabel.text = [NSString stringWithFormat:@"%@ members",
                                           [obj valueForKey:@"members"]];
    
    [groupCell.photoView setImageWithURL:[NSURL URLWithString:[obj valueForKey:@"thumbLink"]]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

@end
