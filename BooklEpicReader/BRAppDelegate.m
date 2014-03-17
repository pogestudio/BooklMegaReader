//
//  BRAppDelegate.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-17.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BRAppDelegate.h"
#import "BRFirstVC.h"

@implementation BRAppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    BRFirstVC *firstVC = [[BRFirstVC alloc] init];
    
    
    UINavigationController *navCon = [[UINavigationController alloc]
                                      initWithRootViewController:firstVC];
    [navCon setNavigationBarHidden:YES];
    
	self.window.rootViewController =navCon;
    [self.window makeKeyAndVisible];
    
	return YES;
}

@end