//
//  Annotation.h
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 15/09/2013.
//  Copyright (c) 2013 Luchian Chivoiu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface Annotation : NSObject <MKAnnotation> {
	
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
