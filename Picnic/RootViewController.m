    //
//  RootViewController.m
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "RootViewController.h"
#import "PicnicAppDelegate.h"
#import "SessionDetailViewController.h"
#import "MapViewController.h"
#import "FestivalThemesController.h"
#import "UsefulInformationController.h"
#import "AboutAppController.h"
#import "SessionCell.h"
#import "ConferenceSession.h"
#import "Venue.h"
#import "Member.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)willViewInfoTab;
- (void)finishedViewingInfoTab;
@end

@implementation RootViewController

@synthesize detailViewController = _detailViewController;
@synthesize sessionDetailViewController = _sessionDetailViewController;
@synthesize mapViewController = _mapViewController;
@synthesize festivalThemesController = _festivalThemesController;
@synthesize usefulInformationController = _usefulInformationController;
@synthesize aboutAppController = _aboutAppController;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize currentDay = _currentDay;
@synthesize daySelector = _daySelector;
@synthesize myProgram = _myProgram;
@synthesize viewingInfoTab = _viewingInfoTab;
@synthesize tabBar = _tabBar;
@synthesize tableView;
@synthesize popoverController, rootPopoverButtonItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Wednesday 14 September";
        self.currentDay = 1;
        self.myProgram = NO;
        self.viewingInfoTab = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.tabBar setSelectedItem:[[self.tabBar items] objectAtIndex:0]];
    [super viewDidLoad];  
}

- (void)viewDidUnload
{
    __fetchedResultsController = nil;
    self.rootPopoverButtonItem = nil;
    [self setDaySelector:nil];
    [self setTabBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [popoverController release];
    [rootPopoverButtonItem release];
    [_aboutAppController release];
    [_usefulInformationController release];
    [_festivalThemesController release];
    [_sessionDetailViewController release];
    [_mapViewController release];    
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [_daySelector release];
    [_tabBar release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
     self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.fetchedResultsController = nil;
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.viewingInfoTab ? 1 : [[self.fetchedResultsController sections] count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.viewingInfoTab){
        return 2;
    } else if (self.myProgram && [[self.fetchedResultsController fetchedObjects] count] == 0){
        return 1;
    } else{
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if(self.viewingInfoTab){
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        switch ([indexPath row]) {
            case 0:
                cell.textLabel.text = @"Useful Information";
                break;
            case 1:
                cell.textLabel.text = @"About the app";
                break;
            default:
                break;
        }
        // Configure the cell.
        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"infoRow%i.png", [indexPath row]]]];

        return cell;
    }else {
        if(self.myProgram && [[self.fetchedResultsController fetchedObjects] count] == 0){
            static NSString *CellIdentifier = @"MyProgramCellIdentifier";
            // Dequeue or create a cell of the appropriate type.
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyProgramCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
            return cell;
        } else {
            static NSString *CellIdentifier = @"SessionCell";
            SessionCell *cell = (SessionCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SessionCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }

            // Configure the cell.
            [self configureCell:cell atIndexPath:indexPath];
            return cell;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.viewingInfoTab){
        if([indexPath row] == 99){
            // not showing Festival Themes for 2012            
            if(_mapViewController == nil){
                NSString *mapNibName = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"MapViewController_iPhone" : @"MapViewController_iPad");
                MapViewController *myMapViewController = [[MapViewController alloc] initWithNibName:mapNibName bundle:nil];
                self.mapViewController = myMapViewController;
                [myMapViewController release];
            }
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = backButton;
                [self.navigationController pushViewController:self.mapViewController animated:YES];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [backButton release];
            } else if (self.detailViewController != self.mapViewController){
                self.detailViewController = self.mapViewController;
            }
        } else if([indexPath row] == 99){
            // not showing Festival Themes for 2012
            if(_festivalThemesController == nil){
                NSString *themesNibName = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"FestivalThemesController_iPhone" : @"FestivalThemesController_iPad");
                FestivalThemesController *myFestivalThemesController = [[FestivalThemesController alloc] initWithNibName:themesNibName bundle:nil];
                self.festivalThemesController = myFestivalThemesController;
                [myFestivalThemesController release];
            }
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = backButton;
                [self.navigationController pushViewController:self.festivalThemesController animated:YES];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [backButton release];
            } else if (self.detailViewController != self.festivalThemesController){
                self.detailViewController = self.festivalThemesController;
            }
        } else if([indexPath row] == 0){
            if(_usefulInformationController == nil){
                NSString *nibName = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"UsefulInformationController_iPhone" : @"UsefulInformationController_iPad");
                UsefulInformationController *myUsefulInformationController = [[UsefulInformationController alloc] initWithNibName:nibName bundle:nil];
                self.usefulInformationController = myUsefulInformationController;
                [myUsefulInformationController release];
            }
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = backButton;
                [self.navigationController pushViewController:self.usefulInformationController animated:YES];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [backButton release];
            } else if (self.detailViewController != self.usefulInformationController){
                self.detailViewController = self.usefulInformationController;
            }
        } else if([indexPath row] == 1){
            if(_aboutAppController == nil){
                NSString *themesNibName = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"AboutAppController_iPhone" : @"AboutAppController_iPad");
                AboutAppController *myAboutAppController = [[AboutAppController alloc] initWithNibName:themesNibName bundle:nil];
                self.aboutAppController = myAboutAppController;
                [myAboutAppController release];
            }
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = backButton;
                [self.navigationController pushViewController:self.aboutAppController animated:YES];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [backButton release];
            } else if (self.detailViewController != self.aboutAppController){
                self.detailViewController = self.aboutAppController;
            }
        }

    } else if (!(self.myProgram && [[self.fetchedResultsController fetchedObjects] count] == 0)){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            SessionDetailViewController *aDetailViewController = [[SessionDetailViewController alloc] initWithNibName:@"SessionDetailViewController_iPhone" bundle:nil];
            self.sessionDetailViewController = aDetailViewController;
            ConferenceSession *selectedConferenceSession = [[self fetchedResultsController] objectAtIndexPath:indexPath];        
            self.sessionDetailViewController.conferenceSession = selectedConferenceSession;
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            [self.navigationController pushViewController:self.sessionDetailViewController animated:YES];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [backButton release];
            [aDetailViewController release];
        } else {
            if (self.detailViewController != self.sessionDetailViewController){
                self.detailViewController = self.sessionDetailViewController;
            }            
            ConferenceSession *conferenceSession = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            self.sessionDetailViewController.conferenceSession = conferenceSession;
        }
    } else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
}
-(void) setDetailViewController:(DetailViewController *)newDetailViewController{
    if(self.popoverController){
        [_detailViewController invalidateRootPopoverButtonItem:self.rootPopoverButtonItem];
    }    
    UISplitViewController *appSplitViewController = [(PicnicAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController];
    appSplitViewController.viewControllers = [NSArray arrayWithObjects:[appSplitViewController.viewControllers objectAtIndex:0], newDetailViewController, nil];
    
    _detailViewController = newDetailViewController;
    
    if(self.popoverController) {
        [_detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConferenceSession" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate;
    NSString *cacheName;
    if(self.myProgram){
        predicate = [NSPredicate predicateWithFormat:@"day == %d && attending == 1", self.currentDay];
        cacheName = [NSString stringWithFormat:@"MyDay%i",self.currentDay];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"day == %d", self.currentDay];
        cacheName = [NSString stringWithFormat:@"Day%i",self.currentDay];
    }
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *startTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startsAt" ascending:YES];
    NSSortDescriptor *venueOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"venue.order" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:startTimeDescriptor, venueOrderDescriptor, nil];

    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
        {
	    /*
	     Replace this implementation with code to handle the error appropriately.

	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
    }    
        [aFetchedResultsController release];
    [fetchRequest release];
    [venueOrderDescriptor release];
    [startTimeDescriptor release];
    [sortDescriptors release];
    return __fetchedResultsController;
}    

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    [tableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    switch(type)
//    {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath
//{    
//    switch(type)
//    {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.tableView beginUpdates];
//}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 */
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [tableView reloadData];
    if ([[[self.sessionDetailViewController conferenceSession] day] intValue] == self.currentDay) {
        NSIndexPath *selectedIndexPath = [self.fetchedResultsController indexPathForObject:[self.sessionDetailViewController conferenceSession]];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    }
}
 

- (void)configureCell:(SessionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{    
    ConferenceSession *conferenceSession = [self.fetchedResultsController objectAtIndexPath:indexPath];    
    cell.conferenceSession = conferenceSession;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 73)];
    [bgView setBackgroundColor:conferenceSession.color];
//    UIImageView *attendingStar = [UIImageView alloc] in
    [cell setSelectedBackgroundView:bgView];
    [bgView release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 0){
        NSString* launchUrl = @"http://picnicnetwork.org/api/authenticate";
        [self.tabBar setSelectedItem:[[self.tabBar items] objectAtIndex:0]];
        if(self.viewingInfoTab)
            [self finishedViewingInfoTab];
        switch (buttonIndex) {
            case 0:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
                break;
            case 1:
                true;
                UIActionSheet *newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?\nWe won't ask you again." delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Keep my program offline" otherButtonTitles:@"Cancel",nil];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    [newActionSheet setCancelButtonIndex:1];
                [newActionSheet setTag:1];
                [newActionSheet showFromTabBar:self.tabBar];
                [newActionSheet release];
                break;
            default:
                [self dayDidChange:self.daySelector];
                break;
        }
    } else if (actionSheet.tag == 1){
        if(buttonIndex == 0){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"neverSyncMyProgram"];
            self.myProgram = YES;
            [self.tabBar setSelectedItem:[[self.tabBar items] objectAtIndex:1]];
            if(self.detailViewController == self.sessionDetailViewController){
                [self.sessionDetailViewController configureView];
            }
            if(self.viewingInfoTab)
                [self finishedViewingInfoTab];
            [self dayDidChange:self.daySelector];
        }
        
    }
}

- (IBAction)dayDidChange:(UISegmentedControl *)sender {
    self.currentDay = [sender selectedSegmentIndex] + 1;
    switch(self.currentDay) {
        case 2:
            self.title = @"Thursday 15 September";
            break;
        case 3:
            self.title = @"Friday 16 September";
            break;
        default:
            self.title = @"Wednesday 14 September";
    }
    __fetchedResultsController = nil;
    [self.tableView reloadData];
    [self updateSelected:NO];
}

-(void)updateSelected:(BOOL)selectFirst{
    if (selectFirst == YES){
        if([self.sessionDetailViewController conferenceSession]){
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                [self.navigationController popViewControllerAnimated:YES];
            self.sessionDetailViewController.conferenceSession = nil;
        }
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        [self dayDidChange:self.daySelector];
    } else if([self.sessionDetailViewController conferenceSession]){
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
            if ([[[self.sessionDetailViewController conferenceSession] day] intValue] == self.currentDay) {
                NSIndexPath *selectedIndexPath = [self.fetchedResultsController indexPathForObject:[self.sessionDetailViewController conferenceSession]];
                [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition: UITableViewScrollPositionMiddle];
            } else if ([self tableView:self.tableView numberOfRowsInSection:0] > 0){
              [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

-(void)willViewInfoTab{
    self.title = @"Information";
    self.myProgram = NO;
    self.viewingInfoTab = YES;
    [self.daySelector setHidden:YES];
    CGRect frame = self.tableView.frame; 
    frame.origin.y = 0;
    frame.size.height = frame.size.height + 45;
    self.tableView.frame = frame;
}
-(void)finishedViewingInfoTab{
    self.viewingInfoTab = NO;
    [self.daySelector setHidden:NO];
    CGRect frame = self.tableView.frame; 
    frame.origin.y = 45;
    frame.size.height = frame.size.height - 45;
    self.tableView.frame = frame;
}

#pragma mark - Tab bar
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0: //Program
            if(self.viewingInfoTab)
                [self finishedViewingInfoTab];
            self.myProgram = NO;
            [self dayDidChange:self.daySelector];
            break;
        case 1:
            true;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *apiKey = [defaults valueForKey:@"apiKey"];
            if([defaults boolForKey:@"neverSyncMyProgram"] || ([apiKey length] > 0)){
                self.myProgram = YES;
                if(self.viewingInfoTab)
                    [self finishedViewingInfoTab];
                [self dayDidChange:self.daySelector];
            } else {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTag:0];
                [actionSheet setTitle:@"Sync with an online PICNIC account?"];
                [actionSheet setDelegate:self];
                [actionSheet addButtonWithTitle:@"Sync now"];
                [actionSheet addButtonWithTitle:@"Never sync"];
                [actionSheet addButtonWithTitle:@"Ask me later"];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    [actionSheet setCancelButtonIndex:2];
                [actionSheet showFromTabBar:self.tabBar];
                [actionSheet release];
            }
            break;
        case 2://Info
            [self willViewInfoTab];
            [self.tableView reloadData];
        default:
            break;
    }

}

#pragma mark - Split view
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Menu";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    [self.detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    [self.detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

@end
