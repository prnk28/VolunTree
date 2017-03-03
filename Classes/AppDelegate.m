//
//  AppDelegate.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 8/28/15.
//  Copyright (c) 2015 VolunTree. All rights reserved.
//

#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Setup Parse
    [Parse enableLocalDatastore];
    [Parse initializeWithConfiguration:[ParseClientConfiguration
                                        configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
                                            configuration.applicationId = @"quGrO1twerMp0WnVXxJ6tb2LKO5eb4RQBgJM3PKL";
                                            configuration.clientKey = @"Y7dxMu3Pr7Meum2bpbfw7sS7UPMe54KQB7LsRVOJ";
                                            configuration.server = @"https://pg-app-m2532adoeosy8pexf4djlg3eggdtg3.scalabl.cloud/1/";
                                        }]];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    // Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    // Setup Tab Bar
    self.tabBar = [[UITabBarController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    SidebarViewController *sideBar = [[SidebarViewController alloc] init];
    
    // Setup Dates
    [self setupBoxes];
    [self setUpThisMonth];
    [self setUpLastMonth];
    
    // Home VC
    HomeViewController *home = [[HomeViewController alloc] init];
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"homeTabBar"] selectedImage:nil];
    home.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:home];
    navHome.navigationBarHidden = NO;
    
    // Notification VC
    NotificationViewController *notif = [[NotificationViewController alloc] init];
    notif.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"heartTabIcon"] selectedImage:nil];
    notif.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController *navNotif = [[UINavigationController alloc] initWithRootViewController:notif];
    
    // Search VC
    SearchViewController *search = [[SearchViewController alloc] init];
    search.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"compass"] selectedImage:nil];
    search.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController *navSearch = [[UINavigationController alloc] initWithRootViewController:search];
    
    // Profile VC
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    profile.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"personTabIcon"] selectedImage:nil];
    profile.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController *navProfile = [[UINavigationController alloc] initWithRootViewController:profile];
    
    // Tab Bar Appearance
    self.tabBar.viewControllers = [NSArray arrayWithObjects:navHome, navNotif, navSearch, navProfile, nil];

    if (self.window.frame.size.width == 320) {
        UIImage *tabBarBG = [UIImage imageNamed:@"tabBarBG320"];
        [[UITabBar appearance] setBackgroundImage:tabBarBG];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected320"]];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    } else if(self.window.frame.size.width == 375){
        UIImage *tabBarBG = [UIImage imageNamed:@"tabBarBG"];
        [[UITabBar appearance] setBackgroundImage:tabBarBG];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected"]];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    }else{
        UIImage *tabBarBG = [UIImage imageNamed:@"tabBarBG414"];
        [[UITabBar appearance] setBackgroundImage:tabBarBG];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected414"]];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    }

    
    // Setup Side Panel
    JASidePanelController *masterController = [[JASidePanelController alloc] init];
    masterController.centerPanel = self.tabBar;
    masterController.rightPanel = sideBar;
    
    // Nav Bar Appearance
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navBar"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],
                                                          NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"OpenSans-Semibold" size:18], NSFontAttributeName, nil]];
    
    [self.window setRootViewController:masterController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// Objective-C
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    installation.channels = @[ @"global" ];
    [installation saveInBackground];
}

// Objective-C
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"Source %@",sourceApplication);
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)setupBoxes {
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *compsPast = [NSDateComponents new];
                    compsPast.month = -1;
                    compsPast.weekOfYear = -1;
                    NSDate *datePast = [calendar dateByAddingComponents:compsPast toDate:[NSDate date] options:0];
                    NSDateComponents *componentsPast = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday) fromDate:datePast];
                    NSInteger pm = [componentsPast month];
                    object[@"lastMonthDate"] = @(pm);
                    
                    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday) fromDate:[NSDate date]];
                    NSInteger tm = [components month];
                    object[@"thisMonthDate"] = @(tm);
                    NSInteger twd = [components weekday];
                    object[@"weekDayDate"] = @(twd);
                    [object saveInBackground];
                }
            }
        }];
    }
}

- (void)setUpThisMonth {
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    NSNumber *m = object[@"thisMonthDate"];
                    if ([m floatValue] == 1) {
                        object[@"thisMonth"] = object[@"Jan"];
                        [object saveInBackground];
                    }else if([m floatValue] == 2) {
                        object[@"thisMonth"] = object[@"Feb"];
                        [object saveInBackground];
                    }else if([m floatValue] == 3) {
                        object[@"thisMonth"] = object[@"Mar"];
                        [object saveInBackground];
                    }else if([m floatValue] == 4) {
                        object[@"thisMonth"] = object[@"Apr"];
                        [object saveInBackground];
                    }else if([m floatValue] == 5) {
                        object[@"thisMonth"] = object[@"May"];
                        [object saveInBackground];
                    }else if([m floatValue] == 6) {
                        object[@"thisMonth"] = object[@"Jun"];
                        [object saveInBackground];
                    }else if([m floatValue] == 7){
                        object[@"thisMonth"] = object[@"Jul"];
                        [object saveInBackground];
                    }else if([m floatValue] == 8) {
                        object[@"thisMonth"] = object[@"Aug"];
                        [object saveInBackground];
                    }else if([m floatValue] == 9) {
                        object[@"thisMonth"] = object[@"Sep"];
                        [object saveInBackground];
                    }else if([m floatValue] == 10) {
                        object[@"thisMonth"] = object[@"Oct"];
                        [object saveInBackground];
                    }else if([m floatValue] == 11) {
                        object[@"thisMonth"] = object[@"Nov"];
                        [object saveInBackground];
                    }else if([m floatValue] == 12) {
                        object[@"thisMonth"] = object[@"Dec"];
                        [object saveInBackground];
                    }
                }
            }
        }];
    }
}

- (void)setUpLastMonth {
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    NSNumber *m = object[@"lastMonthDate"];
                    if ([m floatValue] == 1) {
                        object[@"lastMonth"] = object[@"Jan"];
                        [object saveInBackground];
                    }else if([m floatValue] == 2) {
                        object[@"lastMonth"] = object[@"Feb"];
                        [object saveInBackground];
                    }else if([m floatValue] == 3) {
                        object[@"lastMonth"] = object[@"Mar"];
                        [object saveInBackground];
                    }else if([m floatValue] == 4) {
                        object[@"lastMonth"] = object[@"Apr"];
                        [object saveInBackground];
                    }else if([m floatValue] == 5) {
                        object[@"lastMonth"] = object[@"May"];
                        [object saveInBackground];
                    }else if([m floatValue] == 6) {
                        object[@"lastMonth"] = object[@"Jun"];
                        [object saveInBackground];
                    }else if([m floatValue] == 7){
                        object[@"lastMonth"] = object[@"Jul"];
                        [object saveInBackground];
                    }else if([m floatValue] == 8) {
                        object[@"lastMonth"] = object[@"Aug"];
                        [object saveInBackground];
                    }else if([m floatValue] == 9) {
                        object[@"lastMonth"] = object[@"Sep"];
                        [object saveInBackground];
                    }else if([m floatValue] == 10) {
                        object[@"lastMonth"] = object[@"Oct"];
                        [object saveInBackground];
                    }else if([m floatValue] == 11) {
                        object[@"lastMonth"] = object[@"Nov"];
                        [object saveInBackground];
                    }else if([m floatValue] == 12) {
                        object[@"lastMonth"] = object[@"Dec"];
                        [object saveInBackground];
                    }
                }
            }
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
