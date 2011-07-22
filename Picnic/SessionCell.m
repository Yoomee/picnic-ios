//
//  SessionCell.m
//  Picnic
//
//  Created by Matthew Atkins on 21/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "SessionCell.h"

@implementation SessionCell
@synthesize sessionName;
@synthesize venueName;
@synthesize sessionTime;

@synthesize conferenceSession = _conferenceSession;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) drawRect:(CGRect)rect
{
    //Get the CGContext from this view
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw a rectangle
    float colorR = [self.conferenceSession.colorR floatValue];
    float colorB = [self.conferenceSession.colorB floatValue];
    float colorG = [self.conferenceSession.colorG floatValue];
    UIColor *color = [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:1.0];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    //Define a rectangle
    CGContextAddRect(context, CGRectMake(0.0, 0.0, 8.0, 73.0));     //X, Y, Width, Height
    //Draw it
    CGContextFillPath(context);
}

- (void)setConferenceSession:(ConferenceSession *)newConferenceSession
{
    if (_conferenceSession != newConferenceSession) {
        _conferenceSession = newConferenceSession;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.conferenceSession) {        
        self.sessionName.text = [self.conferenceSession name];
        self.venueName.text = [self.conferenceSession.venue name];
        self.sessionTime.text = [self.conferenceSession timeString];
    }
}

@end
