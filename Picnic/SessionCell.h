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

@property (nonatomic, retain) ConferenceSession *conferenceSession;

@property (nonatomic, retain) IBOutlet UILabel *sessionName;
@property (nonatomic, retain) IBOutlet UILabel *venueName;
@property (nonatomic, retain) IBOutlet UILabel *sessionTime;

- (void)configureView;

@end
