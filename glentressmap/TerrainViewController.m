//
//  TerrainViewController.m
//  glentressmap
//
//  Created by murray on 17/05/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "TerrainViewController.h"



@interface TerrainViewController ()<NSXMLParserDelegate>{
    BOOL inStringArrayTag;
    BOOL inItemTag;
    
}
@property(nonatomic, strong) NSString * stringArrayNameAttr;
@property(nonatomic, strong) NSMutableArray * redTrailElevations;
@property(nonatomic, strong) NSMutableArray * downHillTrailElevations;
-(void) parseXml;
@end



@implementation TerrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self parseXml];
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
@end
