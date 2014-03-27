//
//  LoginInfo.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 10/10/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginInfo : NSObject

@property (strong , nonatomic) NSString* userId;
@property (strong , nonatomic) NSString* userFacebookId;
@property  (nonatomic, strong) NSMutableArray *topAuditionData;
@property  (nonatomic, strong) NSMutableArray *newAuditionData;
@property  (nonatomic, strong) NSMutableArray *myAuditionData;
@property  (nonatomic, strong) NSMutableArray *users;
@property (strong,nonatomic) NSMutableData *savedVideoData;

+ (LoginInfo*) sharedInstance;
+ (void) create;
- (void) logout;

@end