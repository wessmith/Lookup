//
//  LUPhotoViewController.h
//  Lookup
//
//  Created by Wesley Smith on 9/25/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "NIToolbarPhotoViewController.h"

@class Event;

@interface LUPhotoViewController : NIToolbarPhotoViewController

@property (nonatomic, strong) Event *event;

@end
