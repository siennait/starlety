//
//  AuditionCell.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 07/11/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditionCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *User_Name;
@property (retain, nonatomic) IBOutlet UILabel *DateTime;
@property (retain, nonatomic) IBOutlet UILabel *Location;
@property (retain, nonatomic) IBOutlet UIImageView *UserProfileImage;
@property (retain, nonatomic) IBOutlet UIImageView *Thumbnail;


@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ViewButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *PlayButton;
@property (retain, nonatomic) IBOutlet UIButton *ApplauseButton;
@property (retain, nonatomic) IBOutlet UILabel *ApplauseCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *ViewCountLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *DownloadButton;

@end
