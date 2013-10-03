//
//  API.h
//  iReporter
//
//  Created by Fahim Farook on 9/6/12.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"

typedef void (^JSONResponseBlock)(NSMutableArray* json);
//changed it on 4 oct 2013 from NSDictionary to NS MutableArray

@interface API : AFHTTPClient

@property (strong, nonatomic) NSDictionary* user;

+(API*)sharedInstance;
//check whether there's an authorized user
-(BOOL)isAuthorized;
//send an API command to the server
-(void)commandWithParams:(NSMutableDictionary*)params  APIPath:(NSString*) ApiPath onCompletion:(JSONResponseBlock)completionBlock ;
-(void)getCommand:(NSMutableDictionary*)params  APIPath:(NSString*) ApiPath onCompletion:(JSONResponseBlock)completionBlock ;
-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb;

@end
