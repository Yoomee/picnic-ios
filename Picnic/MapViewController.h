//
//  MapViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 06/09/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"


@interface MapViewController : DetailViewController {
    UIScrollView *scrollView;
    UIImageView *mapView;
}

- (IBAction)toggleFullScreen:(id)sender;

-(void) showPopoverWithPopoverController:(UIPopoverController *)pc andBarButtonItem:(UIBarButtonItem *)barButtonItem;
-(void) invalidatePopover;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *mapView;
@property (assign, nonatomic) BOOL fullScreen;

@end
