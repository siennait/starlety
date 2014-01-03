//
//  LoginInfo.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 10/10/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import "LoginInfo.h"



@implementation LoginInfo

@synthesize userId;
@synthesize userFacebookId;
@synthesize auditionData;
@synthesize savedVideoData;
static LoginInfo *myInstance = nil;

+ (LoginInfo*) sharedInstance {
    if (myInstance == nil) {
        [self create];
    }
    return myInstance;
}
+ (void) create {
    myInstance = [[[self class] alloc] init];
    myInstance.userId = [[NSString alloc]init];
    myInstance.userFacebookId = [[NSString alloc]init];
    myInstance.savedVideoData = [[NSMutableData data] init];
    myInstance.auditionData = [[NSMutableArray alloc] init];

}
- (void) logout {
    [userId release];
    [userFacebookId release];
    [auditionData release];
    //[savedVideoData release];
    
    //userId = [[NSString alloc] init];
    //auditionData = [[NSMutableArray alloc] init];
    savedVideoData = [[NSMutableData alloc] init];
}
@end
