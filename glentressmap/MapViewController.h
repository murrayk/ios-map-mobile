//
//  MapViewController.h
//  glentressmap
//
//  Created by murray on 06/04/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController<RMMapViewDelegate>
@property (nonatomic, strong) NSArray *lineStrings;

@property (nonatomic, strong) IBOutlet RMMapView *mapView;


@end
