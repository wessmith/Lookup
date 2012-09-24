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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableURLRequest = nil;
    
    if ([fetchRequest.entityName isEqualToString:@"Group"]) {
        mutableURLRequest = [self requestWithMethod:@"GET"
                                               path:@"groups"
                                         parameters:@{ @"member_id" : @"self", @"access_token" : self.credential.accessToken }];
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
    NSLog(@"Properties: %@", mutablePropertyValues);
    if ([entity.name isEqualToString:@"Group"]) {
        [mutablePropertyValues setValue:[representation valueForKey:@"id"] forKey:@"groupID"];
    }
    return mutablePropertyValues;
}

@end
