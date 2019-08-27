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
#import <UMSocialCore/UMSocialCore.h>
#import "AddRemarkViewController.h"

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
                     [[UIApplication sharedApplication] registerForRemoteNotifications];
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
    
    //设置友盟分享相关的
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    [self configUSharePlatforms];
    
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"我获得的deviceToken是：%@", token);
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:token preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"推送DeviceToken 获取失败，原因：%@",error);
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
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

//配置分享平台
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx6b26c9073e541806" appSecret:@"d76d0a7c2a581ee7567a912395a6c87d" redirectURL:nil];
}

// 设置系统回调，支持所有iOS系统，这个方法有用吗？
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
}

#pragma mark 快捷选项的回调方法
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    NSString *title=shortcutItem.localizedTitle;
    
    if ([title isEqualToString:@"备注"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addRemark" object:nil];
    }else if ([title isEqualToString:@"新增习惯"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewSubject" object:nil];
    }
}


@end
