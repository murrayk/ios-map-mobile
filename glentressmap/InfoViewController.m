//
//  InfoViewController.m
//  glentressmap
//
//  Created by murrayhking on 19/07/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import "InfoViewController.h"
#import "IntroPageVC.h"
#import "AppDelegate.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
- (IBAction)showHOme:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 3. Create vc
    IntroPageVC *tutorialViewController = [storyboard instantiateViewControllerWithIdentifier:@"intro"];
    // 4. Set as root
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = tutorialViewController;

}

-(void) showHome{
    
}

@end
