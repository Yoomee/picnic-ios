//
//  Tag.m
//  Picnic
//
//  Created by Matthew Atkins on 08/09/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import "Tag.h"
#import "ConferenceSession.h"


@implementation Tag
@dynamic colorB;
@dynamic name;
@dynamic colorG;
@dynamic colorR;
@dynamic uid;
@dynamic conferenceSessions;

- (void)addConferenceSessionsObject:(ConferenceSession *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"conferenceSessions"] addObject:value];
    [self didChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeConferenceSessionsObject:(ConferenceSession *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"conferenceSessions"] removeObject:value];
    [self didChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addConferenceSessions:(NSSet *)value {    
    [self willChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"conferenceSessions"] unionSet:value];
    [self didChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeConferenceSessions:(NSSet *)value {
    [self willChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"conferenceSessions"] minusSet:value];
    [self didChangeValueForKey:@"conferenceSessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
