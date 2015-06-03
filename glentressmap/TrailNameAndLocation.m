//
//  TrailNameAndLocation.m
//  glentressmap
//
//  Created by murray king on 03/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "TrailNameAndLocation.h"

@implementation TrailNameAndLocation

- (id)initWithTrailName:(NSString *) trailName andLocation:(NSString *) location{
    self = [super init];
    if (self) {
        self.trailName = trailName;
        self.location = location;
    
    }
    return self;
}

@end
