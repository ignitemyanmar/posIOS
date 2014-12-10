//
//  AppDelegate.m
//  POS
//
//  Created by Zune Moe on 3/17/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AppDelegate.h"
#import "UIStoryboard+MultipleStoryboards.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = paths[0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.db"];
    [self createAndCheckDatabase:path db:@"database.db"];
    [self.db createItemTable];
        
    [self setupTabBarController];
    
    //set voucher number from zero
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"voucherCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupTabBarController
{
    UIStoryboard *sb = [UIStoryboard getSaleStoryboard];
    UIViewController *saleVC = [sb instantiateInitialViewController];
    saleVC.tabBarItem.title = @"Sale";
    
    sb = [UIStoryboard getAdminStoryboard];
    UIViewController *adminVC = [sb instantiateInitialViewController];
    adminVC.tabBarItem.title = @"Admin";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[adminVC, saleVC];
    
    self.window.rootViewController = tabBarController;
}

-(void) createAndCheckDatabase:(NSString *)path db:(NSString *)dbName
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:path];
    if(success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:path error:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
