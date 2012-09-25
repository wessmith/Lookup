//
//  Event.h
//  Lookup
//
//  Created by Wesley Smith on 9/25/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Photo;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
