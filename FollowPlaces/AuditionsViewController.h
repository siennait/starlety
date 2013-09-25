//
//  AuditionsViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 25/09/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AuditionsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy,   nonatomic) NSURL *movieURL;
@property (strong, nonatomic) MPMoviePlayerController *movieController;

- (IBAction)TakeVideo:(id)sender;

@end
