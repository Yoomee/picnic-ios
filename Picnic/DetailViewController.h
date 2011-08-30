//
//  DetailViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConferenceSession.h"
#import "Venue.h"
#import "Member.h"
#import "SpeakerThumbnail.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate> {
    UILabel *_venueName;
    UITextView *_sessionText;
    UILabel *_sessionTime;
    UILabel *_sessionSpeakers;
    UIScrollView *_contentView;
    UIImageView *_welcomeView;
}
@property (nonatomic, retain) UIImageView *welcomeView;
@property (nonatomic, retain) IBOutlet UIScrollView *contentView;
@property (retain, nonatomic) ConferenceSession *conferenceSession;
@property (retain, nonatomic) IBOutlet UILabel *sessionName;
@property (retain, nonatomic) IBOutlet UILabel *sessionSpeakers;

@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *venueName;
@property (nonatomic, retain) IBOutlet UITextView *sessionText;
@property (nonatomic, retain) IBOutlet UILabel *sessionTime;

-(void) resizeSessionTextAndContentView;
-(void) showWelcome:(UIInterfaceOrientation)interfaceOrientation;
-(void) reloadData;

@end
