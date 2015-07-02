//
//  Route.m
//  glentressmap
//
//  Created by murrayhking on 02/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "Route.h"
#import "Mapbox.h"
#import "ParseTrailLocations.h"
#import "ParseTrailElevations.h"

@implementation Route

NSDictionary *colors = nil;

+ (void)initialize {
    if(!colors){
        
        UIColor *redWithAlpha = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        UIColor *orangeWithAlpha = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.5];
        UIColor *greenWithAlpha = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
        UIColor *blueWithAlpha = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
        UIColor *blackWithAlpha = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        colors = @{
                    @"red" :redWithAlpha,
                    @"orange" : orangeWithAlpha,
                    @"blue" : blueWithAlpha,
                    @"green" : greenWithAlpha,
                    @"black" : blackWithAlpha
                    };
    }
}

+ (Route *)createRouteWithTitle:(NSString *)title detail:(NSString *)detail icon:(NSString *)icon jsonFile:(NSString *)jsonFile color:(UIColor *) color locationsStringArrayNameAttr:(NSString *)locationsStringArrayNameAttr elevationsStringArrayNameAttr:(NSString *)elevationsStringArrayNameAttr routeInfo:(NSString *)routeInfo markerIcon:(NSString *)markerIcon {
    

    Route *route = [[Route alloc] init];
    route.title = title;
    route.details = detail;
    route.icon = [UIImage imageNamed:icon];
    CLLocationCoordinate2D  sw;
    CLLocationCoordinate2D  ne;
    route.lineString = [Route createLineStringRouteFromJson:jsonFile andReturnBoundingBoxSouthWest:&sw ne:&ne];
    route.color = colors[color];
    BoundingBox bb;
    bb.northEast = ne;
    bb.southWest = sw;
    route.bb = bb;
    route.routeInfo = routeInfo;
    

    route.center = [Route findCenterOfBoundingBox:bb];
    
    ParseTrailLocations *tparser = [[ParseTrailLocations alloc] init];
    NSArray *trails = [tparser parseXmlFile:@"trails" withBaseStringArrayNameAttr: locationsStringArrayNameAttr];
    route.trailNameWithLocation = trails;
    ParseTrailElevations *eparser = [[ParseTrailElevations alloc] init];
    NSArray *elevations = [eparser parseXmlFile:@"elevations" withStringArrayNameAttr: elevationsStringArrayNameAttr];
    route.elevations = elevations;
    
    route.markerIcon = markerIcon;
    return route;
    
}

+(CLLocationCoordinate2D) findCenterOfBoundingBox:(BoundingBox) bb{
    CLLocationCoordinate2D center;
    center.latitude = (bb.northEast.latitude + bb.southWest.latitude)/2;
    center.longitude = (bb.northEast.longitude + bb.southWest.longitude)/2;
    return center;
}

+(NSArray *) createLineStringRouteFromJson:(NSString *)jsonFile andReturnBoundingBoxSouthWest:(CLLocationCoordinate2D *) sw
ne:(CLLocationCoordinate2D *) ne {

    CLLocationCoordinate2D min, max;
	min.latitude = kRMMaxLatitude; min.longitude = kRMMaxLongitude;
	max.latitude = kRMMinLatitude; max.longitude = kRMMinLongitude;
    
    CLLocationDegrees currentLatitude, currentLongitude;
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonFile
                                                         ofType:@"geojson"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    NSMutableArray *lineStrings = [[NSMutableArray alloc]init];
    NSArray *features = json[@"features"];
    
    if(error){
        NSLog(@"%@", [error localizedDescription]);
    }
    
    
    for (NSDictionary *dict in features ) {
        
        NSArray *coords = dict[@"geometry"][@"coordinates"];
        NSMutableArray *lineString = [[NSMutableArray alloc]init];
        for (NSArray *points in coords) {
            
            double longitude = [points[0] doubleValue];
            double latitude = [points[1] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            
            currentLatitude = location.coordinate.latitude;
            currentLongitude = location.coordinate.longitude;
            
            max.latitude  = fmax(currentLatitude, max.latitude);
            max.longitude = fmax(currentLongitude, max.longitude);
            min.latitude  = fmin(currentLatitude, min.latitude);
            min.longitude = fmin(currentLongitude, min.longitude);
            [lineString addObject:location];
            NSLog(@"JSON: %@", points );
        }
        [lineStrings addObject:lineString];
    }
    if(sw){
        *sw = min;
    }
    if(ne){
    
        *ne = max;
    }

    return [lineStrings copy];
}




    
    


@end
