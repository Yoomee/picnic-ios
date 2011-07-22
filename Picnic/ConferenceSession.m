//
//  ConferenceSession.m
//  Picnic
//
//  Created by Matthew Atkins on 22/07/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import "ConferenceSession.h"


@implementation ConferenceSession
@dynamic colorB;
@dynamic endsAt;
@dynamic colorG;
@dynamic colorR;
@dynamic day;
@dynamic timeStamp;
@dynamic startsAt;
@dynamic text;
@dynamic name;
@dynamic venue;

-(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"dd MMM hh:mm"];
    NSString *dateString1 = [dateFormatter stringFromDate:self.startsAt];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *dateString2 = [dateFormatter stringFromDate:self.endsAt];
    return [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
}

-(NSString *)timeString
{    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *dateString1 = [dateFormatter stringFromDate:self.startsAt];
    NSString *dateString2 = [dateFormatter stringFromDate:self.endsAt];
    return [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
}



@end
