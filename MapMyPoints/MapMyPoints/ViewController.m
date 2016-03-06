//
//  ViewController.m
//  MapMyPoints
//
//  Created by student on 3/5/16.
//  Copyright © 2016 Shriram. All rights reserved.
//

#import "MapKit/MapKit.h"
#import "ViewController.h"

@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation *uscAnnotation;
@property (strong, nonatomic) MKPointAnnotation *groveAnnotation;
@property (strong, nonatomic) MKPointAnnotation *uclaAnnotation;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;
@property (weak, nonatomic) IBOutlet UISwitch *switchField;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL mapIsMoving;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self addAnnotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uscTapped:(id)sender {
    [self centerMapAtPoint:self.uscAnnotation];
}

- (IBAction)groveTapped:(id)sender {
    [self centerMapAtPoint:self.groveAnnotation];
}

- (IBAction)uclaTapped:(id)sender {
    [self centerMapAtPoint:self.uclaAnnotation];
}

-(void)addAnnotations{
    self.uscAnnotation = [[MKPointAnnotation alloc] init];
    self.uscAnnotation.coordinate = CLLocationCoordinate2DMake(34.0194804, -118.2916626);
    self.uscAnnotation.title = @"USC Campus";
    
    self.groveAnnotation = [[MKPointAnnotation alloc] init];
    self.groveAnnotation.coordinate = CLLocationCoordinate2DMake(34.0718422, -118.3598728);
    self.groveAnnotation.title = @"The Grove";
    
    self.uclaAnnotation = [[MKPointAnnotation alloc] init];
    self.uclaAnnotation.coordinate = CLLocationCoordinate2DMake(34.0689254, -118.4473698);
    self.uclaAnnotation.title = @"UCLA Campus";
    
    self.currentAnnotation = [[MKPointAnnotation alloc] init];
    self.currentAnnotation.coordinate = CLLocationCoordinate2DMake(0,0);
    self.currentAnnotation.title = @"Current Location";
    
    [self.mapView addAnnotations:@[self.uscAnnotation,self.groveAnnotation,self.uclaAnnotation]];
}

-(void) centerMapAtPoint:(MKPointAnnotation *) centerPoint{
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

- (IBAction)switchChanged:(id)sender {
    if(self.switchField.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
    else{
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentAnnotation.coordinate = locations.lastObject.coordinate;
    if(self.mapIsMoving == NO){
        [self centerMapAtPoint:self.currentAnnotation];
    }
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.mapIsMoving = YES;
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.mapIsMoving = NO;
}

@end
