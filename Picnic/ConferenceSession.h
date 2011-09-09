//
//  ConferenceSession.h
//  Picnic
//
//  Created by Matthew Atkins on 08/09/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member, Tag, Venue;

@interface ConferenceSession : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * colorB;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * colorG;
@property (nonatomic, retain) NSNumber * colorR;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSDate * endsAt;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * attending;
@property (nonatomic, retain) NSNumber * syncedAttending;
@property (nonatomic, retain) NSDate * startsAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* tags;
@property (nonatomic, retain) NSSet* speakers;
@property (nonatomic, retain) Venue * venue;

-(NSString *)dateString;
-(NSString *)timeString;
-(NSString *)speakersString;
-(UIColor *)color;

- (void)addSpeakersObject:(Member *)value;
- (void)addTagsObject:(Tag *)value;
- (BOOL)mainTagIs:(Tag *)tag;

@end
