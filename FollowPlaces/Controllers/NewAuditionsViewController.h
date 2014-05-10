//
//  AuditionsViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 25/09/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import "LoginInfo.h"
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CLAvailability.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import "LoginInfo.h"
#import "API.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface NewAuditionsViewController : UIViewController<UINavigationControllerDelegate,MKAnnotation,UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate> {
    	MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
    
    
        
        AVAudioPlayer *audio;
    
    

}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (copy,   nonatomic) NSURL *movieURL;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) MPMoviePlayerController *movieController;


@property NSUInteger pageIndex;
@property (strong, nonatomic) NSString *TopStarletyLogoFile;
@property (strong, nonatomic) NSString *QueryData;



@property (retain, nonatomic) IBOutlet UIImageView *TopStarletyLogo;

@property (strong, atomic) ALAssetsLibrary* library;

@end

