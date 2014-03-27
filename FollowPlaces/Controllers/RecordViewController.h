//
//  RecordViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 16/10/2013.
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
#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate>{
	MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
}
@property (copy,   nonatomic) NSURL *movieURL;
@property (strong, nonatomic) MPMoviePlayerController *movieController;
@property NSUInteger pageIndex;

- (IBAction)RecordButtonTouchUp:(id)sender;

@end
