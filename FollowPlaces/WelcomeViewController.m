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
    //if (FBSession.activeSession.state == FBSessionStateOpen
     //   || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
     //   [self performSegueWithIdentifier: @"WelcomeSegue" sender: self];
        
        // If the session state is not any of the two "open" states when the button is clicked
    //}
     [super loadView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)LoginClick:(id)sender {
    [self showLoading];
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBRequestConnection startForMeWithCompletionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error)
         {
             [LoginInfo sharedInstance].userFacebookId = [result objectForKey:@"id"];
             [self getUserFromDBAndProceed:result ];
             
         }];
        
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
             
             [FBRequestConnection startForMeWithCompletionHandler:
              ^(FBRequestConnection *connection, id result, NSError *error)
              {
                  if([result objectForKey:@"id"]!=nil)
                  {
                      //[LoginInfo sharedInstance] = [[LoginInfo sharedInstance] new];
                      [LoginInfo create];
                      [LoginInfo sharedInstance].userFacebookId = [result objectForKey:@"id"];
                      [self registerUserToDB:result ];
                  }
                  
              }];
         }];
        
        
    }

}

- (IBAction)TermsServiceClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.starlety.com/Terms/"]];
}

- (IBAction)DataPolicyClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.starlety.com/Privacy/"]];
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)getUserFromDBAndProceed:(id)result
{
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"id"], @"userFacebookId", nil];
    
    
   
    
    
    [[API sharedInstance] getCommand:params  APIPath:@"/Api/Users"  onCompletion:^(NSDictionary *json)  {
        if ([json valueForKey:@"error" ]) {
              [self hideLoading];
            [self showMessage:[json valueForKey:@"error" ] withTitle:@""];
            
        } else {
            [LoginInfo sharedInstance].userId = [json valueForKey:@"ID"];
            [self hideLoading];
            [self performSegueWithIdentifier: @"WelcomeSegue" sender: self];
        }}];

}
-(void)registerUserToDB : (id)result
{
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"ID",[result objectForKey:@"first_name"], @"Firstname"
                                  ,[result objectForKey:@"last_name"], @"Lastname"
                                  ,[result objectForKey:@"email"], @"Email"
                                  ,@"", @"Password1"
                                  ,[result objectForKey:@"id"], @"UserFacebookId",nil];
    
    
    [[API sharedInstance] commandWithParams:params APIPath:(@"/Api/Users") onCompletion:^(NSDictionary *json) {
        
        if(![json isKindOfClass:[NSDictionary class]]||![json objectForKey:@"error"])
		{
            [self getUserFromDBAndProceed:result];
            

		} else {
            [self hideLoading];
			NSString* errorMsg = [json valueForKey:@"error"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
		}
        
    }];
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

-(void)showLoading{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}
-(void)hideLoading{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
@end
