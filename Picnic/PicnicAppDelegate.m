//
//  PicnicAppDelegate.m
//  Picnic
//
//  Created by Matthew Atkins on 20/07/2011.
//  Copyright 2011 Yoomee. All rights reserved.
//

#import "PicnicAppDelegate.h"
#import "RootViewController.h"
#import "MapViewController.h"
#import "SessionDetailViewController.h"
#import "Synchroniser.h"
#import "SplashScreenController.h"

@implementation PicnicAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize splashScreenController = _splashScreenController;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize synchroniser = _synchroniser;
@synthesize alertView = _alertView;
@synthesize updating = _updating;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIWindow *myWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = myWindow;
    [myWindow release];
    
    self.updating = NO;
    
    [self setupSettings];
    
    Synchroniser *mySynchroniser = [[Synchroniser alloc] init];
    self.synchroniser = mySynchroniser;
    [mySynchroniser release];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        SplashScreenController *mySplashScreenController = [[SplashScreenController alloc] initWithNibName:@"SplashScreen_iPhone" bundle:nil];
        self.splashScreenController = mySplashScreenController;       
        RootViewController *controller = [[RootViewController alloc] initWithNibName:@"RootViewController_iPhone" bundle:nil];
        controller.managedObjectContext = self.managedObjectContext;
        
        UINavigationController *myNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.navigationController = myNavigationController;
        self.window.rootViewController = self.navigationController;

        [mySplashScreenController release];   
        [myNavigationController release];
        [controller release];
    } else {
        SplashScreenController *mySplashScreenController = [[SplashScreenController alloc] initWithNibName:@"SplashScreen_iPad" bundle:nil];
        self.splashScreenController = mySplashScreenController;
        
        RootViewController *controller = [[RootViewController alloc] initWithNibName:@"RootViewController_iPad" bundle:nil];
        SessionDetailViewController *detailViewController = [[SessionDetailViewController alloc] initWithNibName:@"SessionDetailViewController_iPad" bundle:nil];
        controller.sessionDetailViewController = detailViewController;
        controller.detailViewController = detailViewController;
        controller.managedObjectContext = self.managedObjectContext;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.navigationController = navigationController;

        UISplitViewController *mySplitViewController = [[UISplitViewController alloc] init];
        self.splitViewController = mySplitViewController;
        self.splitViewController.delegate = controller;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
        
        self.window.rootViewController = self.splitViewController;

        [mySplitViewController release];
        [navigationController release];
        [detailViewController release];
        [mySplashScreenController release];
        [controller release];
    }
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentModalViewController:self.splashScreenController animated:NO];
    [self performSelector:@selector(hideSplashScreen) withObject:nil afterDelay: 1.5f];    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self.synchroniser startUpdate:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

-(void)setupSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    NSInteger dbVersion = [defaults integerForKey:@"dbVersion"]; 

    if (!(dbVersion && (dbVersion == 2))) {
        [defaults setInteger:2 forKey:@"dbVersion"];
        NSLog(@"Replacing database");
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Picnic.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Picnic" ofType:@"sqlite"];
        [fileManager removeItemAtPath:[storeURL path] error:NULL];
        [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:NULL];
    }    
    
    [defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
    [defaults synchronize];
}

-(void)refreshViewControllers{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:10];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [viewControllers addObjectsFromArray:[self.navigationController viewControllers]];
    } else {
        RootViewController *aRootViewController = (RootViewController *)[[[self.splitViewController viewControllers]objectAtIndex:0] topViewController];
        [viewControllers addObject: aRootViewController];
        [viewControllers addObject:aRootViewController.sessionDetailViewController];
    }
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop){
        [(RootViewController *)viewController updateSelected:YES];
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // Display text
    if ([[url host] isEqualToString:@"api"] && ([[url pathComponents] count] > 1)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *apiKey = [[url pathComponents] objectAtIndex:1];
        [defaults setValue:apiKey forKey:@"apiKey"];
        [defaults synchronize];
        RootViewController *aRootViewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            aRootViewController = (RootViewController *)[self.navigationController topViewController];
        } else {
            aRootViewController = (RootViewController *)[[[self.splitViewController viewControllers]objectAtIndex:0] topViewController];
            if(aRootViewController.detailViewController == aRootViewController.sessionDetailViewController){
                [(SessionDetailViewController *)aRootViewController.detailViewController configureView];
            }
        }
        [aRootViewController setMyProgram:YES];
        [aRootViewController.tabBar setSelectedItem:[[aRootViewController.tabBar items] objectAtIndex:1]];

    }
    return YES;
}

-(void)willStartUpdate{
    NSLog(@"Updating program.");
    if(!self.updating){
        self.updating = YES;
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Updating program" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [self.alertView show];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = CGPointMake(self.alertView.bounds.size.width / 2, self.alertView.bounds.size.height - 50);
        [indicator startAnimating];
        [self.alertView addSubview:indicator];
        [indicator release];
        [self.window.rootViewController presentModalViewController:self.splashScreenController animated:NO];
    }
}

-(void)didFinishUpdate{
    NSLog(@"Finished.");
    if(self.updating){
        [NSFetchedResultsController deleteCacheWithName:@"Day1"];
        [NSFetchedResultsController deleteCacheWithName:@"Day2"];
        [NSFetchedResultsController deleteCacheWithName:@"Day3"];
        [NSFetchedResultsController deleteCacheWithName:@"MyDay1"];
        [NSFetchedResultsController deleteCacheWithName:@"MyDay2"];
        [NSFetchedResultsController deleteCacheWithName:@"MyDay3"];
        [self refreshViewControllers];
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self hideSplashScreen];
        self.updating = NO;
    }
}
- (void)hideSplashScreen
{
    SessionDetailViewController *controller = [(RootViewController *)[(UINavigationController *)[self.splitViewController.viewControllers objectAtIndex:0] topViewController] sessionDetailViewController];
    controller.contentView.alpha = 0.0;
    [controller showWelcome:self.window.rootViewController.interfaceOrientation];
    self.splashScreenController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController dismissModalViewControllerAnimated:NO];
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationCurveEaseInOut animations:^{controller.welcomeView.alpha = 1.0;controller.contentView.alpha = 1.0;} completion:NULL];
}

- (void)dealloc
{
    [_alertView release];
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_synchroniser release];
    [_splitViewController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) { 
        [viewController release];
    }];
    [_splitViewController release];
    [_navigationController release];
    [_splashScreenController release];
    [super dealloc];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Picnic" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Picnic.sqlite"];

    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
