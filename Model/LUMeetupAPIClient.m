//
//  LUMeetupAPIClient.m
//  Lookup
//
//  Created by Wesley Smith on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "LUMeetupAPIClient.h"
#import "MUOAuth2Client.h"

static NSString *const kMeetupAPIBaseURLString = @"https://api.meetup.com/2/";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LUMeetupAPIClient

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (LUMeetupAPIClient *)sharedClient
{
    static LUMeetupAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kMeetupAPIBaseURLString]];
    });
    
    return _sharedClient;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AFIncrementalStore

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject
{
    //NSLog(@"Result: %@", [responseObject valueForKey:@"results"]);
    return [responseObject valueForKey:@"results"];
}

- (NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation
                                         ofEntity:(NSEntityDescription *)entity
                                     fromResponse:(NSHTTPURLResponse *)response
{
    if ([entity.name isEqualToString:@"Photo"]) {
        
        return [NSString stringWithFormat:@"%@", [representation valueForKey:@"photo_id"]];
        
    }
        
    return [super resourceIdentifierForRepresentation:representation ofEntity:entity fromResponse:response];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableURLRequest = nil;
    
    // Groups request ->
    if ([fetchRequest.entityName isEqualToString:@"Group"]) {
        
        NSDictionary *params = @{
            @"member_id" : @"self",
            @"access_token" : self.credential.accessToken
        };
        
        mutableURLRequest = [self requestWithMethod:@"GET" path:@"groups" parameters:params];
    }
    // Events request ->
    else if ([fetchRequest.entityName isEqualToString:@"Event"]) {
        
        // Extract the group ID from the predicate.
        NSComparisonPredicate *predicate = (NSComparisonPredicate *)fetchRequest.predicate;
        NSNumber *groupID = [predicate.rightExpression expressionValueWithObject:nil context:nil];        
        
        NSDictionary *params = @{
            @"group_id" : groupID,
            @"status" : @"past",
            @"fields" : @"photo_count",
            @"access_token" : self.credential.accessToken
        };
        
        mutableURLRequest = [self requestWithMethod:@"GET" path:@"events" parameters:params];
        
    }
    // Photos request ->
    else if ([fetchRequest.entityName isEqualToString:@"Photo"]) {
        
        // Extract the event ID from the predicate.
        NSComparisonPredicate *predicate = (NSComparisonPredicate *)fetchRequest.predicate;
        NSNumber *eventID = [predicate.rightExpression expressionValueWithObject:nil context:nil];
        NSLog(@"Event ID = %@", eventID);
        
        NSDictionary *params = @{
            @"event_id" : eventID,
            @"access_token" : self.credential.accessToken
        };
        
        mutableURLRequest = [self requestWithMethod:@"GET" path:@"photos" parameters:params];
    }
    
    return mutableURLRequest;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation
                                                                            ofEntity:entity
                                                                        fromResponse:response] mutableCopy];
    
    //NSLog(@"Properties: %@", representation);
    
    // Group representation ->
    if ([entity.name isEqualToString:@"Group"]) {
        
        // Group ID
        NSString *groupID = [NSString stringWithFormat:@"%@", [representation valueForKey:@"id"]];
        [mutablePropertyValues setValue:groupID forKey:@"groupID"];
        
        // Thumb link
        [mutablePropertyValues setValue:[representation valueForKeyPath:@"group_photo.thumb_link"] forKey:@"thumbLink"];
        
    }
    // Event representation ->
    else if ([entity.name isEqualToString:@"Event"]) {
    
        // Event ID
        NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKey:@"id"]];
        [mutablePropertyValues setValue:eventID forKey:@"eventID"];
        
        // Time
        NSNumber *time = [representation valueForKey:@"time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.longLongValue/1000];
        [mutablePropertyValues setValue:date forKey:@"time"];
        
        // Photo count
        [mutablePropertyValues setValue:[representation valueForKey:@"photo_count"] forKey:@"photoCount"];
    }
    // Photo representation ->
    else if ([entity.name isEqualToString:@"Photo"]) {
        
        // Photo ID
        NSString *photoID = [NSString stringWithFormat:@"%@", [representation valueForKey:@"photo_id"]];
        [mutablePropertyValues setValue:photoID forKey:@"photoID"];
        
        // Photo link
        [mutablePropertyValues setValue:[representation valueForKey:@"photo_link"] forKey:@"photoLink"];
    }
    NSLog(@"Properties: %@", mutablePropertyValues);
    
    return mutablePropertyValues;
}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    NSDictionary *rep = nil;
    if ([entity.name isEqualToString:@"Photo"]) {
        
        NSString *eventID = [NSString stringWithFormat:@"%@", [representation valueForKeyPath:@"photo_album.event_id"]];
        rep = @{ @"event" : @{@"id" : eventID } };
    } else {
        rep = representation;
    }
    return rep;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context {
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context {
    return NO;
}

@end
