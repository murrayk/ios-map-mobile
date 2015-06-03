//
//  ParseTrailElevations.h
//  glentressmap
//
//  Created by murray king on 03/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseTrailElevations : NSObject<NSXMLParserDelegate>
- (NSArray *)parseXmlFile:(NSString *)xmlFile withStringArrayNameAttr:(NSString *)stringArrayNameAttr;
@end
