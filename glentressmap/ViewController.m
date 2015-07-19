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
#import "IntroPageVC.h"


@interface ViewController ()<UISplitViewControllerDelegate>
-(void) showHome;

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
UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                 style:UIBarButtonItemStylePlain 
                                target:self 
                                action:@selector(showHome)];
[self.navigationItem setLeftBarButtonItem:item animated:NO];
    
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
    
    
    
    UISplitViewController *splitViewController = self.splitViewController;

     
    
    
    
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    if ([splitViewController respondsToSelector:@selector(displayModeButtonItem)]) {
        UIBarButtonItem * displayModeButton = splitViewController.displayModeButtonItem;
        navigationController.topViewController.navigationItem.leftBarButtonItem = displayModeButton ;

    }
    

    

    
    //not sure if we need a key
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoibXVycmF5aGtpbmciLCJhIjoiZVVfeGhqNCJ9.WJaoPywqu21-rgRkQJqsKQ"];
       

    
    self.navigationItem.title = @"Trails";
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}


-(void) showHome{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 3. Create vc
    IntroPageVC *tutorialViewController = [storyboard instantiateViewControllerWithIdentifier:@"intro"];
    // 4. Set as root
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = tutorialViewController;

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
                  
                    controller.navigationItem.leftBarButtonItem = self.displayModeButton;
                    
                }
                
                
            }
        }
    }
}



#pragma mark - Split view



- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{

    UISplitViewController *splitViewController = (UISplitViewController *)self.splitViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    
    navigationController.topViewController.navigationItem.leftBarButtonItem = barButtonItem;
    
    NSLog(@"barbuttonItem %@", barButtonItem);
}


- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{

    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    
    navigationController.topViewController.navigationItem.leftBarButtonItem = barButtonItem;
    self.displayModeButton = barButtonItem;
    NSLog(@"barbuttonItem %@", barButtonItem);

}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
        && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MapViewController class]]
        && ([(MapViewController *)[(UINavigationController *)secondaryViewController topViewController] route] == nil)) {
        
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
        
    } else {
        
        return NO;
        
    }
}



@end
