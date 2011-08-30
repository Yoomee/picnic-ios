//
//  ConferenceSession.h
//  Picnic
//
//  Created by Matthew Atkins on 01/08/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member, Venue;

@interface ConferenceSession : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * uid;
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
@property (nonatomic, retain) NSSet *speakers;
@end

@interface ConferenceSession (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(Member *)value;
- (void)removeSpeakersObject:(Member *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

-(NSString *)dateString;
-(NSString *)timeString;
-(NSString *)speakersString;
-(UIColor *)color;

@end
