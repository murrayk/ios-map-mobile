//
//  TrailNameAndLocation.h
//  glentressmap
//
//  Created by murray king on 03/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrailNameAndLocation : NSObject

- (id)initWithTrailName:(NSString *) trailName andLocation:(NSString *) location;

@property (nonatomic, strong) NSString * trailName;
@property (nonatomic, strong) NSString * location;

@end
