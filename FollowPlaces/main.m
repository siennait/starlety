//
//  main.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 03/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "siennaAppDelegate.h"
#import "NUISettings.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NUISettings setAutoUpdatePath:@"/NUI/NUIStyle.nss"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([siennaAppDelegate class]));
    }
}
