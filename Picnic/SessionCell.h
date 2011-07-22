//
//  SessionCell.h
//  Picnic
//
//  Created by Matthew Atkins on 21/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConferenceSession.h"
#import "Venue.h"

@interface SessionCell : UITableViewCell {
    UILabel *sessionName;
    UILabel *venueName;
    UILabel *sessionTime;
}

@property (nonatomic, strong) ConferenceSession *conferenceSession;

@property (nonatomic, strong) IBOutlet UILabel *sessionName;
@property (nonatomic, strong) IBOutlet UILabel *venueName;
@property (nonatomic, strong) IBOutlet UILabel *sessionTime;

- (void)configureView;

@end
