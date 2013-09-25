//
//  ExploreViewController.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 06/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ExploreViewController : UIViewController {
    NSMutableArray *locationsAnnotations;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)Logout:(id)sender;
- (IBAction)Takephoto:(id)sender;

@end
