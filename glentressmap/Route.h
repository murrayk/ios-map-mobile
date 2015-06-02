//
//  Route.h
//  glentressmap
//
//  Created by murrayhking on 02/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

+ (Route *)createRouteWithTitle:(NSString *) title detail:(NSString *)detail icon:(NSString *) icon jsonFile:(NSString *) jsonFile;
+(NSArray *)createLineStringRouteFromJson:(NSString *) jsonFile;
@property UIImage *icon;
@property NSArray *lineString;
@property NSString *title;
@property NSString *details;


@end
