//
//  SettingsViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 10/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfo.h"
#import "API.h"

@interface SettingsTableViewController : UIViewController


- (IBAction)Logout:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *Firstname;
@property (retain, nonatomic) IBOutlet UILabel *Lastname;
@property (retain, nonatomic) IBOutlet UIImageView *ProfileImage;
@property NSUInteger pageIndex;


@end
