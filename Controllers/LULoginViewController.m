//
//  LULoginViewController.m
//  Lookup
//
//  Created by Wesley Smith on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LULoginViewController.h"

@interface LULoginViewController ()

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
