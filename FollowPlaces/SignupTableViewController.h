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

   

//@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;



//<UIPickerViewDataSource,UIPickerViewDelegate>





//property array for one column UIPickerView Example
//@property (strong, nonatomic) NSArray *oneColumnList;
//@property (strong, nonatomic) NSArray *secondColumnList;



//- (IBAction)cancel:(id)sender;
//- (IBAction)done:(id)sender;
//- (IBAction)uitextfielddidstartediting:(id)sender;
//- (IBAction)donetoolbar:(id)sender;

- (IBAction)JoinClick:(UIBarButtonItem *)sender;

//@property (retain, nonatomic) IBOutlet UITableViewCell *FirstnameTextField;
//@property (retain, nonatomic) IBOutlet UIPickerView *thePickerView;
//@property (retain, nonatomic) IBOutlet UITextField *genderTextField;
//@property (retain, nonatomic) IBOutlet UIToolbar *toolbargenderpickerview;

//- (IBAction)textFieldReturn:(id)sender;
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
// [sender resignFirstResponder];