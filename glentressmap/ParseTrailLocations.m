//
//  ParseTrailLocations.m
//  glentressmap
//
//  Created by murray king on 03/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "ParseTrailLocations.h"

#import "TrailNameAndLocation.h"
@interface ParseTrailLocations ()<NSXMLParserDelegate>{
    BOOL inStringArrayTag;
    BOOL inItemTag;
    
}
@property(nonatomic, strong) NSString * currentStringArrayNameAttr;
@property(nonatomic, strong) NSString * stringArrayNameAttr;
@property(nonatomic, strong) NSMutableArray * trailNames;
@property(nonatomic, strong) NSMutableArray * trailLocations;


@end


@implementation ParseTrailLocations


- (NSArray *)parseXmlFile:(NSString *)xmlFile withBaseStringArrayNameAttr:(NSString *)stringArrayNameAttr{

    
    NSError *error = nil;
    self.trailNames = [[NSMutableArray alloc] init];
    self.trailLocations = [[NSMutableArray alloc] init];
    self.trailNamesWithLocations = [[NSMutableArray alloc] init];
    self.stringArrayNameAttr =  stringArrayNameAttr;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:xmlFile ofType:@"xml"];
    
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
    
    for (int i =0, j = self.trailNames.count; i < j ; i++) {
        TrailNameAndLocation *t = [[TrailNameAndLocation alloc] initWithTrailName:self.trailNames[i] andLocation:self.trailLocations[i]];
        [self.trailNamesWithLocations addObject:t];
    }
    
    return self.trailNamesWithLocations;

}

#pragma mark - xml sax parser

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName caseInsensitiveCompare:@"string-array"] == 0) {
        inStringArrayTag = YES;
        self.currentStringArrayNameAttr = [attributeDict valueForKey:@"name"] ;
        
    }
    if ([elementName caseInsensitiveCompare:@"item"] == 0 ) {
        inItemTag = YES;
    }
    
    
    //NSLog(@"didStartElement --> %@", elementName);
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *trimStr = [string stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( trimStr == nil || [trimStr isEqualToString:@""]){
        return;
    }
    
    
    NSLog(@"foundCharacters --> %@", string);
    if (inStringArrayTag && inItemTag) {
        NSString *trailName = [self.stringArrayNameAttr stringByAppendingString:@"names"];
        if ([self.currentStringArrayNameAttr  isEqualToString:trailName]) {
            [self.trailNames addObject:string];
            
        }
        NSString *trailCoord = [self.stringArrayNameAttr stringByAppendingString:@"coords"];
        if ([self.currentStringArrayNameAttr  isEqualToString:trailCoord]) {
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
