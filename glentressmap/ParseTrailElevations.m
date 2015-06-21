//
//  ParseTrailElevations.m
//  glentressmap
//
//  Created by murray king on 03/06/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "ParseTrailElevations.h"


@interface ParseTrailElevations(){

    BOOL inStringArrayTag;
    BOOL inItemTag;
    
}

@property(nonatomic, strong) NSString * currentStringArrayNameAttr;
@property(nonatomic, strong) NSString * stringArrayNameAttr;

@property(nonatomic, strong) NSMutableArray * elevations;




@end

@implementation ParseTrailElevations



-(NSArray *) parseXmlFile:(NSString *)xmlFile withStringArrayNameAttr:(NSString *)stringArrayNameAttr {
    
    NSError *error = nil;
    self.elevations = [[NSMutableArray alloc] init];
    self.stringArrayNameAttr = stringArrayNameAttr;

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
    
    return self.elevations;
}


#pragma mark - xml sax parser

- (void) parserDidStartDocument:(NSXMLParser *)parser {
   // NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName caseInsensitiveCompare:@"string-array"] == 0) {
        inStringArrayTag = YES;
        self.currentStringArrayNameAttr = [attributeDict valueForKey:@"name"] ;
        
    }
    if ([elementName caseInsensitiveCompare:@"item"] == 0 ) {
        inItemTag = YES;
    }
    
    
   // NSLog(@"didStartElement --> %@", elementName);
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *trimStr = [string stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( trimStr == nil || [trimStr isEqualToString:@""]){
        return;
    }
    
    //NSLog(@"foundCharacters --> %@", string);
    if (inStringArrayTag && inItemTag) {
        if ([self.currentStringArrayNameAttr  isEqualToString:self.stringArrayNameAttr]) {
            [self.elevations addObject:string];
            
        }
        
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //NSLog(@"didEndElement   --> %@", elementName);
    if ([elementName caseInsensitiveCompare:@"string-array"] == 0) {
        inStringArrayTag = NO;
    }
    if ([elementName caseInsensitiveCompare:@"item"] == 0) {
        inItemTag = NO;
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    //NSLog(@"parserDidEndDocument");
}


@end
