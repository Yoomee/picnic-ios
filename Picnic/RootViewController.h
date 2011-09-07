//
//  RootViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SessionDetailViewController, MapViewController;

#import <CoreData/CoreData.h>


@interface RootViewController : UIViewController <NSFetchedResultsControllerDelegate, UITabBarDelegate, UIActionSheetDelegate> {
    UITableView *tableView;
    UISegmentedControl *_daySelector;
    UITabBar *_tabBar;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *daySelector;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (retain, nonatomic) SessionDetailViewController *sessionDetailViewController;
@property (retain, nonatomic) MapViewController *mapViewController;
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readwrite, assign, nonatomic) int currentDay;
@property (assign, nonatomic) BOOL myProgram;
@property (assign, nonatomic) BOOL viewingInfoTab;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;


- (IBAction)dayDidChange:(UISegmentedControl *)sender;

- (void)updateSelected:(BOOL)selectFirst;

@end
