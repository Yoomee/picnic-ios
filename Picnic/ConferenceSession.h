//
//  ConferenceSession.h
//  Picnic
//
//  Created by Matthew Atkins on 22/07/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Venue.h"


@interface ConferenceSession : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * colorB;
@property (nonatomic, retain) NSDate * endsAt;
@property (nonatomic, retain) NSNumber * colorG;
@property (nonatomic, retain) NSNumber * colorR;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSDate * startsAt;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Venue *venue;

-(NSString *)dateString;
-(NSString *)timeString;

@end
