//
//  MapViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 06/09/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "ConferenceSession.h"
#import "Venue.h"
#import "Member.h"
#import "SpeakerThumbnail.h"

@interface MapViewController : DetailViewController {
    UIScrollView *scrollView;
    UIImageView *mapView;
}

- (IBAction)toggleFullScreen:(id)sender;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *mapView;
@property (assign, nonatomic) BOOL fullScreen;

@end
