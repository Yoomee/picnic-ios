    //
//  RootViewController.m
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "SessionCell.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController

@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize currentDay = _currentDay;
@synthesize daySelector = _daySelector;
@synthesize myProgram = _myProgram;
@synthesize tabBar = _tabBar;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Wednesday 14 September";
        self.currentDay = 1;
        self.myProgram = NO;
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
    [self setDaySelector:nil];
    [self setTabBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_detailViewController release];
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
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (SessionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        DetailViewController *aDetailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
        self.detailViewController = aDetailViewController;
        ConferenceSession *selectedConferenceSession = [[self fetchedResultsController] objectAtIndexPath:indexPath];        
        self.detailViewController.conferenceSession = selectedConferenceSession;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [backButton release];
        [aDetailViewController release];
    } else {
        ConferenceSession *conferenceSession = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.conferenceSession = conferenceSession;
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
    // In the simplest, most efficient, case, reload the table view.
    [tableView reloadData];
}
 

- (void)configureCell:(SessionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{    
    ConferenceSession *conferenceSession = [self.fetchedResultsController objectAtIndexPath:indexPath];    
    cell.conferenceSession = conferenceSession;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 73)];
    [bgView setBackgroundColor:conferenceSession.color];
    [cell setSelectedBackgroundView:bgView];
    [bgView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
        NSString* launchUrl = @"http://10.0.1.5:3000/api/authenticate";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
	}
	else
	{
        self.myProgram = NO;
        [self.tabBar setSelectedItem:[[self.tabBar items] objectAtIndex:0]];
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
        if([self.detailViewController conferenceSession]){
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                [self.navigationController popViewControllerAnimated:YES];
            self.detailViewController.conferenceSession = nil;
        }
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        [self dayDidChange:self.daySelector];
    } else if([self.detailViewController conferenceSession]){
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
            if ([[[self.detailViewController conferenceSession] day] intValue] == self.currentDay) {
                NSIndexPath *selectedIndexPath = [self.fetchedResultsController indexPathForObject:[self.detailViewController conferenceSession]];
                [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition: UITableViewScrollPositionMiddle];
            } else {
              [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

#pragma mark - Tab bar
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%d", item.tag);
    switch (item.tag) {
        case 0: //Program
            self.myProgram = NO;
            [self dayDidChange:self.daySelector];
            break;
        case 1: //My program
            self.myProgram = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *apiKey = [defaults valueForKey:@"apiKey"];
            if(([apiKey length] == 0)){
                UIAlertView *alert = [[UIAlertView alloc] init];
                [alert setTitle:@"My Program"];
                [alert setMessage:@"Connect to your PICNIC account?"];
                [alert setDelegate:self];
                [alert addButtonWithTitle:@"Not now"];
                [alert addButtonWithTitle:@"Let's go!"];
                [alert show];
                [alert release];
            } else {
                [self dayDidChange:self.daySelector];
            }
            break;
        default:
            break;
    }

}

@end
