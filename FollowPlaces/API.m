//
//  API.m
//  iReporter
//
//  Created by Fahim Farook on 9/6/12.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "API.h"

//the web location of the service
#define kAPIHost @"http://starlety.com:8080"
//#define kAPIHost @"https://starlety.com:4430"

#define kAPIPath @"/Api/Users"

@implementation API

@synthesize user;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(API*)sharedInstance {
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString: kAPIHost]];
    });
    
    return sharedInstance;
}

#pragma mark - init


-(API*)init {
    //call super init
    self = [super init];
    if (self != nil) {
        //initialize the object
        user = nil;
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

-(BOOL)isAuthorized {
    return [[user objectForKey:@"IdUser"] intValue]>0;
}

-(void)commandWithParams:(NSMutableDictionary*)params  APIPath:(NSString*) ApiPath onCompletion:(JSONResponseBlock)completionBlock {

    self.parameterEncoding=AFJSONParameterEncoding;//AFJSONParameterEncoding;
    [self postPath:ApiPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
  }

-(void)getCommand:(NSMutableDictionary*)params  APIPath:(NSString*) ApiPath onCompletion:(JSONResponseBlock)completionBlock {

    self.parameterEncoding=AFJSONParameterEncoding;
    [self getPath:ApiPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
       
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        completionBlock(json);
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
  
}

-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb {
    NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@%@.jpg", kAPIHost, kAPIPath, IdPhoto, (isThumb)?@"-thumb":@""];
    return [NSURL URLWithString:urlString];
}

@end
