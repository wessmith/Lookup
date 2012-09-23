//
//  LULoginViewController.h
//  Lookup
//
//  Created by Wesley Smith on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LULoginViewControllerDelegate;


@class MUOAuth2Credential;

@interface LULoginViewController : UIViewController

@property (nonatomic, weak) id <LULoginViewControllerDelegate> delegate;

@end


@protocol LULoginViewControllerDelegate <NSObject>

- (void)loginViewController:(LULoginViewController *)sender didAuthenticate:(MUOAuth2Credential *)credential;

@end
