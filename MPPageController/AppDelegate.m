//
// Created by Michal Piwowarczyk on 07.03.15.
// Copyright (c) 2015 Allianz. All rights reserved.
//


#import "AppDelegate.h"
#import "MPPagerControl.h"


@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *v1 = [UIViewController new];
    v1.view.backgroundColor = [UIColor colorWithRed:26.0f/255.0f green:188.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
    v1.title = @"first";
    UIViewController *v2 = [UIViewController new];
    v2.title = @"second with longer name";
    v2.view.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:204.0f/255.0f blue:113.0f/255.0f alpha:1.0f];
    UIViewController *v3 = [UIViewController new];
    v3.title = @"third semilong";
    v3.view.backgroundColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    
    UIColor *navBarColor = [UIColor colorWithRed:22.0f/255.0f green:160.0f/255.0f blue:133.0f/255.0f alpha:1.0f];
    
    MPPagerControl *pagerControl = [[MPPagerControl alloc] initWithNavBarBackground:navBarColor textColor:[UIColor whiteColor] viewControllers:@[v1,v2,v3]];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:pagerControl];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end