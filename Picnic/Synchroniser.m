//
//  Syncroniser.m
//  Picnic
//
//  Created by Matthew Atkins on 25/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "Synchroniser.h"
#import "SBJson.h"
#import "Venue.h"
#import "PicnicAppDelegate.h"
#import "RootViewController.h"
#import "Member.h"
#import "Tag.h"


@implementation Synchroniser
@synthesize managedObjectContext = __managedObjectContext;

-(void)startUpdate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *progVersion = [defaults stringForKey:@"programVersion"];
    // NSString *urlString = [NSString  stringWithFormat:@"http://10.0.1.5:3000/api/program/%@",progVersion];
    NSString *apiKey = [defaults stringForKey:@"apiKey"];
    NSString *urlString;
    if (apiKey.length == 0) {
        urlString = [NSString stringWithFormat:@"http://10.0.1.5:3000/api/program/%@",progVersion];
    } else {
        NSString *myProgramVersion = [defaults stringForKey:@"myProgramVersion"];
        urlString = [NSString stringWithFormat:@"http://10.0.1.5:3000/api/program/%@?api_key=%@&my_program_version=%@",progVersion, apiKey, myProgramVersion];
    }
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setPersistentConnectionTimeoutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];    
}

-(void)updateConferenceSessions:(NSMutableArray *)sessions withMySessionIds:(NSArray *) sessionIds {    
    [sessions sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease]]];
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *venues = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableDictionary *venueDict = [[NSMutableDictionary alloc] initWithCapacity:[venues count]];

    [venues enumerateObjectsUsingBlock:^(Venue *venue, NSUInteger idx, BOOL *stop) { 
        [venueDict setObject:venue forKey:venue.uid];
    }];
    
    entity = [NSEntityDescription entityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    error = nil;
    NSArray *existingSessions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [existingSessions enumerateObjectsUsingBlock:^(ConferenceSession *eSession, NSUInteger idx, BOOL *stop) { 
        NSMutableDictionary *nSession = [NSMutableDictionary dictionary];
        int eSessionId = [eSession.uid intValue];
        int nSessionId;
        if([sessions count] > 0){
            nSession = [sessions objectAtIndex:0];
            nSessionId = [[nSession objectForKey:@"id"] intValue];
        } else {
            nSessionId = eSessionId + 1;
        }
        while ((eSessionId > nSessionId) && ([sessions count] > 0)) {
            ConferenceSession *newSession = (ConferenceSession *)[NSEntityDescription insertNewObjectForEntityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
            [newSession setUid:[NSNumber numberWithInt:nSessionId]];
            [newSession setName:[nSession objectForKey:@"name"]];
            [newSession setText:[nSession objectForKey:@"text"]];
            [newSession setDay:[NSNumber numberWithInt:[[nSession objectForKey:@"day"] intValue]]];
            [newSession setColorR:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_r"] floatValue]]];
            [newSession setColorG:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_g"] floatValue]]];
            [newSession setColorB:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_b"] floatValue]]];
            [newSession setStartsAt:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"starts_at"] intValue]]];
            [newSession setEndsAt:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"ends_at"] intValue]]];
            [newSession setTimeStamp:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"timestamp"] intValue]]];
            [(Venue *)[venueDict objectForKey:[NSNumber numberWithInt:[[nSession objectForKey:@"venue_id"] intValue]]] addConferenceSessionsObject:newSession];
            [sessions removeObjectAtIndex:0];
            if ([sessions count] > 0){
                nSession = [sessions objectAtIndex:0];
                nSessionId = [[nSession objectForKey:@"id"] intValue];
            }
        }
        if (eSessionId < nSessionId){
            [self.managedObjectContext deleteObject:eSession];
        } else if (eSessionId == nSessionId){
            [eSession setUid:[NSNumber numberWithInt:nSessionId]];
            [eSession setName:[nSession objectForKey:@"name"]];
            [eSession setText:[nSession objectForKey:@"text"]];
            [eSession setDay:[NSNumber numberWithInt:[[nSession objectForKey:@"day"] intValue]]];
            [eSession setColorR:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_r"] floatValue]]];
            [eSession setColorG:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_g"] floatValue]]];
            [eSession setColorB:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_b"] floatValue]]];
            [eSession setStartsAt:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"starts_at"] intValue]]];
            [eSession setEndsAt:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"ends_at"] intValue]]];
            [eSession setTimeStamp:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"timestamp"] intValue]]];
            [eSession setSpeakers:NULL];
            [(Venue *)[venueDict objectForKey:[NSNumber numberWithInt:[[nSession objectForKey:@"venue_id"] intValue]]] addConferenceSessionsObject:eSession];
            if([sessions count] > 0){
                [sessions removeObjectAtIndex:0];
            }
        }
    }];
    
    [sessions enumerateObjectsUsingBlock:^(NSDictionary *nSession, NSUInteger idx, BOOL *stop) { 
        ConferenceSession *newSession = (ConferenceSession *)[NSEntityDescription insertNewObjectForEntityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
        [newSession setUid:[NSNumber numberWithInt:[[nSession objectForKey:@"id"] intValue]]];
        [newSession setName:[nSession objectForKey:@"name"]];
        [newSession setText:[nSession objectForKey:@"text"]];
        [newSession setDay:[NSNumber numberWithInt:[[nSession objectForKey:@"day"] intValue]]];
        [newSession setColorR:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_r"] floatValue]]];
        [newSession setColorG:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_g"] floatValue]]];
        [newSession setColorB:[NSNumber numberWithFloat:[[nSession objectForKey:@"color_b"] floatValue]]];
        [newSession setStartsAt:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"starts_at"] intValue]]];
        [newSession setEndsAt:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"ends_at"] intValue]]];
        [newSession setTimeStamp:[NSDate dateWithTimeIntervalSince1970:[[nSession objectForKey:@"timestamp"] intValue]]];
        [(Venue *)[venueDict objectForKey:[NSNumber numberWithInt:[[nSession objectForKey:@"venue_id"] intValue]]] addConferenceSessionsObject:newSession];
    }];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: updating sessions");
    }
    [venueDict release];
    [sortDescriptor release];
    [sortDescriptors release];
    [fetchRequest release];
}

-(void)updateMembers:(NSMutableArray *)members{    
    [members sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease]]];
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *sessions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableDictionary *sessionDict = [[NSMutableDictionary alloc] initWithCapacity:[sessions count]];
    
    [sessions enumerateObjectsUsingBlock:^(ConferenceSession *session, NSUInteger idx, BOOL *stop) { 
        [sessionDict setObject:session forKey:session.uid];
    }];
    
    entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    error = nil;
    NSArray *existingMembers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [existingMembers enumerateObjectsUsingBlock:^(Member *eMember, NSUInteger idx, BOOL *stop) { 
        int eMemberId = [eMember.uid intValue];
        int nMemberId;
        NSDictionary *nMember = [NSMutableDictionary dictionary];
        if([members count] > 0){
            nMember = [members objectAtIndex:0];
            nMemberId = [[nMember objectForKey:@"id"] intValue];
        } else {
            nMemberId = eMemberId + 1;
        }
        while ((eMemberId > nMemberId) && ([members count] > 0)) {
            Member *newMember = (Member *)[NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:self.managedObjectContext];
            [newMember setUid:[NSNumber numberWithInt:nMemberId]];
            [newMember setForename:[nMember objectForKey:@"forename"]];
            [newMember setSurname:[nMember objectForKey:@"surname"]];
            [newMember setBio:[nMember objectForKey:@"bio"]];            
            [newMember setIsSpeaker:[NSNumber numberWithInt:[[nMember objectForKey:@"is_speaker"] intValue]]];
            NSArray *sessionIds = (NSArray *)[nMember objectForKey:@"session_ids"];
            [sessionIds enumerateObjectsUsingBlock:^(NSNumber *sessionId, NSUInteger idx, BOOL *stop) {
                [(ConferenceSession *)[sessionDict objectForKey:sessionId] addSpeakersObject:newMember];
            }];
            [members removeObjectAtIndex:0];
            nMember = [members objectAtIndex:0];
            nMemberId = [[nMember objectForKey:@"id"] intValue];
        }
        if (eMemberId < nMemberId){
            [self.managedObjectContext deleteObject:eMember];
        } else if (eMemberId == nMemberId){
            [eMember setUid:[NSNumber numberWithInt:nMemberId]];
            [eMember setForename:[nMember objectForKey:@"forename"]];
            [eMember setSurname:[nMember objectForKey:@"surname"]];
            [eMember setBio:[nMember objectForKey:@"bio"]];            
            [eMember setIsSpeaker:[NSNumber numberWithInt:[[nMember objectForKey:@"is_speaker"] intValue]]];
            NSArray *sessionIds = (NSArray *)[nMember objectForKey:@"session_ids"];
            [sessionIds enumerateObjectsUsingBlock:^(NSNumber *sessionId, NSUInteger idx, BOOL *stop) {
                [(ConferenceSession *)[sessionDict objectForKey:sessionId] addSpeakersObject:eMember];
            }];
            if([members count] > 0){
                [members removeObjectAtIndex:0];
            }
        }
    }];
    
    [members enumerateObjectsUsingBlock:^(NSDictionary *nMember, NSUInteger idx, BOOL *stop) { 
        Member *newMember = (Member *)[NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:self.managedObjectContext];
        [newMember setUid:[NSNumber numberWithInt:[[nMember objectForKey:@"uid"] intValue]]];
        [newMember setForename:[nMember objectForKey:@"forename"]];
        [newMember setSurname:[nMember objectForKey:@"surname"]];
        [newMember setBio:[nMember objectForKey:@"bio"]];            
        [newMember setIsSpeaker:[NSNumber numberWithInt:[[nMember objectForKey:@"is_speaker"] intValue]]];
        NSArray *sessionIds = (NSArray *)[nMember objectForKey:@"session_ids"];
        [sessionIds enumerateObjectsUsingBlock:^(NSNumber *sessionId, NSUInteger idx, BOOL *stop) {
            [(ConferenceSession *)[sessionDict objectForKey:sessionId] addSpeakersObject:newMember];
        }];
    }];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: updating members");
    }
    
    [sessionDict release];
    [sortDescriptor release];
    [sortDescriptors release];
    [fetchRequest release];
}


-(void)updateVenues:(NSMutableArray *)venues{    
    [venues sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease]]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *existingVenues = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [existingVenues enumerateObjectsUsingBlock:^(Venue *eVenue, NSUInteger idx, BOOL *stop) { 
        int eVenueId = [eVenue.uid intValue];
        int nVenueId;
        NSDictionary *nVenue = [NSMutableDictionary dictionary];
        if([venues count] > 0){
            nVenue = [venues objectAtIndex:0];
            nVenueId = [[nVenue objectForKey:@"id"] intValue];
        } else {
            nVenueId = eVenueId + 1;
        }
        while ((eVenueId > nVenueId) && ([venues count] > 0)) {
            Venue *newVenue = (Venue *)[NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
            [newVenue setUid:[NSNumber numberWithInt:nVenueId]];
            [newVenue setName:[nVenue objectForKey:@"name"]];
            [newVenue setOrder:[NSNumber numberWithInt:[[nVenue objectForKey:@"order"] intValue]]];
            [venues removeObjectAtIndex:0];
            nVenue = [venues objectAtIndex:0];
            nVenueId = [[nVenue objectForKey:@"id"] intValue];
        }
        if (eVenueId < nVenueId){
            [self.managedObjectContext deleteObject:eVenue];
        } else if (eVenueId == nVenueId){
            [eVenue setUid:[NSNumber numberWithInt:nVenueId]];
            [eVenue setName:[nVenue objectForKey:@"name"]];
            [eVenue setOrder:[NSNumber numberWithInt:[[nVenue objectForKey:@"order"] intValue]]];
            if([venues count] > 0){
                [venues removeObjectAtIndex:0];
            }
        }
    }];
    
    [venues enumerateObjectsUsingBlock:^(NSDictionary *nVenue, NSUInteger idx, BOOL *stop) { 
        Venue *newVenue = (Venue *)[NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
        [newVenue setUid:[NSNumber numberWithInt:[[nVenue objectForKey:@"id"] intValue]]];
        [newVenue setName:[nVenue objectForKey:@"name"]];
        [newVenue setOrder:[NSNumber numberWithInt:[[nVenue objectForKey:@"order"] intValue]]];
    }];

    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: updating venues");
    }
    
    [sortDescriptor release];
    [sortDescriptors release];
    [fetchRequest release];
}

-(void)updateTags:(NSMutableArray *)tags{
    [tags sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease]]];
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *sessions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableDictionary *sessionDict = [[NSMutableDictionary alloc] initWithCapacity:[sessions count]];
    
    [sessions enumerateObjectsUsingBlock:^(ConferenceSession *session, NSUInteger idx, BOOL *stop) { 
        [sessionDict setObject:session forKey:session.uid];
    }];
    
    entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    error = nil;
    NSArray *existingTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [existingTags enumerateObjectsUsingBlock:^(Tag *eTag, NSUInteger idx, BOOL *stop) { 
        int eTagId = [eTag.uid intValue];
        int nTagId;
        NSDictionary *nTag = [NSMutableDictionary dictionary];
        if([tags count] > 0){
            nTag = [tags objectAtIndex:0];
            nTagId = [[nTag objectForKey:@"id"] intValue];
        } else {
            nTagId = eTagId + 1;
        }
        while ((eTagId > nTagId) && ([tags count] > 0)) {
            Tag *newTag = (Tag *)[NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
            [newTag setUid:[NSNumber numberWithInt:nTagId]];
            [newTag setName:[nTag objectForKey:@"name"]];
            [newTag setColorR:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_r"] floatValue]]];
            [newTag setColorG:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_g"] floatValue]]];
            [newTag setColorB:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_b"] floatValue]]];
            NSArray *sessionIds = (NSArray *)[nTag objectForKey:@"session_ids"];
            [sessionIds enumerateObjectsUsingBlock:^(NSNumber *sessionId, NSUInteger idx, BOOL *stop) {
                [(ConferenceSession *)[sessionDict objectForKey:sessionId] addTagsObject:newTag];
            }];
            [tags removeObjectAtIndex:0];
            nTag = [tags objectAtIndex:0];
            nTagId = [[nTag objectForKey:@"id"] intValue];
        }
        if (eTagId < nTagId){
            [self.managedObjectContext deleteObject:eTag];
        } else if (eTagId == nTagId){
            [eTag setUid:[NSNumber numberWithInt:nTagId]];
            [eTag setName:[nTag objectForKey:@"name"]];
            [eTag setColorR:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_r"] floatValue]]];
            [eTag setColorG:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_g"] floatValue]]];
            [eTag setColorB:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_b"] floatValue]]];
            NSArray *sessionIds = (NSArray *)[nTag objectForKey:@"session_ids"];
            [sessionIds enumerateObjectsUsingBlock:^(NSNumber *sessionId, NSUInteger idx, BOOL *stop) {
                [(ConferenceSession *)[sessionDict objectForKey:sessionId] addTagsObject:eTag];
            }];
            if([tags count] > 0){
                [tags removeObjectAtIndex:0];
            }
        }
    }];
    
    [tags enumerateObjectsUsingBlock:^(NSDictionary *nTag, NSUInteger idx, BOOL *stop) { 
        Tag *newTag = (Tag *)[NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
        [newTag setUid:[NSNumber numberWithInt:[[nTag objectForKey:@"id"] intValue]]];
        [newTag setName:[nTag objectForKey:@"name"]];
        [newTag setColorR:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_r"] floatValue]]];
        [newTag setColorG:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_g"] floatValue]]];
        [newTag setColorB:[NSNumber numberWithFloat:[[nTag objectForKey:@"color_b"] floatValue]]];
        NSArray *sessionIds = (NSArray *)[nTag objectForKey:@"session_ids"];
        [sessionIds enumerateObjectsUsingBlock:^(NSNumber *sessionId, NSUInteger idx, BOOL *stop) {
            [(ConferenceSession *)[sessionDict objectForKey:sessionId] addTagsObject:newTag];
        }];
    }];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: updating tags");
    }
    [sessionDict release];
    [sortDescriptor release];
    [sortDescriptors release];
    [fetchRequest release];
}

-(void)updateMySessions:(NSArray *)sessionIds {
    NSMutableDictionary *mySessionIds = [[NSMutableDictionary alloc] initWithCapacity:[sessionIds count]];
    [sessionIds enumerateObjectsUsingBlock:^(NSString *sessionId, NSUInteger idx, BOOL *stop) {
        [mySessionIds setValue:@"1" forKey:[NSString stringWithFormat:@"%@",sessionId]];
    }];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *existingSessions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [existingSessions enumerateObjectsUsingBlock:^(ConferenceSession *eSession, NSUInteger idx, BOOL *stop) {
        if ([(NSString *)[mySessionIds valueForKey:[NSString stringWithFormat:@"%@",eSession.uid]] isEqualToString:@"1"]) {
            [eSession setAttending:[NSNumber numberWithInt:1]];
        } else {
            [eSession setAttending:[NSNumber numberWithInt:0]];
        }
    }];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: updating attending sessions");
    }
    [fetchRequest release];
    [mySessionIds release];
}

-(void)updateProgram:(NSDictionary *)data{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    if ([data objectForKey:@"version"]) {
        [self updateVenues:[data objectForKey:@"venues"]];
        [self updateConferenceSessions:[data objectForKey:@"conference_sessions"] withMySessionIds:[data objectForKey:@"my_session_ids"]];            
        [self updateTags:[data objectForKey:@"tags"]];
        [self updateMembers:[data objectForKey:@"members"]];
        [defaults setObject:[data objectForKey:@"version"] forKey:@"programVersion"];
    }
    if ([data objectForKey:@"my_program_version"]) {
        [self updateMySessions:[data objectForKey:@"my_session_ids"]];
        [defaults setObject:[data objectForKey:@"my_program_version"] forKey:@"myProgramVersion"];
    }
    [defaults synchronize];
    [(PicnicAppDelegate *)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(didFinishUpdate)
                                           withObject:nil
                                        waitUntilDone:YES];
    [pool release];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id object = [parser objectWithData:[request responseData]];
    if (object) {
        NSDictionary *data = (NSDictionary *)object; 
        int update = [[data objectForKey:@"update"] intValue];
        if (update==1) {            
            [(PicnicAppDelegate *)[[UIApplication sharedApplication] delegate] willStartUpdate];
            [self performSelectorInBackground:@selector(updateProgram:) withObject:data];
        }
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"An error occurred: %@", parser.error]);
    }
    [parser release];
}

             
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}

-(void) setAttending:(NSNumber *)attending forConferenceSession:(ConferenceSession *)conferenceSession {
    [conferenceSession setAttending:attending];
    PicnicAppDelegate *appDelegate = (PicnicAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"ERROR: updating sessions");
    }
}

-(void)mergeChanges:(NSNotification *)notification{
    PicnicAppDelegate *appDelegate = (PicnicAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate managedObjectContext];
    
    // Merge changes into the main context on the main thread
    [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES]; 
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    PicnicAppDelegate *appDelegate = (PicnicAppDelegate *)[[UIApplication sharedApplication] delegate];
    [__managedObjectContext setPersistentStoreCoordinator:[[appDelegate managedObjectContext] persistentStoreCoordinator]];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
    [nc addObserver:self
           selector:@selector(mergeChanges:)
               name:NSManagedObjectContextDidSaveNotification
             object:__managedObjectContext];
    return __managedObjectContext;
}

- (void)dealloc
{   
    [__managedObjectContext release];
    [super dealloc];
}

@end
