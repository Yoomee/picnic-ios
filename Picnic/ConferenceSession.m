//
//  ConferenceSession.m
//  Picnic
//
//  Created by Matthew Atkins on 08/09/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import "ConferenceSession.h"
#import "Member.h"
#import "Tag.h"
#import "Venue.h"


@implementation ConferenceSession
@dynamic colorB;
@dynamic timeStamp;
@dynamic uid;
@dynamic colorG;
@dynamic colorR;
@dynamic day;
@dynamic endsAt;
@dynamic text;
@dynamic attending;
@dynamic startsAt;
@dynamic name;
@dynamic tags;
@dynamic speakers;
@dynamic venue;

-(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"eeee dd MMM HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Amsterdam"]];
    NSString *dateString1 = [dateFormatter stringFromDate:self.startsAt];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString2 = [dateFormatter stringFromDate:self.endsAt];
    [dateFormatter release];
    return [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
}

-(NSString *)timeString
{    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Amsterdam"]];
    NSString *dateString1 = [dateFormatter stringFromDate:self.startsAt];
    NSString *dateString2 = [dateFormatter stringFromDate:self.endsAt];
    [dateFormatter release];
    return [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
}

-(NSString *)speakersString
{    
    NSMutableArray *speakerNames = [[NSMutableArray alloc] init];
    NSSet *speakers = [self speakers];
    [speakers enumerateObjectsUsingBlock:^(Member *member, BOOL *stop) { 
        [speakerNames addObject:[member fullName]];
    }];
    [speakerNames sortUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *speakerNamesString = [NSString stringWithFormat:@"%@",[speakerNames componentsJoinedByString:@", "]];
    [speakerNames release];
    return speakerNamesString;
}

//-(NSString *)speakersString
//{    
//    NSMutableArray *tagNames = [[NSMutableArray alloc] init];
//    NSSet *tags = [self tags];
//    [tags enumerateObjectsUsingBlock:^(Tag *tag, BOOL *stop) { 
//        [tagNames addObject:tag.name];
//    }];
//    [tagNames sortUsingSelector:@selector(caseInsensitiveCompare:)];
//    NSString *tagNamesString = [NSString stringWithFormat:@"%@",[tagNames componentsJoinedByString:@", "]];
//    [tagNames release];
//    return tagNamesString;
//}

-(UIColor *)color
{
    float colorR = [self.colorR floatValue];
    float colorB = [self.colorB floatValue];
    float colorG = [self.colorG floatValue];
    return [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:1.0];
}

-(BOOL)mainTagIs:(Tag *)tag{
    return ([tag.colorR isEqualToNumber:self.colorR] && [tag.colorG isEqualToNumber:self.colorG] && [tag.colorB isEqualToNumber:self.colorB]);
}

- (void)addTagsObject:(Tag *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tags"] addObject:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTagsObject:(Tag *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tags"] removeObject:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTags:(NSSet *)value {    
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tags"] unionSet:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTags:(NSSet *)value {
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tags"] minusSet:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addSpeakersObject:(Member *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"speakers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"speakers"] addObject:value];
    [self didChangeValueForKey:@"speakers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSpeakersObject:(Member *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"speakers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"speakers"] removeObject:value];
    [self didChangeValueForKey:@"speakers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addSpeakers:(NSSet *)value {    
    [self willChangeValueForKey:@"speakers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"speakers"] unionSet:value];
    [self didChangeValueForKey:@"speakers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSpeakers:(NSSet *)value {
    [self willChangeValueForKey:@"speakers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"speakers"] minusSet:value];
    [self didChangeValueForKey:@"speakers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
