//
//  DetailViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate> {
    UILabel *_venueName;
    UITextView *_sessionText;
    UILabel *_sessionTime;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UILabel *venueName;
@property (nonatomic, strong) IBOutlet UITextView *sessionText;
@property (nonatomic, strong) IBOutlet UILabel *sessionTime;

@end
