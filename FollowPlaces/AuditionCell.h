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

@end
