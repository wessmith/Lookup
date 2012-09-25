//
//  Photo.h
//  Lookup
//
//  Created by Wesley Smith on 9/25/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSString * photoLink;
@property (nonatomic, retain) Event *event;

@end
