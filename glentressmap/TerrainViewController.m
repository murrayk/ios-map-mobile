//
//  TerrainViewController.m
//  glentressmap
//
//  Created by murray on 17/05/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "TerrainViewController.h"
#import "BEMSimpleLineGraphView.h"


@interface TerrainViewController ()<NSXMLParserDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>{
    BOOL inStringArrayTag;
    BOOL inItemTag;
    
}
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property(nonatomic, strong) NSString * stringArrayNameAttr;
@property(nonatomic, strong) NSMutableArray * redTrailElevations;
@property(nonatomic, strong) NSMutableArray * downHillTrailElevations;
@property(nonatomic, strong) NSMutableArray * xLabs;
@property(nonatomic, strong) NSMutableSet *usedXLabels;


-(void) parseXml;

@end



@implementation TerrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self parseXml];
    
    

    self.usedXLabels = [[NSMutableSet alloc]init];
    
    self.xLabs = [[NSMutableArray alloc] init];
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code.
     BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
     myGraph.delegate = self;
     myGraph.dataSource = self;
     [self.view addSubview:myGraph]; */
    
    // Customization of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.myGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorLine = [UIColor whiteColor];
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.colorYaxisLabel = [UIColor whiteColor];
    self.myGraph.widthLine = 3.0;
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableBezierCurve = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    


}


-(void) parseXml{
    
    NSError *error = nil;
    self.redTrailElevations = [[NSMutableArray alloc] init];
    self.downHillTrailElevations = [[NSMutableArray alloc] init];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"elevations" ofType:@"xml"];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
        if ([self.stringArrayNameAttr  isEqualToString:@"inners_xc"]) {
            [self.redTrailElevations addObject:string];
            
        }
        if ([self.stringArrayNameAttr  isEqualToString:@"inners_downhill"]) {
            [self.downHillTrailElevations addObject:string];
            
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


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.redTrailElevations count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSString *coord = self.redTrailElevations[index];
    NSArray *coords = [coord componentsSeparatedByString:@","];

    CGFloat y =  [coords[1] floatValue];
    return  y;
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *coord = self.redTrailElevations[index];
    NSArray *coords = [coord componentsSeparatedByString:@","];
    CGFloat x = roundf([coords[0] floatValue]);
    NSString *xAxisLabel = [@(x) stringValue];
    //return xAxisLabel;
    
    if (![self.usedXLabels containsObject:xAxisLabel]) {
        [self.usedXLabels addObject:xAxisLabel];
        self.xLabs[index] = xAxisLabel;
    }
    return self.xLabs[index];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {

}



- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {

}

@end
