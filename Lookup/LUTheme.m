//
//  LUTheme.m
//  Lookup
//
//  Created by Wes on 9/27/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUTheme.h"

@implementation LUTheme

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)themeNavigationBar:(UINavigationBar *)navigationBar
{
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"LUNavBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"LUNavBarBackgroundMini"] forBarMetrics:UIBarMetricsLandscapePhone];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)clearNavigationBarTheme:(UINavigationBar *)navigationBar
{
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)themeBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Nav Buttons.
    [barButtonItem setBackgroundImage:[[UIImage imageNamed:@"LUNavButton"] stretchableImageWithLeftCapWidth:8 topCapHeight:0]
                         forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)clearBarButtonItemTheme:(UIBarButtonItem *)barButtonItem
{
    [barButtonItem setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)themeBackBarButtonItem
{
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"LUNavBackButton"] stretchableImageWithLeftCapWidth:13 topCapHeight:0]
                                   forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)clearBackBarButtonItemTheme
{
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [barButton setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}



@end
