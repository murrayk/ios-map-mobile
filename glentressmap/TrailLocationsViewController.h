//
//  TrailLocationsViewController.h
//  glentressmap
//
//  Created by murray king on 14/05/2015.
//  Copyright (c) 2015 murray. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SecondViewControllerDelegate;

@interface TrailLocationsViewController : UITableViewController
@property (nonatomic,weak) id<SecondViewControllerDelegate> delegate;
@end

@protocol SecondViewControllerDelegate
- (void)secondViewControllerDidFinish:(TrailLocationsViewController*)secondViewController;
@end