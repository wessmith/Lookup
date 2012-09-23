//
//  Group.h
//  Lookup
//
//  Created by Wesley Smith on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSNumber * members;
@property (nonatomic, retain) NSSet *events;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
