//
//  LUViewController.m
//  Lookup
//
//  Created by Wes on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUViewController.h"
#import "MUOAuth2Client.h"

////////////////////////////////////////////////////////////////////////////////
static NSString *const kClientID = @"ojtt0avlqe41hq4or07ovdforp";
static NSString *const kClientSecret = @"pcj2umuk3igeugcor9ppaqpv3o";
static NSString *const kRedirectURI = @"lookup://oauth2";

////////////////////////////////////////////////////////////////////////////////
NSString *CredentialSavePath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"OAuthCredential.cache"];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface LUViewController ()
@property (nonatomic, strong) MUOAuth2Credential *credential;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation LUViewController

#pragma mark - Getters -

////////////////////////////////////////////////////////////////////////////////
- (MUOAuth2Credential *)credential
{
    if (!_credential) {
        _credential = [NSKeyedUnarchiver unarchiveObjectWithFile:CredentialSavePath()];
    }
    return _credential;
}

#pragma mark - View Lifecycle -

////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.credential) {
        
        id loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LULoginView"];
        [self presentViewController:loginViewController animated:NO completion:NULL];
    }
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
