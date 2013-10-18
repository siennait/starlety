//
//  SignupTableViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 07/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SignupTableViewController : UITableViewController
<UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (IBAction)JoinClick:(UIBarButtonItem *)sender;

@property (retain, nonatomic) IBOutlet UITextField *FirstNametextfield;
@property (retain, nonatomic) IBOutlet UITextField *LastNametextfield;
@property (retain, nonatomic) IBOutlet UITextField *Usernametextfield;
@property (retain, nonatomic) IBOutlet UITextField *Passwordtextfield;
@property (retain, nonatomic) IBOutlet UIToolbar *KeyboardToolbar;



- (IBAction)DoneToolbar:(UIBarButtonItem *)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;
@property (retain, nonatomic) IBOutlet UIImageView *ProfilePicture;


@end