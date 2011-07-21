//
//  SessionCell.h
//  Picnic
//
//  Created by Matthew Atkins on 21/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionCell : UITableViewCell {
    UILabel *sessionName;
    UILabel *venueName;
    UILabel *sessionTime;
}

@property (strong, nonatomic) id sessionItem;

@property (nonatomic, strong) IBOutlet UILabel *sessionName;
@property (nonatomic, strong) IBOutlet UILabel *venueName;
@property (nonatomic, strong) IBOutlet UILabel *sessionTime;

- (void)setSessionItem:(id)newSessionItem;
- (void)configureView;

@end
