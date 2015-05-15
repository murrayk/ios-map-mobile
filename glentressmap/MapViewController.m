//
//  MapViewController.m
//  glentressmap
//
//  Created by murray on 06/04/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//
#import "Mapbox.h"

#import "MapViewController.h"
#import "TrailLocationsViewController.h"

@interface MapViewController ()
- (void)showTrailLocations;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"hd_inners" ofType:@"mbtiles"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    
    if (!self.mapView) {
        self.mapView = mapView;
    }
    
    mapView.zoom = 15;
    mapView.maxZoom = 18;
    mapView.minZoom = 1;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(55.5720,-3.0615);
    mapView.centerCoordinate = center;
    
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(55.6262,-2.9881);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(55.5694, -3.0815);
    
    [mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:NO];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.adjustTilesForRetinaDisplay = NO; //use hd map
    mapView.hideAttribution = YES;
    [self.view addSubview:mapView];
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:center
                                                            andTitle:@"Home"];
    
    
    
    
    mapView.showLogoBug = NO;
    annotation.coordinate = center;
    annotation.title      = @"anything";
    mapView.delegate = self;
    
    
    [mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UIBarButtonItem *locateButton = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showTrailLocations)];

    [self.navigationItem setRightBarButtonItems: [[NSArray alloc] initWithObjects:searchButton, locateButton, nil] animated:NO];
    //move to location.
    
    //self.mapView.userTrackingMode = RMUserTrackingModeFollow;
}

- (void)showTrailLocations
{
    //execute segue programmatically
    [self performSegueWithIdentifier: @"locations" sender: self];
}




- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMShape *shape = [[RMShape alloc] initWithView:mapView];
    
    // set line color and width
    shape.lineColor = [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:0.5];
    shape.lineWidth = 8.0;
    shape.lineJoin = @"round";
    shape.lineCap = @"round";
    
    for (NSArray *lineString in self.lineStrings){
        BOOL first = YES;
        for (CLLocation *location in lineString){
            if (first) {
                first = false;
                [shape moveToCoordinate:location.coordinate];
            } else {
                [shape addLineToCoordinate:location.coordinate];
            }
        }
    }
    
    return shape;
    
}

- (void)TrailLocationsViewControllerDidFinish:(TrailLocationsViewController *)secondViewController moveToCoord:(CLLocationCoordinate2D)location{
    self.mapView.zoom = 17;
    
    self.mapView.centerCoordinate = location;
    
    RMPointAnnotation *annotation = [[RMPointAnnotation alloc]
                                     initWithMapView:self.mapView
                                     coordinate:location
                                     andTitle:@"Hello, world!"];

    [self.mapView addAnnotation:annotation];
    //
}

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    TrailLocationsViewController *tlvc = segue.destinationViewController;
    tlvc.delegate = self;
    
 }


@end
