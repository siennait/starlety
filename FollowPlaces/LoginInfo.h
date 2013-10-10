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
    
+ (LoginInfo*) sharedInstance;
- (void) logout;
@end