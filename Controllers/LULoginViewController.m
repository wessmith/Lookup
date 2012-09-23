//
//  LULoginViewController.m
//  Lookup
//
//  Created by Wesley Smith on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LULoginViewController.h"
#import "MUOAuth2Client.h"

@interface LULoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LULoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup the login button style.
    UIEdgeInsets buttonImageInsets = UIEdgeInsetsMake(0, 67.f, 0, 20.f);
    UIImage *loginButtonImage = [[UIImage imageNamed:@"LULoginButton"] resizableImageWithCapInsets:buttonImageInsets];
    [self.loginButton setBackgroundImage:loginButtonImage forState:UIControlStateNormal];
    UIImage *loginButtonImageHighlighted = [[UIImage imageNamed:@"LULoginButtonHighlighted"] resizableImageWithCapInsets:buttonImageInsets];
    [self.loginButton setBackgroundImage:loginButtonImageHighlighted forState:UIControlStateHighlighted];
}

- (IBAction)loginButtonAction:(UIButton *)sender
{
    MUOAuth2Client *client = [MUOAuth2Client sharedClient];

    #error Enter you consumer details here:
    [client authorizeClientWithID:@""
                           secret:@""
                      redirectURI:@""
                          success:^(MUOAuth2Credential *credential) {
        
                              [client archiveCredential:credential withName:@"OAuth2Credential.cache"];
                              
                              if ([self.delegate respondsToSelector:@selector(loginViewController:didAuthenticate:)])
                                  [self.delegate loginViewController:self didAuthenticate:credential];
                              
    } failure:^(NSError *error) {
        
        // TODO: Tell the user that auth failed and they should try again.
        
    }];
}

@end
