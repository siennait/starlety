//
//  SettingsViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 10/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController
@synthesize Firstname;
@synthesize Lastname;
@synthesize ProfileImage;

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
    [FBRequestConnection startForMeWithCompletionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error)
     {
         [LoginInfo sharedInstance].userFacebookId = [result objectForKey:@"id"];
         [self getUserFromDBAndProceed:result ];
         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", [result objectForKey:@"id"]]];
         NSData *data = [NSData dataWithContentsOfURL:url];
         ProfileImage.image = [[[UIImage alloc] initWithData:data] autorelease];
        

     }];

}


- (void)getUserFromDBAndProceed:(id)result
{
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"id"], @"userFacebookId", nil];
    
    
    [[API sharedInstance] getCommand:params  APIPath:@"/Api/Users"  onCompletion:^(NSDictionary *json)  {
        if ([json valueForKey:@"error" ]) {
            [self showMessage:[json valueForKey:@"error" ] withTitle:@""];
        } else {
            [LoginInfo sharedInstance].userId = [json valueForKey:@"ID"];
            Firstname.text = [json valueForKey:@"Firstname"];
            Lastname.text = [json valueForKey:@"Lastname"];
           
        }}];
    
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

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}



- (void)dealloc {
    [Firstname release];
    [Lastname release];
    [ProfileImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFirstname:nil];
    [self setLastname:nil];
    [self setProfileImage:nil];
    [super viewDidUnload];
}
@end
