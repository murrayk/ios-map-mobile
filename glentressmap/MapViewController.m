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
#import "ViewController.h"

@interface MapViewController ()
- (void)showTrailLocations;
@property (weak, nonatomic) IBOutlet UIView *mapHolder;
-(void) addRoute;
- (void)showTerrain;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneLocationSetup = NO;
    // Do any additional setup after loading the view.
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"maptiles" ofType:@"mbtiles"];
    
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    

    
    self.mapView.zoom = 15;
    self.mapView.maxZoom = 18;
    self.mapView.minZoom = 1;

    //self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;

    
    self.mapView.adjustTilesForRetinaDisplay = NO; //use hd map
    self.mapView.hideAttribution = YES;
    [self.mapHolder addSubview:self.mapView];
    if (!self.route) {
        //get route from master.
        UINavigationController *navc = [self.splitViewController.viewControllers firstObject];
        ViewController *masterVC = (ViewController *)navc.topViewController;
        //self.route = masterVC.routes[0];
    }
    
    [self addRoute];
    self.mapView.showLogoBug = NO;
    

    self.mapView.delegate = self;
    
    
    
}

-(void) addRoute{
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                          coordinate:self.route.center
                                                            andTitle:@"Trail"];
    [self.mapView addAnnotation:annotation];
    
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
    
    if(self.doneLocationSetup == NO && self.route){
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
    
    
    if ([annotation.userInfo isEqualToString:@"marker"]){
       return [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:self.route.markerIcon ] anchorPoint:CGPointMake(0.5, 1.0)];
    }
    
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

- (void)TrailLocationsViewControllerDidFinish:(TrailLocationsViewController *)secondViewController moveTrailNameAndLocation:(TrailNameAndLocation *)tl{
    self.mapView.zoom = 17;
    
    NSString *coord = tl.location;
    NSArray *coords = [coord componentsSeparatedByString:@","];
    
    double lon = [coords[0] doubleValue];
    double lat =  [coords[1] doubleValue];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat,lon);
    self.mapView.centerCoordinate = location;
    
    RMAnnotation *annotation = [[RMAnnotation alloc]
                                 initWithMapView:self.mapView
                                 coordinate:location
                                 andTitle:tl.trailName];
    annotation.userInfo = @"marker";
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
