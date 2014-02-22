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
#import "Audition.h"
#import "IconDownloader.h"
#import "User.h"

#define kAPIHost @"http://starlety.com:8080"
//#define kAPIHost @"https://starlety.com:4430"


@interface AuditionsViewController () <UIScrollViewDelegate>
// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *videoThumbnailImageDownloadsInProgress;
@property (nonatomic, strong) NSMutableDictionary *userProfileImageDownloadsInProgress;

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
                 Audition *auditionRecord = [[Audition alloc] init];
                auditionRecord.ID = [video valueForKey:@"ID"];
                auditionRecord.userName = [video valueForKey:@"UserName"];
                auditionRecord.dateCreated = [video valueForKey:@"DateCreated"];
                auditionRecord.location = [video valueForKey:@"LocationName"];
                auditionRecord.userName = [video valueForKey:@"UserName"];
                auditionRecord.userFacebookId = [video valueForKey:@"UserFacebookId"];
                auditionRecord.videoThumbnail = [[Icon alloc] init];
                auditionRecord.videoThumbnail.imageURLString = [NSString stringWithFormat:@"https://starlety.com/Thumbnails/%@.png", [video valueForKey:@"ID"] ];
                auditionRecord.userId =[video valueForKey:@"UserId"];
                User *userRecord = [[User alloc] init];
                userRecord.ID = [video valueForKey:@"UserId"];
                userRecord.ProfileImage = [[Icon alloc] init];
                userRecord.ProfileImage.imageURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", [video valueForKey:@"UserFacebookId"]];
                userRecord.userFacebookId =[video valueForKey:@"UserFacebookId"];
                [[LoginInfo sharedInstance].users addObject:userRecord];

                [[LoginInfo sharedInstance].auditionData addObject:auditionRecord];
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
    
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//    AuditionCell *cell = [self.tableView dequeueReusableCellWithIdentifier : simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    cell.User_Name.text = [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"UserName"];
//    cell.DateTime.text = [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"DateCreated"];
//    if([[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ]  valueForKey:@"LocationName"]!=[NSNull null])
//    cell.Location.text = [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ]  valueForKey:@"LocationName"];
//    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", [result objectForKey:@"id"]]];
//    //NSData *data = [NSData dataWithContentsOfURL:url];
//    //ProfileImage.image = [[[UIImage alloc] initWithData:data] autorelease];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"UserFacebookId"] ]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    cell.UserProfileImage.image = [[[UIImage alloc] initWithData:data] autorelease];
//        
//        NSURL *urlThumbnail = [NSURL URLWithString:[NSString stringWithFormat:@"https://starlety.com/Thumbnails/%@.png", [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"ID"] ]];
//        NSData *dataThumbnail = [NSData dataWithContentsOfURL:urlThumbnail];
//        cell.Thumbnail.image = [[[UIImage alloc] initWithData:dataThumbnail] autorelease];
//    });
//
//
//    return cell;

    // customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"SimpleTableItem";
    //static NSString *PlaceholderCellIdentifier = @"SimpleTableItem";
    
    // add a placeholder cell while waiting on table data
//    NSUInteger nodeCount = [self.entries count];
//	
//	if (nodeCount == 0 && indexPath.row == 0)
//	{
//        AuditionCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
//        
//        
//		cell.detailTextLabel.text = @"Loading…";
//		
//		return cell;
//    }
	
    AuditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Leave cells empty if there's no data yet
//    if (nodeCount > 0)
//	{
        // Set up the cell...
        Audition *appRecord = [[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] ;
//        
//		cell.textLabel.text = appRecord.appName;
//        cell.detailTextLabel.text = appRecord.artist;
        
//        if (cell == nil) {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//                }
    cell.User_Name.text = appRecord.userName;//[[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"UserName"];
    cell.DateTime.text = appRecord.dateCreated;//[[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] valueForKey:@"DateCreated"];
    cell.Location.text = appRecord.location;//[[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ]  valueForKey:@"LocationName"];

        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.videoThumbnail.image)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownloadVideoThumbnail:appRecord.videoThumbnail forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.Thumbnail.image = [UIImage imageNamed:@"1352416669_video.png"];
        }
        else
        {
            cell.Thumbnail.image = appRecord.videoThumbnail.image;
        }
    
    NSArray *result = [[LoginInfo sharedInstance].users filteredArrayUsingPredicate:[NSPredicate                                                                                predicateWithFormat:@"self.ID == %@", appRecord.userId]] ;
    User *userRecord = result.firstObject;
    NSUInteger originalIndex = [result indexOfObject:userRecord];
    
    if (!userRecord.ProfileImage.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownloadUserImage:userRecord.ProfileImage forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.UserProfileImage.image = [UIImage imageNamed:@"1352415205_man.png"];
    }
    else
    {
        cell.UserProfileImage.image = userRecord.ProfileImage.image;
    }
    
//    }
    
    return cell;
    
    

}


// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownloadVideoThumbnail:(Icon *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.videoThumbnailImageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{

            AuditionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

            // Display the newly loaded image
            cell.Thumbnail.image = appRecord.image;

            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.videoThumbnailImageDownloadsInProgress removeObjectForKey:indexPath];

        }];
        [self.videoThumbnailImageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRowsVideoThumbnail
{
    if ([[LoginInfo sharedInstance].auditionData count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Audition *appRecord = [[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row];

            if (!appRecord.videoThumbnail.image)
            // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownloadVideoThumbnail:appRecord.videoThumbnail forIndexPath:indexPath];
            }
        }
    }
}


// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownloadUserImage:(Icon *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.userProfileImageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            AuditionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.UserProfileImage.image = appRecord.image;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.userProfileImageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.userProfileImageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRowsUserImage
{
    if ([[LoginInfo sharedInstance].users count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            User *appRecord = [[LoginInfo sharedInstance].users objectAtIndex:indexPath.row];
            
            if (!appRecord.ProfileImage.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownloadUserImage:appRecord.ProfileImage forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRowsVideoThumbnail];
        [self loadImagesForOnscreenRowsUserImage];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRowsVideoThumbnail];
    [self loadImagesForOnscreenRowsUserImage];

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
