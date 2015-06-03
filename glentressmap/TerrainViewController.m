//
//  TerrainViewController.m
//  glentressmap
//
//  Created by murray on 17/05/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "TerrainViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "Route.h"

@interface TerrainViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>{

    
}
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

@end



@implementation TerrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

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



#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.route.elevations count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSString *coord = self.route.elevations[index];
    NSArray *coords = [coord componentsSeparatedByString:@","];

    CGFloat y =  [coords[1] floatValue];
    return  y;
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    int count = [self.route.elevations count];
    return count;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *coord = self.route.elevations[index];
    NSArray *coords = [coord componentsSeparatedByString:@","];
    CGFloat x = roundf([coords[0] floatValue]);
    NSString *xAxisLabel = [@(x) stringValue];
    //return xAxisLabel;

    return xAxisLabel;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {

}



- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {

}

@end
