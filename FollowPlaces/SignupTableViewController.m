//
//  SignupTableViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 07/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import "SignupTableViewController.h"
#import "API.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"
#import "UIImage+Alpha.h"
#import "UIImagescaleandrotate.h"
#import "API.h"

//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
//#import "JSON.h"

@interface SignupTableViewController ()

@end

@implementation SignupTableViewController

//@synthesize thePickerView;
//@synthesize genderTextField;
//@synthesize toolbargenderpickerview;

@synthesize FirstNametextfield;
@synthesize LastNametextfield;
@synthesize Usernametextfield;
@synthesize Passwordtextfield;
@synthesize KeyboardToolbar;
@synthesize ProfilePicture;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    //thePickerView.showsSelectionIndicator = FALSE;
   // thePickerView.hidden=TRUE;
    //One column array example
//    self.oneColumnList=[[NSArray alloc] initWithObjects:@"Male",@"Female", nil];
//    
//    //Two column array example
////    self.secondColumnList=[[NSArray alloc] initWithObjects:@"Canada", @"United States",@"Mexico",@"England",@"France",@"Greece", @"Slovakia",@"Switzerland", nil];
//    
//    genderTextField.inputView=thePickerView;
//    genderTextField.inputAccessoryView=toolbargenderpickerview;
    //genderTextField.allowsEditingTextAttributes=NO;
    //genderTextField.delegate = self;
    /*
    UISwipeGestureRecognizer *swipeUP = [[UISwipeGestureRecognizer alloc] initWithTarget:(self) action:(@selector(screenWasSwiped))];
    swipeUP.numberOfTouchesRequired = 1;
    swipeUP.direction = UISwipeGestureRecognizerDirectionDown;
    swipeUP.cancelsTouchesInView=YES;
    [self.view addGestureRecognizer:swipeUP];
    */
    FirstNametextfield.inputAccessoryView=KeyboardToolbar;
    LastNametextfield.inputAccessoryView=KeyboardToolbar;
    Usernametextfield.inputAccessoryView=KeyboardToolbar;
    Passwordtextfield.inputAccessoryView=KeyboardToolbar;
//    for (id view in self.view.subviews) {
//        if ([view isKindOfClass:[UITextField class]]) {
//            [(UITextField *)view setInputAccessoryView:KeyboardToolbar];
//        }
//    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [ProfilePicture addGestureRecognizer:singleTap];
    [ProfilePicture setUserInteractionEnabled:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


//
//    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 264, 320, 216)];
//    UIPickerView *thePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,320,216)];
//    thePickerView.dataSource = self;
//    thePickerView.delegate = self;
//    [myView addSubview:thePickerView];
//    [self.view addSubview:myView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@", [gestureRecognizer view]);
    //[fldTitle resignFirstResponder];
	//show the app menu
	[[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Choose from library", nil]
	 showInView:self.view];
}


-(void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    
    [self presentModalViewController:imagePickerController animated:YES];
    

}

//- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *screenshotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
////    UIImage *scaledImage = [self scaleAndRotateImage:screenshotImage];
//    UIImage *scaledImage = [screenshotImage roundedCornerImage:3 borderSize:3];
//}

-(void)effects {
    //apply sepia filter - taken from the Beginning Core Image from iOS5 by Tutorials
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(ProfilePicture.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    ProfilePicture.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
}

-(void)uploadPhoto {
    //upload the image and the title to the web service
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", UIImageJPEGRepresentation(ProfilePicture.image,70), @"file", @"sienna", @"title", nil] onCompletion:^(NSDictionary *json) {
		//completion
		if (![json objectForKey:@"error"]) {
			//success
			[[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your photo is uploaded" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
			
		} else {
			//error, check for expired session and if so - authorize the user
			NSString* errorMsg = [json objectForKey:@"error"];
			[UIAlertView error:errorMsg];
			if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
				[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
			}
		}
	}];
}

-(void)logout {
	//logout the user from the server, and also upon success destroy the local authorization
	[[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"logout", @"command", nil] onCompletion:^(NSDictionary *json) {
        //logged out from server
        [API sharedInstance].user = nil;
        [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}];
}


-(void)choosefromlibrary {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
    
//    
//    self.imagePickerController.sourceType = sourceType;
//    
//    if (sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        // user wants to use the camera interface
//        //
//        self.imagePickerController.showsCameraControls = NO;
//        
//        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
//        {
//            // setup our custom overlay view for the camera
//            //
//            // ensure that our custom view's frame fits within the parent frame
//            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
//            CGRect newFrame = CGRectMake(0.0,
//                                         CGRectGetHeight(overlayViewFrame) -
//                                         self.view.frame.size.height - 10.0,
//                                         CGRectGetWidth(overlayViewFrame),
//                                         self.view.frame.size.height + 10.0);
//            self.view.frame = newFrame;
//            [self.imagePickerController.cameraOverlayView addSubview:self.view];
//        }
//    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
			break;
        case 1:
            [self choosefromlibrary];
			break;
            
//        case 1:
//            [self effects];
//			break;
//        case 2:
//            [self uploadPhoto];
//			break;
//        case 3:
//            [self logout];
//			break;
    }
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image20 = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImage *image3 = [image roundedCornerImage:0 borderSize:0];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *image = [image20 scaleAndRotateImage:picker.sourceType];
        
        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake( ProfilePicture.frame.size.width/2, ProfilePicture.frame.size.height * image.size.height/image.size.width) interpolationQuality:kCGInterpolationHigh];
        // Crop the image to a square (yikes, fancy!)
        UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width - ProfilePicture.frame.size.width)/2, (scaledImage.size.height -ProfilePicture.frame.size.height)/2, ProfilePicture.frame.size.width, ProfilePicture.frame.size.height)];
        // Show the photo on the screen
        
        
        UIImage *image2 = [scaledImage roundedCornerImage:7 borderSize:0];
        
        ProfilePicture.image = image2;

    }
    else
    {
        
        UIImage *scaledImage = [image20 resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake( ProfilePicture.frame.size.width/2, ProfilePicture.frame.size.height * image20.size.height/image20.size.width) interpolationQuality:kCGInterpolationHigh];
        
        UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width - ProfilePicture.frame.size.width)/2, (scaledImage.size.height -ProfilePicture.frame.size.height)/2, ProfilePicture.frame.size.width, ProfilePicture.frame.size.height)];
        
        
        
        UIImage *image2 = [scaledImage roundedCornerImage:7 borderSize:0];
        
        ProfilePicture.image = image2;
    }
    // Resize the image from the camera
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
#pragma mark - Table view data source



//
//- (IBAction)cancel:(id)sender
//{
//    //	[self.delegate playerDetailsViewControllerDidCancel:self];
//}
//- (IBAction)done:(id)sender
//{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert Title here"
//                                                   message: @"Alert Message here"
//                                                  delegate: self
//                                         cancelButtonTitle:@"Cancel"
//                                         otherButtonTitles:@"OK",nil];
//    
//    
//    [alert show];
//    [alert release];
//    
//
//    //	[self.delegate playerDetailsViewControllerDidSave:self];
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        // Any action can be performed here
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
//     */
//}

- (void)dealloc {
   // [_FirstnameTextField release];
   // [thePickerView release];
   // [genderTextField release];
//    [toolbargenderpickerview release];
//    [donetoolbar release];

    [FirstNametextfield release];
    [LastNametextfield release];
    [Usernametextfield release];
    [Passwordtextfield release];
    [KeyboardToolbar release];
    [ProfilePicture release];

    [super dealloc];
}
- (void)viewDidUnload {
    //[self setFirstnameTextField:nil];

    
//     [self setThePickerView:nil];
//     [self setGenderTextField:nil];
//
//    [self setToolbargenderpickerview:nil];
//    [self setDonetoolbar:nil];

    [self setFirstNametextfield:nil];
    [self setLastNametextfield:nil];
    [self setUsernametextfield:nil];
    [self setPasswordtextfield:nil];
    [self setKeyboardToolbar:nil];
    [self setProfilePicture:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

/*

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_oneColumnList count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // or 2 or more
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    //For one component (column)
    //return [oneColumnList objectAtIndex:row];
    
    //For mutiple columns
   
        return [_oneColumnList objectAtIndex:row];
        
    
    
    
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

        self.genderTextField.text=[_oneColumnList objectAtIndex:row];
        return;
    
    
}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
//    // Handle the selection
//}
//
//// tell the picker how many rows are available for a given component
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    NSUInteger numRows = 5;
//    
//    return numRows;
//}
//
//// tell the picker how many components it will have
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 1;
//}
//
//// tell the picker the title for a given component
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *title;
//    title = [@"" stringByAppendingFormat:@"%d",row];
//    
//    return title;
//}
//
//// tell the picker the width of each row for a given component
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    int sectionWidth = 300;
//    
//    return sectionWidth;
//}







- (IBAction)uitextfielddidstartediting:(id)sender {
//    thePickerView.hidden=NO;
    //toolbargenderpickerview.hidden=NO;
    [genderTextField resignFirstResponder];
   // [thePickerView setHidden:NO];
    
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    // Show UIPickerView
// //   [thePickerView setHidden:NO];
//    return NO;
//}

- (IBAction)donetoolbar:(id)sender {
//    [sender resignFirstResponder];
//     thePickerView.hidden=YES;
//     toolbargenderpickerview.hidden=YES;
        [thePickerView resignFirstResponder];
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textfield{
       // [textfield resignFirstResponder];
    if(textfield==self.FirstNametextfield)
    {
    [self.LastNametextfield becomeFirstResponder];
    }
    else
        if(textfield==self.LastNametextfield)
        {
            
            [self.Usernametextfield becomeFirstResponder];

        }
        else
            if(textfield==self.Usernametextfield)
            {
                
                [self.Passwordtextfield becomeFirstResponder];
                
            }
    else
    {
        
    
    }
    return YES;
}
/*
-(void)screenWasSwiped
{
    //[self.FirstNametextfield resignFirstResponder];
    if(self.FirstNametextfield){
        [self.FirstNametextfield resignFirstResponder];
        
        [self.LastNametextfield resignFirstResponder];
        [self.Usernametextfield resignFirstResponder];
        [self.Passwordtextfield resignFirstResponder];

    }
    else
        if(self.LastNametextfield){
            [self.LastNametextfield resignFirstResponder];
        }
        else
            if(self.Usernametextfield){
                [self.Usernametextfield resignFirstResponder];
            }
            else
                if(self.Passwordtextfield){
                    [self.Passwordtextfield resignFirstResponder];
                }
    NSLog(@"Swipped 2");
}
*/
//- (IBAction)SwipeDownAction:(UISwipeGestureRecognizer *)sender {
//    
//     NSLog(@"swipped");
//    
//   
//
//}
- (IBAction)DoneToolbar:(UIBarButtonItem *)sender {
    if ([self.FirstNametextfield isFirstResponder]) {

    [self.FirstNametextfield resignFirstResponder];
    }
    else
        if ([self.LastNametextfield isFirstResponder]) {
            
            [self.LastNametextfield resignFirstResponder];
            
        }
        else
            if ([self.Usernametextfield isFirstResponder]) {
                
                [self.Usernametextfield resignFirstResponder];
            }
            else
                if ([self.Passwordtextfield isFirstResponder]) {
                    
                    [self.Passwordtextfield resignFirstResponder];
                }
                

    
    
}

// This code handles the scrolling when tabbing through input fields
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 300;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;
CGFloat				 animatedDistance;


- (IBAction)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
  //  CGFloat numerator = midline ;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else
	{
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
 	[UIView commitAnimations];
}


- (IBAction)JoinClick:(UIBarButtonItem *)sender {
    
    
    
    
    
   
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"ID",[self.FirstNametextfield text], @"Firstname"
                                  ,[self.LastNametextfield text], @"Lastname"
                                  ,[self.Usernametextfield text], @"Email"
                                  ,[self.Passwordtextfield text], @"Password1",nil];
   
    [[API sharedInstance] commandWithParams:params APIPath:(@"/Api/Users") onCompletion:^(NSMutableArray *json) {
		
		if (![json objectForKey:@"error"]) {
			//success
			[[[UIAlertView alloc]initWithTitle:@"Success!" message:@"You have been registered! You can log in now." delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
			
		} else {
			
			NSString* errorMsg = [json objectForKey:@"error"];
			[UIAlertView error:errorMsg];
			if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
				[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
			}
		}
	} ];
    
    
}
@end
