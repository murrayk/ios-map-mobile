//
//  TrailLocationsViewController.h
//  glentressmap
//
//  Created by murray king on 14/05/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox.h>
#import "Route.h"

@protocol TrailSelectionDelegate;

@interface TrailLocationsViewController : UITableViewController
@property (nonatomic,weak) id<TrailSelectionDelegate> delegate;
@property (nonatomic, strong) Route *route;
@end

@protocol TrailSelectionDelegate
- (void)TrailLocationsViewControllerDidFinish:(TrailLocationsViewController*)secondViewController moveToCoord:(CLLocationCoordinate2D) location;
@end