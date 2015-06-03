//
//  Route.m
//  glentressmap
//
//  Created by murrayhking on 02/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "Route.h"
#import "Mapbox.h"
@implementation Route

+ (Route *)createRouteWithTitle:(NSString *)title detail:(NSString *)detail icon:(NSString *)icon jsonFile:(NSString *)jsonFile color:(UIColor *) color{
    Route *route = [[Route alloc] init];
    route.title = title;
    route.details = detail;
    route.icon = [UIImage imageNamed:icon];
    CLLocationCoordinate2D  sw;
    CLLocationCoordinate2D  ne;
    route.lineString = [Route createLineStringRouteFromJson:jsonFile andReturnBoundingBoxSouthWest:&sw ne:&ne];
    route.color = color;
    BoundingBox bb;
    bb.northEast = ne;
    bb.southWest = sw;
    route.bb = bb;
    CLLocationCoordinate2D center;
    center.latitude = (bb.northEast.latitude + bb.southWest.latitude)/2;
    center.longitude = (bb.northEast.longitude + bb.southWest.longitude)/2;
    route.center = center;
    return route;
    
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