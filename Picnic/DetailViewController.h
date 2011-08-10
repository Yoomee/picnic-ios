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
@property (nonatomic, strong) UIImageView *welcomeView;
@property (nonatomic, strong) IBOutlet UIScrollView *contentView;
@property (strong, nonatomic) ConferenceSession *conferenceSession;
@property (strong, nonatomic) IBOutlet UILabel *sessionName;
@property (strong, nonatomic) IBOutlet UILabel *sessionSpeakers;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UILabel *venueName;
@property (nonatomic, strong) IBOutlet UITextView *sessionText;
@property (nonatomic, strong) IBOutlet UILabel *sessionTime;

-(void) resizeSessionTextAndContentView;
-(void) showWelcome;

@end
