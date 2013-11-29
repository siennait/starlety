//
//  AuditionCell.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 07/11/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//

#import "AuditionCell.h"

@implementation AuditionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_User_Name release];
    [_DateTime release];
    [_Location release];
    [super dealloc];
}
@end
