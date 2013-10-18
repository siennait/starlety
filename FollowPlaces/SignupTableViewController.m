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


@interface SignupTableViewController ()

@end

@implementation SignupTableViewController


@synthesize FirstNametextfield;
@synthesize LastNametextfield;
@synthesize Usernametextfield;
@synthesize Passwordtextfield;
@synthesize KeyboardToolbar;
@synthesize ProfilePicture;


- (void)viewDidLoad
{

    FirstNametextfield.inputAccessoryView=KeyboardToolbar;
    LastNametextfield.inputAccessoryView=KeyboardToolbar;
    Usernametextfield.inputAccessoryView=KeyboardToolbar;
    Passwordtextfield.inputAccessoryView=KeyboardToolbar;

    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [ProfilePicture addGestureRecognizer:singleTap];
    [ProfilePicture setUserInteractionEnabled:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@", [gestureRecognizer view]);
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
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
			break;
        case 1:
            [self choosefromlibrary];
			break;
    }
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image20 = [info objectForKey:UIImagePickerControllerOriginalImage];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
#pragma mark - Table view data source


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

#pragma mark - Table view delegate


- (void)dealloc {
    [FirstNametextfield release];
    [LastNametextfield release];
    [Usernametextfield release];
    [Passwordtextfield release];
    [KeyboardToolbar release];
    [ProfilePicture release];

    [super dealloc];
}
- (void)viewDidUnload {
    [self setFirstNametextfield:nil];
    [self setLastNametextfield:nil];
    [self setUsernametextfield:nil];
    [self setPasswordtextfield:nil];
    [self setKeyboardToolbar:nil];
    [self setProfilePicture:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}




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
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    sender.enabled = false;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
    [[API sharedInstance] commandWithParams:params APIPath:(@"/Api/Users") onCompletion:^(NSDictionary *json) {
		
        if(![json isKindOfClass:[NSDictionary class]]||![json objectForKey:@"error"])
		{

			//success
			[[[UIAlertView alloc]initWithTitle:@"Success!" message:@"You have been registered! You can log in now." delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles: nil] show];
		} else {
			
			NSString* errorMsg = [json valueForKey:@"error"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];

		}
        dispatch_async(dispatch_get_main_queue(), ^{
            
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            sender.enabled = true;
        });
	} ];
    
    });
    
}
@end
