//
//  LoginViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 23/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UITableViewController<MBProgressHUDDelegate> {
    	//MBProgressHUD *HUD;
}
- (IBAction)LoginClick:(UIBarButtonItem *)sender;

//@property (retain, nonatomic) IBOutlet UIBarButtonItem *LogInButton;
@property (retain, nonatomic) IBOutlet UITextField *EmailTextfield;
@property (retain, nonatomic) IBOutlet UITextField *PasswordTextfield;
@property (nonatomic) NSString* userId;


- (IBAction)DoneToolbar:(UIBarButtonItem *)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *KeyboardToolbar;


@end
