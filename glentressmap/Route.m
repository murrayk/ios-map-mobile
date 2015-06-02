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

+ (Route *)createRouteWithTitle:(NSString *)title detail:(NSString *)detail icon:(NSString *)icon jsonFile:(NSString *)jsonFile{
    Route *route = [[Route alloc] init];
    route.title = title;
    route.details = detail;
    route.icon = [UIImage imageNamed:icon];
    route.lineString = [Route createLineStringRouteFromJson:jsonFile];
    
    return route;
    
}

+(NSArray *) createLineStringRouteFromJson:(NSString *)jsonFile{
    
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
            [lineString addObject:location];
            NSLog(@"JSON: %@", points );
        }
        [lineStrings addObject:lineString];
    }
    
    return [lineStrings copy];
}
    
    


@end
