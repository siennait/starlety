//
//  WelcomeViewController.m
//  Starlety
//
//  Created by Luchian Chivoiu on 21/12/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>

#import "WelcomeViewController.h"
#import "siennaAppDelegate.h"
@implementation WelcomeViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}
- (void)loadView
{
    //UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    // add subviews
    //self.view = view;
    //[view release];
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        //[FBSession.activeSession closeAndClearTokenInformation];
        [self performSegueWithIdentifier: @"WelcomeSegue" sender: self];
        
        // If the session state is not any of the two "open" states when the button is clicked
    }
     [super loadView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction)LoginClick:(id)sender {
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"sienna" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    //[alert release];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        //[FBSession.activeSession closeAndClearTokenInformation];
        [self performSegueWithIdentifier: @"WelcomeSegue" sender: self];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             siennaAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             [self performSegueWithIdentifier: @"WelcomeSegue" sender: self];
             
             
         }];
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
- (void)dealloc {
    //[_LoginFacebookClick release];
    [super dealloc];
}
- (void)viewDidUnload {
   // [self setLoginFacebookClick:nil];
    [super viewDidUnload];
}

@end
