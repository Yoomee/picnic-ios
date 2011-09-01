//
//  RootViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "SessionCell.h"
#import "ConferenceSession.h"
#import "Venue.h"
#import "Member.h"

@interface RootViewController : UIViewController <NSFetchedResultsControllerDelegate> {
    UITableView *tableView;
    UISegmentedControl *_daySelector;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *daySelector;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet DetailViewController *detailViewController;

@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, assign, nonatomic) int currentDay;
- (IBAction)dayDidChange:(UISegmentedControl *)sender;
-(void)updateSelected:(BOOL)selectFirst;

@end
