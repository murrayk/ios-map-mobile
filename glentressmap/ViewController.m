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


- (NSMutableArray*) routes
{
    if (!_routes){
        _routes = [[NSMutableArray alloc] init];
    }
    return _routes;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"routes_config" ofType:@"plist"];
    NSArray *routes = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"routes"];
    
    for (NSDictionary *r in routes) {
        
        
        Route *route = [Route createRouteWithTitle:r[@"title"]
                                         detail:r[@"detail"]
                                           icon:r[@"icon"]
                                       jsonFile:r[@"jsonFile"]
                                          color:r[@"color"]
                   locationsStringArrayNameAttr:r[@"locationsStringArrayNameAttr"]
                  elevationsStringArrayNameAttr:r[@"elevationsStringArrayNameAttr"]];
        
        [self.routes addObject:route];
        
    }
    

    

    
    //not sure if we need a key
    
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
