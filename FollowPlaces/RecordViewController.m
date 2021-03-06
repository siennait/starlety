//
//  RecordViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 16/10/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import "RecordViewController.h"
#define kAPIHost @"http://starlety.com:8080"
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
    if([LoginInfo sharedInstance].userId==nil || [[LoginInfo sharedInstance].userId  isEqual: @""])
    {
        [[LoginInfo sharedInstance] logout];
        [self performSegueWithIdentifier: @"SettingsLogout" sender: self];
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
    }
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
        
        
        [self post:webData];
        
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

- (void)post:(NSData *)fileData
{
  
    NSLog(@"POSTING");
    //HUD = [[MBProgressHUD alloc] initWithView:self.view];
	//[self.view addSubview:HUD];
	
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //HUD.mode = MBProgressHUDModeDeterminate;
    
	HUD.delegate = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Generate the postdata:
    NSData *postData = [self generatePostDataForData: fileData];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // Setup the request:
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
  
         NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@&latitude=%@&longitude=%@", kAPIHost, @"/Api/Videos/?userId=",
            [LoginInfo sharedInstance].userId, latitude, longitude]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 60 ] autorelease];
         [uploadRequest setHTTPMethod:@"POST"];
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
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
                                                        message:[NSString stringWithFormat: @"Audition Was Uploaded Successfully and can be seen on the 'New Auditions' Section"]
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
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
}
@end
