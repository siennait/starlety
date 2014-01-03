//
//  AuditionsViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 25/09/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import "AuditionsViewController.h"
#import <unistd.h>
#import "AuditionCell.h"

#define kAPIHost @"http://starlety.com:8080"
//#define kAPIHost @"https://starlety.com:4430"


@interface AuditionsViewController ()

@end

@implementation AuditionsViewController


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
			for(id video in [json valueForKey:@"videos"]   )
            {
                [[LoginInfo sharedInstance].auditionData addObject:video];
            }
            [tableView reloadData];
        }
    }];
}
- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[LoginInfo sharedInstance].auditionData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    AuditionCell *cell = [self.tableView dequeueReusableCellWithIdentifier : simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.User_Name.text = [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"UserName"];
    cell.DateTime.text = [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"DateCreated"];
    if([[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ]  valueForKey:@"LocationName"]!=[NSNull null])
    cell.Location.text = [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ]  valueForKey:@"LocationName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Api/GetMediaFileVideo/?userId=%@&videoId=%@", kAPIHost, [LoginInfo sharedInstance].userId,[[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row] valueForKey:@"ID"]]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 60 ] autorelease];
    [uploadRequest setHTTPMethod:@"GET"];
    [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:nil];
    
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    HUD.delegate = self;
    
	expectedLength = [response expectedContentLength];
	currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
    [LoginInfo sharedInstance].savedVideoData = [[NSMutableData alloc] retain];
    [[LoginInfo sharedInstance].savedVideoData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    HUD.mode = MBProgressHUDModeDeterminate;
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
    [[LoginInfo sharedInstance].savedVideoData appendData:data];
    

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Images/37x-Checkmark.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:[@"tempMovie" stringByAppendingString:@".mov"]];
    
     [[LoginInfo sharedInstance].savedVideoData  writeToFile:videoPath options:NSDataWritingAtomic error:&error];
    NSLog(@"Write returned error: %@", [error localizedDescription]);
    
    
    
    
    NSURL *url = [NSURL fileURLWithPath:videoPath];
    self.movieController = [[MPMoviePlayerController alloc] init];
    [self.movieController setContentURL:url];
    
    [self.movieController.view setFrame:CGRectMake( 0, 40, 320, 456)];
    
    [self.view addSubview:self.movieController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.movieController];
    [self.movieController prepareToPlay];
    [self.movieController play];
    
    [[LoginInfo sharedInstance].savedVideoData release];
    
   
}

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo/Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo/Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
  
    
    [[LoginInfo sharedInstance].savedVideoData release];
    
}


- (void)dealloc {
    [tableView release];
    [super dealloc];
}
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.movieController stop];
    [self.movieController.view removeFromSuperview];
    self.movieController = nil;
    
}



@end
