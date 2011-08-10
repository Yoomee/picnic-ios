//
//  DetailViewController.m
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize welcomeView = _welcomeView;
@synthesize contentView = _contentView;
@synthesize conferenceSession = _conferenceSession;
@synthesize sessionName = _sessionName;
@synthesize toolbar = _toolbar;
@synthesize venueName = _venueName;
@synthesize sessionText = _sessionText;
@synthesize sessionTime = _sessionTime;
@synthesize sessionSpeakers = _sessionSpeakers;
@synthesize popoverController = _myPopoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setConferenceSession:(ConferenceSession *)newConferenceSession
{
    if (_conferenceSession != newConferenceSession) {
        _conferenceSession = newConferenceSession;
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.conferenceSession) {
        [self.toolbar setTintColor:[self.conferenceSession color]];
        self.sessionName.text = [self.conferenceSession name];
        self.title = [self.conferenceSession name];
        self.venueName.text = [[self.conferenceSession venue] name];
        self.sessionTime.text = [self.conferenceSession dateString];        
        self.sessionText.text = [self.conferenceSession text];
        self.sessionSpeakers.text = [self.conferenceSession speakersString];
        int sessionTextOffset;
        if ([[self.conferenceSession speakers] count] == 0){
            sessionTextOffset = 33;
        } else {
            sessionTextOffset = 85;
        }
        CGRect frame = self.sessionText.frame; 
        frame.origin.y = self.venueName.frame.origin.y + sessionTextOffset;
        self.sessionText.frame = frame;
        [self resizeSessionTextAndContentView];
        [self.navigationItem setTitle:@""];
        [self.navigationController.navigationBar setTintColor:[self.conferenceSession color]];
        if (self.welcomeView){
            for (UIView *subView in self.contentView.subviews)
                [subView setHidden:NO];
            [self.welcomeView removeFromSuperview];
            self.welcomeView = NULL;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)resizeSessionTextAndContentView
{
    CGFloat fontSize;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        fontSize = 17.0;
    } else {
        fontSize = 18.0;
    }
    CGSize textSize = [[self.conferenceSession text] sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.sessionText.frame.size.width, 1000.0f)];
    CGRect frame = self.sessionText.frame; 
    frame.size.height = textSize.height + 10;
    self.sessionText.frame = frame;
    UIScrollView *tempScrollView = (UIScrollView *)self.contentView;
    tempScrollView.contentSize = CGSizeMake(0, self.sessionText.frame.origin.y + self.sessionText.frame.size.height + 20);
}

-(void) showWelcome
{
    for (UIView *subView in self.contentView.subviews)
        [subView setHidden:YES];
    [self.toolbar setTintColor:[UIColor blackColor]];
    UIImageView *welView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WelcomeLandscape.png"]];
    self.welcomeView = welView;
    [self.contentView addSubview:welView];
    NSLog(@"ALPHA:%f",self.welcomeView.alpha);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setVenueName:nil];
    [self setSessionText:nil];
    [self setSessionTime:nil];
    [self setContentView:nil];
    [self setWelcomeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resizeSessionTextAndContentView];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Sessions";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [self.toolbar setTintColor:[self.conferenceSession color]];
    self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.popoverController = nil;
}

@end
