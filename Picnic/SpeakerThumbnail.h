//
//  SpeakerThumbnail.h
//  Picnic
//
//  Created by Matthew Atkins on 01/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface SpeakerThumbnail : UIView {
    UIImageView *image;
    UILabel *forenameLabel;
    UILabel *surnameLabel;
}

@property (nonatomic, retain) Member *member;

@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UILabel *forenameLabel;
@property (nonatomic, retain) IBOutlet UILabel *surnameLabel;

-(void)configureView;

@end
