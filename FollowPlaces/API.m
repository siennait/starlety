//
//  API.m
//  iReporter
//
//  Created by Fahim Farook on 9/6/12.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "API.h"

//the web location of the service
#define kAPIHost @"http://86.124.72.174"
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

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock {
	NSData* uploadFile = nil;
//	if ([params objectForKey:@"file"]) {
//		uploadFile = (NSData*)[params objectForKey:@"file"];
//		[params removeObjectForKey:@"file"];
//	}
    self.parameterEncoding=AFJSONParameterEncoding;//AFJSONParameterEncoding;
    [self postPath:kAPIPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
   
 //   NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:kAPIPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {

        //		if (uploadFile) {
//            [formData appendPartWithFileData:uploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//		}
//	}];
//    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //success!
//        completionBlock(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //failure :(
//
//        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
//    }];
//    [operation start];
}

-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb {
    NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@%@.jpg", kAPIHost, kAPIPath, IdPhoto, (isThumb)?@"-thumb":@""];
    return [NSURL URLWithString:urlString];
}

@end
