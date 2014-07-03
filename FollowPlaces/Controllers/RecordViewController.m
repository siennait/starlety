//
//  RecordViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 16/10/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import "RecordViewController.h"
#define kAPIHost @"https://api.starlety.com"
//#define kAPIHost @"https://starlety.com:4430"


@interface RecordViewController ()

@end

@implementation RecordViewController

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
//    if([LoginInfo sharedInstance].userId==nil || [[LoginInfo sharedInstance].userId  isEqual: @""])
//    {
//        [[LoginInfo sharedInstance] logout];
//        [self performSegueWithIdentifier: @"SettingsLogout" sender: self];
//        
//        [FBSession.activeSession closeAndClearTokenInformation];
//        
//    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)TakeVideo:(id)sender {
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]){
        // Saving the video / // Get the new unique filename
        NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
        UISaveVideoAtPathToSavedPhotosAlbum(sourcePath,nil,nil,nil);
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *webData = [NSData dataWithContentsOfURL:videoURL];
        
        AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];

        AVAssetTrack* videoTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        CGSize size = [videoTrack naturalSize];
        
        //Gettint the orientation
        CGAffineTransform txf = [videoTrack preferredTransform];
        UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
        if (size.width == txf.tx && size.height == txf.ty)
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        else if (txf.tx == 0 && txf.ty == 0)
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        else if (txf.tx == 0 && txf.ty == size.width)
            interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        else
            interfaceOrientation = UIInterfaceOrientationPortrait;
        

        [self post:webData interfaceOrientation:interfaceOrientation ];
        
    }
    
    self.movieURL = info[UIImagePickerControllerMediaURL];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (NSData *)generatePostDataForData:(NSData *)uploadData
{
    // Generate the post header:
    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"somefile\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
    
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    
    // Add the image:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

- (void)post:(NSData *)fileData interfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
  
    NSLog(@"POSTING");
    NSLog(@"UIInterfaceOrientationPortrait-%d\n\
          UIInterfaceOrientationPortraitUpsideDown-%d\n\
          UIInterfaceOrientationLandscapeLeft-%d\n\
          UIInterfaceOrientationLandscapeRight-%d", UIInterfaceOrientationPortrait, UIInterfaceOrientationPortraitUpsideDown, UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight);
    
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    HUD.delegate = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Generate the postdata:
    NSData *postData = [self generatePostDataForData: fileData];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // Setup the request:
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
  
     NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@&latitude=%@&longitude=%@&interfaceOrientation=%d", kAPIHost, @"/Api/Videos/?userId=",
        [LoginInfo sharedInstance].userId, latitude, longitude, interfaceOrientation]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 60 ] autorelease];
     [uploadRequest setHTTPMethod:@"POST"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"siennait",
                         @"Sienna123"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [uploadRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
     [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
     [uploadRequest setHTTPBody:postData];
     
     // Execute the reqest:
     NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
     
     
     
     if (conn)
     {
         // Connection succeeded (even if a 404 or other non-200 range was returned).
         NSLog(@"sucess");
     }
     else
     {
         // Connection failed (cannot reach server).
         NSLog(@"fail");
     }

     
    
    
}



- (void)dealloc {
    [super dealloc];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    HUD.mode = MBProgressHUDModeDeterminate;
	currentLength = totalBytesWritten;
	HUD.progress = currentLength / (float)totalBytesExpectedToWrite;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Images/37x-Checkmark.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Video Uploaded Successfully"
                                                        message:[NSString stringWithFormat: @"Audition Was Uploaded Successfully and can be seen on the 'NEW STARLETY' Section"]
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

- (IBAction)RecordButtonTouchUp:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    else
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You don't have a camera for this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        //shows above alert if there's no camera
        [noCameraAlert show];
    }
    
    //otherwise, show a modal for taking a photo
    else {
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        //picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        picker.videoMaximumDuration = 120;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
   
}
@end
