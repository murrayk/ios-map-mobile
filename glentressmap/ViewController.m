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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
NSArray *routes;
NSArray *icons;
NSArray *detail;
NSMutableArray *lineStrings;

- (void)viewDidLoad {
    [super viewDidLoad];
#warning turn to object rather than arrays
    routes = [NSArray arrayWithObjects:@"XC route",@"Downhill Routes", nil];
    icons = [NSArray arrayWithObjects:@"red_icon.png",@"orange_icon.png", nil];
    detail = [NSArray arrayWithObjects:@"Expert mountain bike users,\n used to physically demanding routes. Quality off-road mountain bikes.",@"Downhill Park, Riders aspiring to athlete level of technical ability, incorporates everything from full on downhill riding to big-air jumps.", nil];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"testjson"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    lineStrings = [[NSMutableArray alloc]init];
    NSArray *features = json[@"features"];
    
    for (NSDictionary *dict in features ) {
        
        NSArray *coords = dict[@"geometry"][@"coordinates"];
        NSMutableArray *lineString = [[NSMutableArray alloc]init];
        for (NSArray *points in coords) {
            
            double longitude = [points[0] doubleValue];
            double latitude = [points[1] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            [lineString addObject:location];
            NSLog(@"JSON: %@", points );
        }
        [lineStrings addObject:lineString];
    }
    
    
    
    NSLog(@"JSON: %@", [features isKindOfClass:[NSArray class]] ? @"true" : @"false" );
    
    
    

    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoibXVycmF5aGtpbmciLCJhIjoiZVVfeGhqNCJ9.WJaoPywqu21-rgRkQJqsKQ"];
       

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RouteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    cell.textLabel.text = [routes objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [detail objectAtIndex:indexPath.row];
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
            if([segue.identifier isEqualToString:@"mapview"]){
                MapViewController *mvc = segue.destinationViewController;
                mvc.lineStrings = lineStrings;
                
            }
        }
    }
}

@end
