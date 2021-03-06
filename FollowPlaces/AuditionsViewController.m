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
#define kWEBHost @"https://starlety.com"


@interface AuditionsViewController () <UIScrollViewDelegate>
// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *videoThumbnailImageDownloadsInProgress;
@property (nonatomic, strong) NSMutableDictionary *userProfileImageDownloadsInProgress;
@property (nonatomic) CGPoint lastOffset;

@end

@implementation AuditionsViewController

@synthesize tableView;
@synthesize lastOffset;
@synthesize navigationBar;
@synthesize TopStarletyLogo;
@synthesize TopStarletyLogoFile;

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
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self loadData:true];
    [self addRefreshControl];
//    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [self.view addGestureRecognizer:recognizer];
    [TopStarletyLogo setImage:[UIImage imageNamed: self.TopStarletyLogoFile]];
}


-(void)loadData: (BOOL)clearData
{
    if(clearData)
        [LoginInfo sharedInstance].auditionData = [[NSMutableArray alloc] init];
    [[API sharedInstance] getCommand:nil  APIPath:[NSString stringWithFormat:@"/Api/GetVideos/?fromIndex=%lu%@",(unsigned long)[[LoginInfo sharedInstance].auditionData count],
        self.QueryData]  onCompletion:^(NSDictionary *json)  {
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
                auditionRecord.applauseCount = [video valueForKey:@"ApplauseCount"];
                auditionRecord.viewCount = [video valueForKey:@"ViewCount"];
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


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[LoginInfo sharedInstance].auditionData count]-1==indexPath.row)
    {
        [self loadData:false];
        NSLog(@"the real end of the table");
    }
    // Perform operation to load new Cell's.
}
-(void)addRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

}
- (void)refresh:(UIRefreshControl *)refreshControl {
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"pullSound"
                                               ofType:@"mp3"]];
    AVAudioPlayer *click = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    
    [click play];
    [self loadData:true];
    [self.tableView reloadData];

    [refreshControl endRefreshing];
}

-(void) refreshInvoked:(id)sender forState:(UIControlState)state {

    
  
    
}


- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [self setTopStarletyLogo:nil];
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
    
    // customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"SimpleTableItem";
    AuditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
          // Set up the cell...
        Audition *appRecord = [[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row ] ;
    cell.User_Name.text = appRecord.userName;
    cell.DateTime.text = appRecord.dateCreated;
    cell.Location.text = appRecord.location;
    cell.ApplauseCountLabel.text = [NSString stringWithFormat: @"%d",(int)appRecord.applauseCount];
    cell.ViewCountLabel.text = [NSString stringWithFormat: @"%d",(int)appRecord.viewCount];
    
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
    //self.view.tag = indexPath;
  
    [cell.PlayButton setTag:indexPath.row];
    [cell.PlayButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [cell.ApplauseButton setTag:appRecord.ID];
    [cell.ApplauseButton addTarget:self action:@selector(applause:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    

}


-(void) play:(id) sender{
    UIButton *play = (UIButton *)sender;
    NSLog(@"Play %i" , play.tag);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Videos/%@.mp4", kWEBHost, [[[LoginInfo sharedInstance].auditionData objectAtIndex:play.tag] valueForKey:@"ID"]]];
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:url];


    mp.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mp.moviePlayer];

    [mp.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:mp];
    [mp.moviePlayer play];
}


-(void) applause:(id) sender{
    UIButton *applause = (UIButton *)sender;
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:applause.tag, @"videoId", nil];
    
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"applause"
                                               ofType:@"mp3"]];
    AVAudioPlayer *music = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    
    [music play];
    
    
    [[API sharedInstance] getCommand:params  APIPath: @"/Api/VoteVideo"  onCompletion:^(NSDictionary *json)  {
        if ([json valueForKey:@"error" ]) {
            [self showMessage:[json valueForKey:@"error" ] withTitle:@""];
        } else {
          
            
        }}];
    
 
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
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Videos/%@.mp4", kWEBHost, [[[LoginInfo sharedInstance].auditionData objectAtIndex:indexPath.row] valueForKey:@"ID"]]];
//    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    
//    
//    mp.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:mp.moviePlayer];
//    
//    [mp.moviePlayer prepareToPlay];
//    [self presentMoviePlayerViewControllerAnimated:mp];
//    [mp.moviePlayer play];
//    
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
    [navigationBar release];
    [TopStarletyLogo release];
    [super dealloc];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {


}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


@end
