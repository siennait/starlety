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

+ (LoginInfo*) sharedInstance {
    static LoginInfo *myInstance = nil;
    if (myInstance == nil) {
        myInstance = [[[self class] alloc] init];
        myInstance.userId = [[NSString alloc]init];
    }
    return myInstance;
}

- (void) logout {
    [userId release];
    userId = [[NSString alloc] init];
}
@end
