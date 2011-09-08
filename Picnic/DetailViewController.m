//
//  DetailViewController.m
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "DetailViewController.h"
#import "PicnicAppDelegate.h"

@implementation DetailViewController

@synthesize toolbar = _toolbar;
@synthesize popoverController = _myPopoverController;
@synthesize popoverBarButtonItem = _myPopoverBarButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];    
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Managing the detail item


- (void)configureView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.popoverController = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)dealloc
{
    [_myPopoverBarButtonItem release];
    [_myPopoverController release];
    [_toolbar release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the toolbar.
    NSMutableArray *itemsArray = [self.toolbar.items mutableCopy];
    [itemsArray insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    NSMutableArray *itemsArray = [self.toolbar.items mutableCopy];
    [itemsArray removeObject:barButtonItem];
    [self.toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
//    NSLog(@"Detail: WillShowViewController");
//    // Called when the view is shown again in the split view, invalidating the button and popover controller.
//    NSMutableArray *items = [[self.toolbar items] mutableCopy];
//    [items removeObjectAtIndex:0];
//    [self.toolbar setItems:items animated:YES];
//    [items release];
//    self.popoverController = nil;
////    self.popoverBarButtonItem = nil;
}

@end
