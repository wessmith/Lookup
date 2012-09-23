//
//  LUViewController.m
//  Lookup
//
//  Created by Wes on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUViewController.h"
#import "LULoginViewController.h"
#import "MUOAuth2Client.h"
#import "MUOAuth2Credential.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface LUViewController () <LULoginViewControllerDelegate>
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
        
        MUOAuth2Client *client = [MUOAuth2Client sharedClient];
        
        _credential = [client credentialFromArchive:@"OAuth2Credential.cache"];
    }
    return _credential;
}

#pragma mark - View Lifecycle -

////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.credential) {
        
        LULoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LULoginView"];
        loginViewController.delegate = self;
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


#pragma mark - Login View Controller Delegate

- (void)loginViewController:(LULoginViewController *)sender didAuthenticate:(MUOAuth2Credential *)credential
{
    NSLog(@"\nCredential: \n%@\n", [credential description]);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
