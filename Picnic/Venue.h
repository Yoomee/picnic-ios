//
//  Venue.h
//  Picnic
//
//  Created by Matthew Atkins on 22/07/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConferenceSession;

@interface Venue : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *conferenceSessions;
@end

@interface Venue (CoreDataGeneratedAccessors)
- (void)addConferenceSessionsObject:(ConferenceSession *)value;
- (void)removeConferenceSessionsObject:(ConferenceSession *)value;
- (void)addConferenceSessions:(NSSet *)value;
- (void)removeConferenceSessions:(NSSet *)value;

@end
