//
//  TrailLocationsViewController.m
//  glentressmap
//
//  Created by murray king on 14/05/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "TrailLocationsViewController.h"
#import "Mapbox.h"

@interface TrailLocationsViewController ()<NSXMLParserDelegate>{
    BOOL inStringArrayTag;
    BOOL inItemTag;
    
}
@property(nonatomic, strong) NSString * stringArrayNameAttr;
@property(nonatomic, strong) NSMutableArray * trailNames;
@property(nonatomic, strong) NSMutableArray * trailLocations;

@end



@implementation TrailLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    self.trailNames = [[NSMutableArray alloc] init];
    self.trailLocations = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"strings" ofType:@"xml"];
    
    // Load the file and check the result
    NSData *data = [NSData dataWithContentsOfFile:filePath
                                          options:NSDataReadingUncached
                                            error:&error];
    
    
    if(error) {
        NSLog(@"Error %@", error);
    }
    
    
    // Create a parser and point it at the NSData object containing the file we just loaded
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setDelegate:self];
    
    // Invoke the parser and check the result
    [parser parse];
    error = [parser parserError];
    if(error){
        NSLog(@"Error %@", error);
        
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.trailNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TrailNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    cell.textLabel.text = [self.trailNames objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"red_icon"];

    return cell;
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    NSString *coord = self.trailLocations[indexPath.row];
    NSArray *coords = [coord componentsSeparatedByString:@","];
    
    double lon = [coords[0] doubleValue];
    double lat =  [coords[1] doubleValue];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat,lon);
    [self.delegate TrailLocationsViewControllerDidFinish:self moveToCoord:location];
}

 #pragma mark - xml sax parser

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName caseInsensitiveCompare:@"string-array"] == 0) {
        inStringArrayTag = YES;
        self.stringArrayNameAttr = [attributeDict valueForKey:@"name"] ;
        
    }
    if ([elementName caseInsensitiveCompare:@"item"] == 0 ) {
        inItemTag = YES;
    }
    
    
    NSLog(@"didStartElement --> %@", elementName);
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *trimStr = [string stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( trimStr == nil || [trimStr isEqualToString:@""]){
        return;
    }
    
    NSLog(@"foundCharacters --> %@", string);
    if (inStringArrayTag && inItemTag) {
        if ([self.stringArrayNameAttr  isEqualToString:@"red_inners_loc_names"]) {
            [self.trailNames addObject:string];
            
        }
        if ([self.stringArrayNameAttr  isEqualToString:@"red_inners_loc_coords"]) {
            [self.trailLocations addObject:string];
            
        }
        
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement   --> %@", elementName);
    if ([elementName caseInsensitiveCompare:@"string-array"] == 0) {
        inStringArrayTag = NO;
    }
    if ([elementName caseInsensitiveCompare:@"item"] == 0) {
        inItemTag = NO;
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidEndDocument");
}
@end
