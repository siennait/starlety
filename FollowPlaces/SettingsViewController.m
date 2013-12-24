//
//  SettingsViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 10/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Logout:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Log Out?"
                                                   message: nil
                                                  delegate: self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    [alert release];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [[LoginInfo sharedInstance] logout];
        [self performSegueWithIdentifier: @"SettingsLogout" sender: self];
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
    }
}


@end
