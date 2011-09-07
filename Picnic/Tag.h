//
//  Tag.h
//  Picnic
//
//  Created by Matthew Atkins on 07/09/2011.
//  Copyright (c) 2011 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * colorR;
@property (nonatomic, retain) NSNumber * colorG;
@property (nonatomic, retain) NSNumber * colorB;

@end
