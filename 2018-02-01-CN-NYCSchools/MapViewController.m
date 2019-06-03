//
//  MapViewController.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.mapType = [[NSUserDefaults standardUserDefaults] integerForKey:@"MapViewController-MapType"];
    
    self.mapTypeSegmentedControl.selectedSegmentIndex = self.mapView.mapType;

    CLLocationDegrees lattitude = self.lattitude.floatValue;
    CLLocationDegrees longitude = self.longitude.floatValue;
    CLLocation* location = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
    
    [self addPinWithTitle: self.name location:location];

    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)directionsButtonPressed:(UIBarButtonItem *)sender
{
    CLLocationDegrees lattitude = self.lattitude.floatValue;
    CLLocationDegrees longitude = self.longitude.floatValue;

    NSString* mapType = @"h";
    if(self.mapView.mapType == MKMapTypeStandard)
        mapType = @"m";
    else if(self.mapView.mapType == MKMapTypeSatellite)
        mapType = @"k";
    else if(self.mapView.mapType == MKMapTypeHybrid)
        mapType = @"h";

    NSString* locationText = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f+saddr=%f,%f+dirflg=d+t=%@", lattitude, longitude, lattitude, longitude, mapType];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:locationText] options:@{} completionHandler:nil];
}

-(void)addPinWithTitle:(NSString *_Nullable)title location:(CLLocation*_Nonnull)location;
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    mapPin.title = title;
    mapPin.coordinate = location.coordinate;
    
    [self.mapView addAnnotation:mapPin];
}

- (IBAction)mapTypeSegmentedControlValueChanged:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
        self.mapView.mapType = MKMapTypeStandard;
    else if(sender.selectedSegmentIndex == 1)
        self.mapView.mapType = MKMapTypeSatellite;
    else if(sender.selectedSegmentIndex == 2)
        self.mapView.mapType = MKMapTypeHybrid;
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.mapView.mapType forKey:@"MapViewController-MapType"];
}

// Simplfy, not using a delegate, not selection action to be taken
- (IBAction)closeButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
