//
//  Syncroniser.h
//  Picnic
//
//  Created by Matthew Atkins on 25/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface Synchroniser : NSObject {
}
-(void)startUpdate;
@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
