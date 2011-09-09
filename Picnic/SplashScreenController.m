//
//  SplashScreenController.m
//  Picnic
//
//  Created by Matthew Atkins on 08/08/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "SplashScreenController.h"

@implementation SplashScreenController
@synthesize imageView;
@synthesize landscape = _landscape;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"View did load");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.landscape) {
        [self.imageView setImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"Default-Portrait~ipad.png"]];
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"Should rotate, Landscape:%i", UIInterfaceOrientationIsLandscape(interfaceOrientation));
    self.landscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
	return YES;
}

- (void)dealloc
{
    [imageView release];
    [super dealloc];
}


@end
