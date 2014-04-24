//
//  LoginInfo.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 10/10/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Controllers/TopAuditionsViewController.m"
//#import "RecordViewController.h"
//#import "SettingsTableViewController.h"
//#import "MyAuditionsViewController.h"
//#import "RecordViewController.h"
//#import "TopAuditionsViewController.h"
//#import "NewAuditionsViewController.h"


@interface LoginInfo : NSObject{
    
//    TopAuditionsViewController *pageContentTopAuditionsViewController ;
//    NewAuditionsViewController *pageContentNewAuditionsViewController;
//    RecordViewController *pageContentRecordViewController;
//    MyAuditionsViewController *pageContentMyAuditionsViewController;
//    SettingsTableViewController *pageContentSettingsViewController;
}

@property (strong , nonatomic) NSString* userId;
@property (strong , nonatomic) NSString* userFacebookId;
@property  (nonatomic, strong) NSMutableArray *topAuditionData;
@property  (nonatomic, strong) NSMutableArray *newAuditionData;
@property  (nonatomic, strong) NSMutableArray *myAuditionData;
@property  (nonatomic, strong) NSMutableArray *users;
@property (strong,nonatomic) NSMutableData *savedVideoData;
//@property TopAuditionsViewController *pageContentTopAuditionsViewController;
//@property NewAuditionsViewController *pageContentNewAuditionsViewController;
//@property  RecordViewController *pageContentRecordViewController;
//@property MyAuditionsViewController *pageContentMyAuditionsViewController;
//@property SettingsTableViewController *pageContentSettingsViewController;
+ (LoginInfo*) sharedInstance;
+ (void) create;
- (void) logout;

@end