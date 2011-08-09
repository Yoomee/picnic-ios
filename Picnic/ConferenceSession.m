//
//  ConferenceSession.m
//  Picnic
//
//  Created by Matthew Atkins on 01/08/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import "ConferenceSession.h"
#import "Member.h"
#import "Venue.h"


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
@dynamic speakers;

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

-(NSString *)speakersString
{    
    NSMutableArray *speakerNames = [[NSMutableArray alloc] init];
    NSSet *speakers = [self speakers];
    [speakers enumerateObjectsUsingBlock:^(Member *member, BOOL *stop) { 
        [speakerNames addObject:[member fullName]];
    }] ;
    return @"";//[NSString stringWithFormat:@"%@", speakerNames];
}

-(UIColor *)color
{
    float colorR = [self.colorR floatValue];
    float colorB = [self.colorB floatValue];
    float colorG = [self.colorG floatValue];
    return [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:1.0];
}

@end
