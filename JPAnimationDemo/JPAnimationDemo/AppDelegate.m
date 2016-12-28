//
//  AppDelegate.m
//  JPAnimationDemo
//
//  Created by lava on 2016/12/28.
//  Copyright © 2016年 NewPan. All rights reserved.
//

#import "AppDelegate.h"
#import "JPTableViewController.h"
#import "JPNavigationControllerKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 启动图片延时: 2 秒
    [NSThread sleepForTimeInterval:2];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    JPTableViewController *tab = [JPTableViewController new];
    JPNavigationController *nav = [[JPNavigationController alloc]initWithRootViewController:tab];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
