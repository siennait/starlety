//
//  LoginViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 23/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController
- (IBAction)LoginClick:(UIBarButtonItem *)sender;

@property (retain, nonatomic) IBOutlet UITextField *EmailTextfield;
@property (retain, nonatomic) IBOutlet UITextField *PasswordTextfield;

- (IBAction)DoneToolbar:(UIBarButtonItem *)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *KeyboardToolbar;


@end