//
//  RootViewController.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SessionDetailViewController, MapViewController, FestivalThemesController, UsefulInformationController, AboutAppController;

#import <CoreData/CoreData.h>
#import "DetailViewController.h"


@interface RootViewController : UIViewController <UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate, UITabBarDelegate, UIActionSheetDelegate> {
    UITableView *tableView;
    UISegmentedControl *_daySelector;
    UITabBar *_tabBar;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    DetailViewController* detailViewController;
}
@property (nonatomic, retain) DetailViewController *detailViewController;

@property (nonatomic, retain) IBOutlet UISegmentedControl *daySelector;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (retain, nonatomic) SessionDetailViewController *sessionDetailViewController;
@property (retain, nonatomic) MapViewController *mapViewController;
@property (retain, nonatomic) FestivalThemesController *festivalThemesController;
@property (retain, nonatomic) UsefulInformationController *usefulInformationController;
@property (retain, nonatomic) AboutAppController *aboutAppController;

@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readwrite, assign, nonatomic) int currentDay;
@property (assign, nonatomic) BOOL myProgram;
@property (assign, nonatomic) BOOL viewingInfoTab;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;


- (IBAction)dayDidChange:(UISegmentedControl *)sender;

- (void)updateSelected:(BOOL)selectFirst;

@end
