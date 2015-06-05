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
#import "TerrainViewController.h"

@interface MapViewController ()
- (void)showTrailLocations;

- (void)showTerrain;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneLocationSetup = NO;
    // Do any additional setup after loading the view.
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"hd_inners" ofType:@"mbtiles"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    
    if (!self.mapView) {
        self.mapView = mapView;
    }
    
    mapView.zoom = 15;
    mapView.maxZoom = 18;
    mapView.minZoom = 1;
    //CLLocationCoordinate2D center = CLLocationCoordinate2DMake(55.5720,-3.0615);
    //mapView.centerCoordinate = center;
    
    //CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(55.6262,-2.9881);
    //CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(55.5694, -3.0815);
    

    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.adjustTilesForRetinaDisplay = NO; //use hd map
    mapView.hideAttribution = YES;
    [self.view addSubview:mapView];
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:self.route.center
                                                            andTitle:@"Trail"];
    
    
    
    
    mapView.showLogoBug = NO;

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

    UIImage *terrainIcon = [UIImage imageNamed:@"terrain"];
    
    UIBarButtonItem *terrainButton = [[UIBarButtonItem alloc] initWithImage:terrainIcon style:UIBarButtonItemStylePlain target:self action:@selector(showTerrain)];
    [self.navigationItem setRightBarButtonItems: [[NSArray alloc] initWithObjects:terrainButton,searchButton, locateButton, nil] animated:NO];
    //move to location.
    
    if(self.doneLocationSetup == NO){
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:self.route.bb.southWest northEast:self.route.bb.northEast animated:YES];
         self.doneLocationSetup = YES;
    } 
    
    //self.mapView.userTrackingMode = RMUserTrackingModeFollow;
}



- (void)showTrailLocations
{
    //execute segue programmatically
    [self performSegueWithIdentifier: @"locations" sender: self];
}

- (void)showTerrain
{
    //execute segue programmatically
    [self performSegueWithIdentifier: @"terrain" sender: self];
}


- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMShape *shape = [[RMShape alloc] initWithView:mapView];
    
    // set line color and width
    shape.lineColor = self.route.color;
    shape.lineWidth = 8.0;
    shape.lineJoin = @"round";
    shape.lineCap = @"round";
    
    
    for (NSArray *line in self.route.lineString){
        BOOL first = YES;
        for (CLLocation *location in line){
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
     if ([segue.identifier isEqual:@"locations"]) {
         TrailLocationsViewController *tlvc = segue.destinationViewController;
         tlvc.delegate = self;
         tlvc.route = self.route;
     }
     else if ([segue.identifier isEqual:@"terrain"]) {
         TerrainViewController *tvc = segue.destinationViewController;
         tvc.route = self.route;
     }

    
 }


@end
