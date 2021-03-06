//
//  LUMeetupAPIClient.h
//  Lookup
//
//  Created by Wesley Smith on 9/22/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "AFRESTClient.h"
#import "AFIncrementalStore.h"

@class MUOAuth2Credential;

@interface LUMeetupAPIClient : AFRESTClient

@property (nonatomic, strong) MUOAuth2Credential *credential;

+ (LUMeetupAPIClient *)sharedClient;

@end
