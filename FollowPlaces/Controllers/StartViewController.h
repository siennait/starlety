//
//  StartViewController.h
//  Starlety
//
//  Created by Luchian Chivoiu on 08/03/2014.
//  Copyright (c) 2014 Luchian Chivoiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuditionsViewController.h"

@interface StartViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
