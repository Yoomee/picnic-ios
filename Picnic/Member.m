//
//  Member.m
//  Picnic
//
//  Created by Matthew Atkins on 01/08/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import "Member.h"
#import "ConferenceSession.h"


@implementation Member
@dynamic uid;
@dynamic forename;
@dynamic surname;
@dynamic bio;
@dynamic isSpeaker;
@dynamic sessionsSpeakingAt;

-(NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.forename, self.surname];
}

@end
