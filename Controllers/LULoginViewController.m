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
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LULoginViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: There must be a more elegant way to handle this.
    if ([UIScreen mainScreen].bounds.size.height == 568.f) {
        UIImage *bgImage = [UIImage imageNamed:@"LULoginBackground-568h@2x"];
        self.backgroundImageView.image = bgImage;
    }
        
    
    // Setup the login button style.
    UIEdgeInsets buttonImageInsets = UIEdgeInsetsMake(0, 67.f, 0, 20.f);
    UIImage *loginButtonImage = [[UIImage imageNamed:@"LULoginButton"] resizableImageWithCapInsets:buttonImageInsets];
    [self.loginButton setBackgroundImage:loginButtonImage forState:UIControlStateNormal];
    UIImage *loginButtonImageHighlighted = [[UIImage imageNamed:@"LULoginButtonHighlighted"] resizableImageWithCapInsets:buttonImageInsets];
    [self.loginButton setBackgroundImage:loginButtonImageHighlighted forState:UIControlStateHighlighted];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)loginButtonAction:(UIButton *)sender
{
    MUOAuth2Client *client = [MUOAuth2Client sharedClient];

    #error Enter you consumer details here:    
    [client authorizeClientWithID:@"<YOUR_KEY>"
                           secret:@"<YOUR_SECRET"
                      redirectURI:@"YOUR_REDIRECT_URI" success:^(MUOAuth2Credential *credential) {
        
                          NSLog(@"\nNew Credential: \n%@\n", [credential description]);
                          
                          if ([self.delegate respondsToSelector:@selector(loginViewController:didAuthenticate:)])
                              [self.delegate loginViewController:self didAuthenticate:credential];
                          
                        } failure:^(NSError *error) {
                            
                            // TODO: Tell the user that auth failed and they should try again.
                            NSLog(@"Authorization error -> %@", error);
                        }];
}

@end
