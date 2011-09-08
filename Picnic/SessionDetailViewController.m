//
//  DetailViewController.m
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "PicnicAppDelegate.h"
#import "Synchroniser.h"
#import "Tag.h"


@implementation SessionDetailViewController

@synthesize welcomeView = _welcomeView;
@synthesize contentView = _contentView;
@synthesize conferenceSession = _conferenceSession;
@synthesize sessionName = _sessionName;
@synthesize toolbar = _toolbar;
@synthesize venueName = _venueName;
@synthesize sessionText = _sessionText;
@synthesize sessionTime = _sessionTime;
@synthesize attendingToggleButton = _attendingToggleButton;
@synthesize sessionSpeakers = _sessionSpeakers;
@synthesize popoverController = _myPopoverController;
@synthesize tagViews = _tagViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];    
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
        UIBarButtonItem *aBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbarEmptyStar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressAttendingToggleButton:)];
        [aBarButton setWidth:30.0];
        self.attendingToggleButton  = aBarButton;
        [aBarButton release];
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setConferenceSession:(ConferenceSession *)newConferenceSession
{
	if (_conferenceSession != newConferenceSession) {
		[_conferenceSession release];
		_conferenceSession = [newConferenceSession retain];
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
        if ([[self.conferenceSession attending] boolValue]) {
            [self.attendingToggleButton setImage:[UIImage imageNamed:@"toolbarStar.png"]];
        } else {
            [self.attendingToggleButton setImage:[UIImage imageNamed:@"toolbarStarEmpty.png"]];
        }
        if (self.welcomeView){
            for (UIView *subView in self.contentView.subviews)
                [subView setHidden:NO];
            [self.welcomeView removeFromSuperview];
        }
        for (UIView *view in self.contentView.subviews) {
            if(view.tag == 1)
                [view removeFromSuperview];
        }
        NSMutableArray *tagImages = [[NSMutableArray alloc] init];
        [self.conferenceSession.tags enumerateObjectsUsingBlock:^(Tag *tag, BOOL *stop) {
            NSString *tagString = [NSString stringWithFormat:@"tag%i.png", [tag.uid intValue]];
            if([self.conferenceSession mainTagIs:tag]){
                [tagImages insertObject:tagString atIndex:0];
            } else {
                [tagImages addObject:tagString];
            }
        }];
        float numberOfTags = [tagImages count];
        [tagImages enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop){
                UIImageView *tagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            float tagX = (((idx + 1)-((numberOfTags + 1)/2)) * 45) + self.contentView.center.x;
            float tagY = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 23 : 45);
            tagView.center = CGPointMake(tagX, tagY);
            tagView.tag = 1;
            tagView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
            [self.contentView addSubview:tagView];
            [tagView release];
        }];
        BOOL containsAttendingToggle = [[self.toolbar items] containsObject:self.attendingToggleButton];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL canUseMyProgram = (([defaults boolForKey:@"neverSyncMyProgram"])||([[defaults stringForKey:@"apiKey"] length] > 0));
        if (canUseMyProgram && !containsAttendingToggle) {
            NSMutableArray *items = [self.toolbar.items mutableCopy];
            [items addObject:self.attendingToggleButton];
            self.toolbar.items = items;
            [items release];
        } else if (!canUseMyProgram && containsAttendingToggle) {
            NSMutableArray *items = [self.toolbar.items mutableCopy];
            [items removeObject:self.attendingToggleButton];
            self.toolbar.items = items;
            [items release];
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
    frame.size.height = textSize.height + 30;
    self.sessionText.frame = frame;
    UIScrollView *tempScrollView = (UIScrollView *)self.contentView;
    tempScrollView.contentSize = CGSizeMake(0, self.sessionText.frame.origin.y + self.sessionText.frame.size.height + 20);
}

-(void) showWelcome:(UIInterfaceOrientation)interfaceOrientation
{
    for (UIView *subView in self.contentView.subviews)
        [subView setHidden:YES];
    NSString *imageName;        
    if ((interfaceOrientation == 3) || (interfaceOrientation == 4)) {
        imageName = @"WelcomeLandscape.png";
        } else {
        imageName = @"WelcomePortrait.png";
    }
    UIImageView *welView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.welcomeView = welView;
    [self.contentView addSubview:welView];
    [welView release];
    [self.toolbar setTintColor:[UIColor blackColor]];

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
    self.conferenceSession = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.welcomeView = nil;
    [self setAttendingToggleButton:nil];
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
    [_tagViews release];
    [_conferenceSession release];
    [_sessionName release];
    [_sessionTime release];
    [_venueName release];
    [_sessionSpeakers release];
    [_contentView release];
    [_sessionText release];
    [_welcomeView release];
    [_attendingToggleButton release];
    [super dealloc];
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
//    NSLog(@"Session: WillHideViewController");
//    barButtonItem.title = @"Sessions";
//    NSMutableArray *items = [[self.toolbar items] mutableCopy];
//    [items insertObject:barButtonItem atIndex:0];
//    [self.toolbar setItems:items animated:YES];
//    [items release];
//    if(self.conferenceSession){
//        [self.toolbar setTintColor:[self.conferenceSession color]];
//    }
//    self.popoverBarButtonItem = barButtonItem;
//    self.popoverController = pc;
}

-(void)updateSelected:(BOOL)selectFirst{
}



- (IBAction)didPressAttendingToggleButton:(id)sender {
    if (self.conferenceSession) {
        PicnicAppDelegate *myAppDelegate = (PicnicAppDelegate *)[[UIApplication sharedApplication] delegate];
        Synchroniser *mySynchroniser = [myAppDelegate synchroniser];
        if ([self.conferenceSession.attending boolValue]) {
            [mySynchroniser setAttending:[NSNumber numberWithInt:0] forConferenceSession:self.conferenceSession];
            [self.attendingToggleButton setImage:[UIImage imageNamed:@"toolbarStarEmpty.png"]];
        } else {
            [mySynchroniser setAttending:[NSNumber numberWithInt:1] forConferenceSession:self.conferenceSession];
            [self.attendingToggleButton setImage:[UIImage imageNamed:@"toolbarStar.png"]];
        }
    }
}

@end
