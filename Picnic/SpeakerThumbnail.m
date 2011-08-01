//
//  SpeakerThumbnail.m
//  Picnic
//
//  Created by Matthew Atkins on 01/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "SpeakerThumbnail.h"

@implementation SpeakerThumbnail
@synthesize image;
@synthesize forenameLabel;
@synthesize surnameLabel;
@synthesize member = _member;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMember:(Member *)newMember
{
    if (_member != newMember) {
        _member = newMember;

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.member) {        
        self.forenameLabel.text = [self.member forename];
        self.surnameLabel.text = [self.member surname];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
