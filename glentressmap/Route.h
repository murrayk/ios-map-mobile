//
//  Route.h
//  glentressmap
//
//  Created by murrayhking on 02/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mapbox.h"

typedef struct {
	CLLocationCoordinate2D southWest;
	CLLocationCoordinate2D northEast;
} BoundingBox;

@interface Route : NSObject

+ (Route *)createRouteWithTitle:(NSString *) title detail:(NSString *)detail icon:(NSString *) icon jsonFile:(NSString *) jsonFile color:(UIColor *) color locationsStringArrayNameAttr:(NSString *) locationsStringArrayNameAttr elevationsStringArrayNameAttr:(NSString *) elevationsStringArrayNameAttr routeInfo:(NSString *) routeInfo;
+(NSArray *)createLineStringRouteFromJson:(NSString *) jsonFile  andReturnBoundingBoxSouthWest:(CLLocationCoordinate2D *) sw
ne:(CLLocationCoordinate2D *) ne ;

+(CLLocationCoordinate2D) findCenterOfBoundingBox:(BoundingBox) bb;

@property (nonatomic, strong)UIImage *icon;
@property (nonatomic, strong)NSArray *lineString;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *details;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic) BoundingBox bb;
@property (nonatomic) CLLocationCoordinate2D center;
@property (nonatomic,strong) NSArray *trailNameWithLocation;
@property (nonatomic, strong) NSArray *elevations;
@property (nonatomic, strong)NSString *routeInfo;


@end
