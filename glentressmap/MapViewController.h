//
//  MapViewController.h
//  glentressmap
//
//  Created by murray on 06/04/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailLocationsViewController.h"
#import "Route.h"
@interface MapViewController : UIViewController<RMMapViewDelegate,TrailSelectionDelegate>
@property (nonatomic, strong)  Route *route;


@property (nonatomic, strong) IBOutlet RMMapView *mapView;


@end
