//
//  MapViewController.m
//  Picnic
//
//  Created by Matthew Atkins on 06/09/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "MapViewController.h"
#import "PicnicAppDelegate.h"


@implementation MapViewController
@synthesize scrollView;
@synthesize mapView;
@synthesize fullScreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.fullScreen = NO;
    }
    return self;
}

- (void)dealloc
{
    [scrollView release];
    [mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Map";
    self.scrollView.contentSize = CGSizeMake(1123, 858);
    self.scrollView.clipsToBounds = YES;
    float zoomScale = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 0.48 : 0.81);
    self.scrollView.zoomScale = zoomScale;
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setMapView:nil];
    [self setView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    NSLog(@"Map: WillHideViewController");
    barButtonItem.title = @"Menu";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}



- (IBAction)toggleFullScreen:(id)sender {

//    UISplitViewController *appSplitViewController = [(PicnicAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController];
//    if (self.fullScreen){
//        [self dismissModalViewControllerAnimated:NO];
//        self.fullScreen = NO;
//    } else {
//        appSplitViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [appSplitViewController presentModalViewController:[[appSplitViewController viewControllers] objectAtIndex:1] animated:NO];
//        self.fullScreen = YES;
//    }
}
@end
