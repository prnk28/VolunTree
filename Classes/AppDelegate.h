//
//  AppDelegate.h
//  HelpOut
//
//  Created by Pradyumn Nukala on 8/28/15.
//  Copyright (c) 2015 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *viewController;
@property (strong, nonatomic) UITabBarController *tabBar;

@end

