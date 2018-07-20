//
//  AppDelegate.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/1.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AppDelegate.h"
#import <ReactiveObjC.h>
#import <UserNotifications/UserNotifications.h>
#import "SizeDefine.h"
#import "LaunchViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //获取通知的权限,
    if (IS_IOS10_OR_ABOVE) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge
                                                 | UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted,NSError * _Nullable error)
         {
             if(granted){
                 NSLog(@"注册成功，通知权限获取成功");
                 [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings* _Nonnull settings){
                     
                 }];
             }
             else{
                 NSLog(@"注册失败");
             }
         }];
    }
    
    //设置音效打开
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMusicOn"];//是否打开提醒音乐
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSign"];//是否打开签到提醒
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAlarm"];//是否打开任务提醒
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"21"] forKey:@"sign_hour"];//21点
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"0"] forKey:@"sign_minute"];//0分
    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"应用到后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"应用返回前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 修改角标，这里没有搞好的是本地统计使应用的角标累加，希望找到好的解决办法，
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
