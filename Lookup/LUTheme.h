//
//  LUTheme.h
//  Lookup
//
//  Created by Wes on 9/27/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LUTheme : NSObject

+ (void)themeNavigationBar:(UINavigationBar *)navigationBar;
+ (void)clearNavigationBarTheme:(UINavigationBar *)navigationBar;

+ (void)themeBarButtonItem:(UIBarButtonItem *)barButtonItem;
+ (void)clearBarButtonItemTheme:(UIBarButtonItem *)barButtonItem;

+ (void)themeBackBarButtonItem;
+ (void)clearBackBarButtonItemTheme;

@end
