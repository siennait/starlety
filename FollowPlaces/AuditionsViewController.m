//
//  AuditionsViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 25/09/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import "AuditionsViewController.h"
#import <unistd.h>


#define kAPIHost @"http://86.124.72.174:8080"

@interface AuditionsViewController ()

@end

@implementation AuditionsViewController

//@synthesize userId = _userId;
@synthesize tableView;

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

   
    [super viewDidLoad];

     [LoginInfo sharedInstance].auditionData = [[NSMutableArray alloc] init];
    [[API sharedInstance] getCommand:nil  APIPath:@"/Api/GetVideos"  onCompletion:^(NSDictionary *json)  {
        if ([json valueForKey:@"error" ]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
                //self.userId = [json valueForKey:@"UserId"];
			for(id video in [json valueForKey:@"videos"]   )
            {
                [[LoginInfo sharedInstance].auditionData addObject:[video valueForKey:@"ID"]];
            }
            [tableView reloadData];
        }
        //[activity stopAnimating];
       
    }];	// Do any additional setup after loading the view.
}
- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)TakeVideo:(id)sender {

    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
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
      //  [webData release];
    }
    
    self.movieURL = info[UIImagePickerControllerMediaURL];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
*/
/*
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.movieController stop];
    [self.movieController.view removeFromSuperview];
    self.movieController = nil;
    
}
*/
- (void)viewDidAppear:(BOOL)animated {
       /*
    self.movieController = [[MPMoviePlayerController alloc] init];
    [self.movieController setContentURL:self.movieURL];
    
    [self.movieController.view setFrame:CGRectMake( 0, 40, 320, 456)];
    
    [self.view addSubview:self.movieController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.movieController];
    [self.movieController prepareToPlay];
    [self.movieController play];
    */
}
/*
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
  
    //self.userId = [[NSString alloc] init];
    // Setup the request:
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
  
    
    NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@&latitude=%@&longitude=%@", kAPIHost, @"/Api/Videos/?userId=", [LoginInfo sharedInstance].userId, latitude, longitude]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 60 ] autorelease];
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
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Got Server Response" message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        //[alert release];
    }
    else
    {
        // Connection failed (cannot reach server).
        NSLog(@"fail");
    }
    
    
}*/
/*
- (void)dealloc {
    

   // [self.userId release];
    
    //[_LogInButton release];
    [super dealloc];
}
*/
/*

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    HUD.mode = MBProgressHUDModeDeterminate;
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
    }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Images/37x-Checkmark.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
    
    // Append the new data to receivedData.
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Audition uploaded! The audition was also saved on your photo album." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    //[alert release];
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
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[LoginInfo sharedInstance].auditionData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"1352416674_video.png"];

    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [[LoginInfo sharedInstance].auditionData removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}
@end
