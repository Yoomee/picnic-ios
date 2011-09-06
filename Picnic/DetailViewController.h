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
    UIBarButtonItem *_attendingToggleButton;
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
@property (nonatomic, retain) IBOutlet UIBarButtonItem *attendingToggleButton;

-(void) resizeSessionTextAndContentView;
-(void) showWelcome:(UIInterfaceOrientation)interfaceOrientation;
-(void) updateSelected:(BOOL)selectFirst;
- (IBAction)didPressAttendingToggleButton:(id)sender;

@end
