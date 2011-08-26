//
//  PicnicAppDelegate.h
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashScreenController.h"

@interface PicnicAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (retain, nonatomic) SplashScreenController *splashScreenController;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UISplitViewController *splitViewController;

- (void)hideSplashScreen;
- (void)setupSettings;
@end
