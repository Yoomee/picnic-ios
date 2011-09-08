//
//  FestivalThemesViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 08/09/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"


@interface FestivalThemesController : DetailViewController {
    
    UIScrollView *scrollView;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
