//
//  Member.h
//  Picnic
//
//  Created by Matthew Atkins on 01/08/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConferenceSession;

@interface Member : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * forename;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * isSpeaker;
@property (nonatomic, retain) NSSet *sessionsSpeakingAt;
@end

@interface Member (CoreDataGeneratedAccessors)
- (void)addSessionsSpeakingAtObject:(ConferenceSession *)value;
- (void)removeSessionsSpeakingAtObject:(ConferenceSession *)value;
- (void)addSessionsSpeakingAt:(NSSet *)value;
- (void)removeSessionsSpeakingAt:(NSSet *)value;

- (NSString *)fullName;

@end
