//
//  PicnicAppDelegate.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SplashScreenController, Synchroniser;

@interface PicnicAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) SplashScreenController *splashScreenController;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UISplitViewController *splitViewController;
@property (retain, nonatomic) Synchroniser *synchroniser;
@property (nonatomic, retain) UIAlertView *alertView;
@property (assign, nonatomic) BOOL updating;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)hideSplashScreen;
- (void)setupSettings;
- (void)willStartUpdate;
- (void)didFinishUpdate;
@end
