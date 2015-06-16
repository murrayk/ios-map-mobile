//
//  ViewController.m
//  glentressmap
//
//  Created by murray on 30/03/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "Mapbox.h"

#import "ViewController.h"
#import "MapViewController.h"
#import "Route.h"
#import "AppDelegate.h"

@interface ViewController ()


@end

@implementation ViewController

NSArray *icons;
NSArray *detail;
NSMutableArray *lineStrings;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *redWithAlpha = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
    UIColor *orangeWithAlpha = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.5];
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"routes_config" ofType:@"plist"];
    NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:plistLocation];
    
    
    
    Route *xc = [Route createRouteWithTitle:@"XC route"
                                     detail:@"Expert mountain bike users,\n used to physically demanding routes. Quality off-road mountain bikes."
                                       icon:@"red_icon.png"
                                   jsonFile:@"xc"
                                   color:redWithAlpha
                                   locationsStringArrayNameAttr:@"red_inners_loc_"
                                    elevationsStringArrayNameAttr:@"inners_xc"];
    
    
   Route *downhill = [Route createRouteWithTitle:@"Downhill Routes"
    detail:@"Downhill Park, Riders aspiring to athlete level of technical ability, incorporates everything from full on downhill riding to big-air jumps."
                                             icon:@"orange_icon.png"
                                            jsonFile:@"downhill"
                                            color:orangeWithAlpha
                                            locationsStringArrayNameAttr:@"inners_downhill_loc_"
                                            elevationsStringArrayNameAttr:@"inners_downhill"];
    
    self.routes = [NSArray arrayWithObjects:xc,downhill, nil];

    
    
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoibXVycmF5aGtpbmciLCJhIjoiZVVfeGhqNCJ9.WJaoPywqu21-rgRkQJqsKQ"];
       

    
    self.navigationItem.title = @"newTitle";
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RouteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    Route *route = [self.routes objectAtIndex:indexPath.row];
    cell.textLabel.text = route.title;
    cell.imageView.image = route.icon;
    cell.detailTextLabel.text = route.details;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UITableViewCell class]]){
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
   
        
        if(indexPath) {
            Route *route = [self.routes objectAtIndex:indexPath.row];
            if([segue.identifier isEqualToString:@"mapview"]){
 
                
                UIViewController *controller = [segue destinationViewController];
                if (![controller isKindOfClass:[MapViewController class]]) {
                    controller = [[segue destinationViewController] topViewController];
                }
                
                [((MapViewController *)controller) setRoute:route];
                if ([self.splitViewController respondsToSelector:@selector(displayModeButtonItem)]) {
                    UIBarButtonItem *showSplit = self.splitViewController.displayModeButtonItem;
                    
                    controller.navigationItem.leftBarButtonItem = showSplit;
                    
                    controller.navigationItem.leftItemsSupplementBackButton = YES;
                } else {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    controller.navigationItem.leftBarButtonItem = appDelegate.displayModeButton;
                    
                }
                
                
            }
        }
    }
}



@end
