//
//  ParseTrailLocations.h
//  glentressmap
//
//  Created by murray king on 03/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseTrailLocations : NSObject

- (NSArray *)parseXmlFile:(NSString *)xmlFile withBaseStringArrayNameAttr:(NSString *) stringArrayNameAttr ;
 @property(nonatomic, strong) NSMutableArray *trailNamesWithLocations;
@end
