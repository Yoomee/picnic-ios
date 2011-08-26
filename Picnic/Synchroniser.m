//
//  Syncroniser.m
//  Picnic
//
//  Created by Matthew Atkins on 25/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "Synchroniser.h"


@implementation Synchroniser

+(void)getURL
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *progVersion = [prefs stringForKey:@"programVersion"];
    NSString *urlString = [NSString  stringWithFormat:@"http://10.0.1.5:3000/api/program/%@",progVersion];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];    
}

+ (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
}

+ (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}

@end
