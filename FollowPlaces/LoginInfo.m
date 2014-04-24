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
@synthesize topAuditionData;
@synthesize newAuditionData;
@synthesize myAuditionData;
@synthesize savedVideoData;
@synthesize users;
//static RecordViewController *pageContentRecordViewController;

//@synthesize pageContentTopAuditionsViewController;
//@synthesize pageContentNewAuditionsViewController;
//@synthesize pageContentRecordViewController;
//@synthesize pageContentMyAuditionsViewController;
//@synthesize pageContentSettingsViewController;
////@synthesize pageContentTopAuditionsViewController;
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
    myInstance.topAuditionData = [[NSMutableArray alloc] init];
    myInstance.newAuditionData = [[NSMutableArray alloc] init];
    myInstance.myAuditionData = [[NSMutableArray alloc] init];
    myInstance.users = [[NSMutableArray alloc] init];

}
- (void) logout {
    [userId release];
    [userFacebookId release];
    [topAuditionData release];
    [newAuditionData release];
    [myAuditionData release];
    [users release];
    //[savedVideoData release];
    
    //userId = [[NSString alloc] init];
    //auditionData = [[NSMutableArray alloc] init];
    savedVideoData = [[NSMutableData alloc] init];
}
@end
