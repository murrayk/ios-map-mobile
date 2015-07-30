//
//  IntroPageVC.m
//  glentressmap
//
//  Created by murray king on 06/07/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "IntroPageVC.h"
#import "Route.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation IntroPageVC



-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"routes_config" ofType:@"plist"];
    
    NSMutableArray * nsroutes = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if(!appDelegate.routes){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelText = @"Loading Offline Map";
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //Call your function or whatever work that needs to be done
            //Code in this part is run on a background thread
            
            NSArray *routes = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"routes"];
            
            for (int i=0; i < routes.count; i++) {
                
                NSDictionary *r = routes[i];
                Route *route = [Route createRouteWithTitle:r[@"title"]
                                                    detail:r[@"detail"]
                                                      icon:r[@"icon"]
                                                  jsonFile:r[@"jsonFile"]
                                                     color:r[@"color"]
                              locationsStringArrayNameAttr:r[@"locationsStringArrayNameAttr"]
                             elevationsStringArrayNameAttr:r[@"elevationsStringArrayNameAttr"]
                                                 routeInfo:r[@"routeInfo"]
                                                markerIcon:r[@"markerIcon"]];
                
                
                [nsroutes addObject:route];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {

                    hud.progress = i + 1.0/ routes.count;
                    
                });
                
                
            }
            
            
            
            appDelegate.routes = nsroutes;
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [hud hide:YES];
                
            });
            
            
            
            
        });
        
        
    }
    
    
}



- (IBAction)go:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UISplitViewController *split = [mainStoryboard instantiateInitialViewController] ;
    self.view.window.rootViewController = split;
    
    
    
    
}

@end

