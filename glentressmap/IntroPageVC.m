//
//  IntroPageVC.m
//  glentressmap
//
//  Created by murray king on 06/07/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "IntroPageVC.h"
#import "Route.h"

@implementation IntroPageVC
- (IBAction)go:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UISplitViewController *split = [mainStoryboard instantiateInitialViewController] ;
    self.view.window.rootViewController = split;
    
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"routes_config" ofType:@"plist"];
    NSArray *routes = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"routes"];
    
    for (NSDictionary *r in routes) {
        
        
        Route *route = [Route createRouteWithTitle:r[@"title"]
                                            detail:r[@"detail"]
                                              icon:r[@"icon"]
                                          jsonFile:r[@"jsonFile"]
                                             color:r[@"color"]
                      locationsStringArrayNameAttr:r[@"locationsStringArrayNameAttr"]
                     elevationsStringArrayNameAttr:r[@"elevationsStringArrayNameAttr"]
                                         routeInfo:r[@"routeInfo"]
                                        markerIcon:r[@"markerIcon"]];
        
        [self.routes addObject:route];
        
    }
}

@end

