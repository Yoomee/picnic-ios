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

@synthesize sessionItem = _sessionItem;


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
    float colorR = [[self.sessionItem valueForKey:@"colorR"] floatValue];
    float colorG = [[self.sessionItem valueForKey:@"colorG"] floatValue];
    float colorB = [[self.sessionItem valueForKey:@"colorB"] floatValue];
    UIColor *color = [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:1.0];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    //Define a rectangle
    CGContextAddRect(context, CGRectMake(0.0, 0.0, 8.0, 73.0));     //X, Y, Width, Height
    //Draw it
    CGContextFillPath(context);
}

- (void)setSessionItem:(NSManagedObject *)newSessionItem
{
    if (_sessionItem != newSessionItem) {
        _sessionItem = newSessionItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.sessionItem) {        
        self.sessionName.text = [self.sessionItem valueForKey:@"name"];
        self.venueName.text = [[self.sessionItem valueForKey:@"venue"] name];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"hh:mm"];
        NSString *dateString1 = [dateFormatter stringFromDate:[self.sessionItem valueForKey:@"startsAt"]];
        [dateFormatter setDateFormat:@"hh:mm"];
        NSString *dateString2 = [dateFormatter stringFromDate:[self.sessionItem valueForKey:@"endsAt"]];
        NSString *dateString = [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
        self.sessionTime.text = dateString;
        
    }
}

@end
