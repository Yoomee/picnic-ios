//
//  SplashScreenController.h
//  Picnic
//
//  Created by Matthew Atkins on 08/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashScreenController : UIViewController {
    UIImageView *imageView;
}
@property (assign, nonatomic) BOOL landscape;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end
