//
//  siennaAppDelegate.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 03/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "WelcomeViewController.h"
#import "MainTabBarController.h"

@interface siennaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WelcomeViewController *customLoginViewController;

@end
