//
//  ExploreViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 06/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import "ExploreViewController.h"
#import "Annotation.h"
#define kConfigPlistName @"config"

@interface ExploreViewController ()

@end

@implementation ExploreViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSArray*)locationsFromPlistNamed:(NSString*)plistName {
    NSMutableArray *newLocations = [NSMutableArray array];
    //NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    //dictionary = [dictionary objectForKey:@"Root"];
    //dictionary = [dictionary objectForKey:@"Location"];
    
    NSDictionary *address1 = @{
    @"title": @"Titlu",
    @"address": @"Adresa",
    @"latitude": @44.45,
    @"longitude": @26.12
    };
    NSDictionary *address2 = @{
    @"title": @"Titlu poza",
    @"address": @"Adresa",
    @"latitude": @44.42,
    @"longitude": @26.09
    };

    [newLocations  addObject:(address1)];
    [newLocations  addObject:(address2)];
    //[newLocations addObjectsFromArray:[dictionary objectForKey:@"locationItems"]];
    return newLocations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     locationsAnnotations = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    NSArray *locations = [self locationsFromPlistNamed:kConfigPlistName];
    for (NSDictionary *location in locations) {
        Annotation *annotation = [[Annotation alloc] init];
        [annotation setTitle:[location objectForKey:@"title"]];// @"Title"] ;//
        [annotation setSubtitle:[location objectForKey:@"address"]];//@"address"];//
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[location objectForKey:@"latitude"] floatValue];//44.42;//
        coordinate.longitude = [[location objectForKey:@"longitude"] floatValue];//26.09;//
        [annotation setCoordinate:coordinate];
        [mapView addAnnotation:annotation];
        [locationsAnnotations addObject:annotation];
        [annotation release];
        MKCoordinateRegion region;
        region.center.latitude = coordinate.latitude;
        region.center.longitude = coordinate.longitude;
        region.span.latitudeDelta = 0.03;
        region.span.longitudeDelta = 0.03;
    
        [mapView setRegion:region animated:TRUE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Logout:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Log Out?"
                                                   message: nil
                                                  delegate: self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    
    
    [alert show];
    [alert release];
    
    
    //	[self.delegate playerDetailsViewControllerDidSave:self];
}

- (IBAction)Takephoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    
    [self presentModalViewController:imagePickerController animated:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self performSegueWithIdentifier: @"ExploreLogout" sender: self];
        //NSLog(@"Launching the store");
        //replace appname with any specific name you want
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/appname"]];
    }
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image20 = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *pngData = UIImagePNGRepresentation(image20);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"Image2.png"];
    [pngData writeToFile:filePath atomically:YES];
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(Annotation*)annotation{
	
    NSString *myString = annotation.title;
    myString = [myString stringByAppendingString:@""];
    
	MKPinAnnotationView *annotationView = nil;
    if (![[annotation title] isEqualToString:@"Current Location"]) {
        annotationView =[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title] autorelease];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:myString]] autorelease];
        
        imageView.frame = CGRectOffset(imageView.frame, -15.0f, 0.0f);
        [annotationView setAnimatesDrop:YES];
        [annotationView setCanShowCallout:YES];
        [annotationView addSubview:imageView];
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [detailButton addTarget:self action:@selector(annotationDetailsButtonPressed) forControlEvents:UIControlEventTouchDown];
        [annotationView setRightCalloutAccessoryView:detailButton];
    }
	return annotationView;
}

//Opens Maps application when details button on annotation is tapped.
- (void)annotationDetailsButtonPressed {
    Annotation *selectedAnnotation = [[mapView selectedAnnotations] objectAtIndex:0];
  //  NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude, selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
  //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


- (void)dealloc {
    [mapView setDelegate:nil];
    [mapView release];
    //[_mapView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated
{
    // custom navigation bar
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]) {
        // iOS5
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigation-bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

@end
