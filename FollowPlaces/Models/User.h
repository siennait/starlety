//
//  User.h
//  Starlety
//
//  Created by Luchian Chivoiu on 15/02/2014.
//  Copyright (c) 2014 Luchian Chivoiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Icon.h"

@interface User : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *userFacebookId;
@property (nonatomic, strong) Icon *ProfileImage;
@end
