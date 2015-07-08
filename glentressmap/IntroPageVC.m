//
//  IntroPageVC.m
//  glentressmap
//
//  Created by murray king on 06/07/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "IntroPageVC.h"

@implementation IntroPageVC
- (IBAction)go:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                     bundle: nil];
 
UISplitViewController *split = [mainStoryboard instantiateViewControllerWithIdentifier:@"split"];
self.view.window.rootViewController = split;

}

@end
