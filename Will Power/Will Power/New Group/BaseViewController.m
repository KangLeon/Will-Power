//
//  BaseViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseViewController.h"
#import "ColorDefine.h"
#import "TapMusic.h"
#import "AddModel.h"
#import "NotifiModel.h"
#import <UserNotifications/UserNotifications.h>
#import "GetSaying.h"
#import <SCLAlertView.h>
#import "SizeDefine.h"
#import "NSDate+LocalDate.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //通用的背景和导航栏设置
    self.view.backgroundColor=BACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
    //1.首先把navigationController的Translucent取消勾选，颜色与背景色一致
    //2.然后同多下面一行代码，取消当行懒分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 字符串与时间的相关转换方法
//NSDate->NSString (简单的将NSdate转化为字符串)
-(NSString *)stringFrom:(NSDate*)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString=[dateFormatter stringFromDate:date];//转化后自动得到本地时区的时间字符串，但是如果NSDate时区从格林尼治转化到本地时区，这里得到的字符串是延后8小时的，所以NSDate不进行时区变化
    return dateString;
}

//NSString->NSdate
-(NSDate*)dateFrom:(NSString*)dateString{
    //对数据库中的字符串进行处理，得到可以被转化的格式字符串
    NSString *yearString=[dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *monthString=[dateString substringWithRange:NSMakeRange(5, 1)];
    NSString *dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
    
    //对月份进行处理
    if ([monthString isEqualToString:@"1"]) {
        if ([[dateString substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"月"]) {
           monthString=@"01";
            //对当前日进行处理
            if ([dayString isEqualToString:@"1"]) {
                if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
                    dayString=@"01";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            } else if([dayString isEqualToString:@"2"]){
                if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
                    dayString=@"02";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            }else if([dayString isEqualToString:@"3"]){
                if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
                    dayString=@"03";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            }else if([dayString isEqualToString:@"4"]){
                dayString=@"04";
            }else if([dayString isEqualToString:@"5"]){
                dayString=@"05";
            }else if([dayString isEqualToString:@"6"]){
                dayString=@"06";
            }else if([dayString isEqualToString:@"7"]){
                dayString=@"07";
            }else if([dayString isEqualToString:@"8"]){
                dayString=@"08";
            }else if([dayString isEqualToString:@"9"]){
                dayString=@"09";
            }
        }else{
            monthString=[dateString substringWithRange:NSMakeRange(5, 2)];
            //在这里处理该情况下的日情况
            //对当前日进行处理
            if ([dayString isEqualToString:@"1"]) {
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"01";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(9, 2)];
                }
            } else if([dayString isEqualToString:@"2"]){
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"02";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(9, 2)];
                }
            }else if([dayString isEqualToString:@"3"]){
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"03";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(9, 2)];
                }
            }else if([dayString isEqualToString:@"4"]){
                dayString=@"04";
            }else if([dayString isEqualToString:@"5"]){
                dayString=@"05";
            }else if([dayString isEqualToString:@"6"]){
                dayString=@"06";
            }else if([dayString isEqualToString:@"7"]){
                dayString=@"07";
            }else if([dayString isEqualToString:@"8"]){
                dayString=@"08";
            }else if([dayString isEqualToString:@"9"]){
                dayString=@"09";
            }
        }
        
    }else if([monthString isEqualToString:@"2"]){
        monthString=@"02";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"3"]){
        monthString=@"03";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"4"]){
        monthString=@"04";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"5"]){
        monthString=@"05";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"6"]){
        monthString=@"06";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"7"]){
        monthString=@"07";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"8"]){
        monthString=@"08";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"9"]){
        monthString=@"09";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }
    
    ///拼接新的字符串
    dateString=[NSString stringWithFormat:@"%@-%@-%@",yearString,monthString,dayString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:dateString];//得到的是格林尼治时间,需要转化到北京时区的时间
    
    //将格林尼治时间转化为北京时间
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:date];
    
    NSDate *BEIJING_date=[date dateByAddingTimeInterval:interval];//拿到在北京时区下的时间格式
    
    //需要将时间从00:00延后到用户操作时间
    //思路：
    
    return BEIJING_date;
}

#pragma mark 关于确立通知的相关方法

//1.根据提示确立一个适合的通知
-(void)startNotifi{
    NSLog(@"我要确立的通知是下面的内容");
    [[NotifiModel notifiModel] selectEveryThing];
    
    //循坏所有任务确立所有通知
    //判断是否已经打开通知，如果没有打开通知就不确立通知，单纯的存储提醒时间到数据库，如果打开了就确立通知
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
        {
            //从数据库中遍历任务
            //通过每一个任务的subject_id查询关联的通知数据
            //确立通知
            for (NSDictionary *dic in [[AddModel shareAddMode] selectEveryThing]) {
                
                NSDate *date_start=[self dateFrom:[dic objectForKey:@"start_date"]];
                NSDate *current=[NSDate localdate_4real];
                NSDate *laterDate=[date_start laterDate:current];
                if ([laterDate isEqualToDate:date_start]) {
                    //弄一个定时器将来再确立通知
                    NSTimeInterval timeInterval=[date_start timeIntervalSinceDate:current];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //根据是否正在执行按钮来确定是否应该添加该任务的通知,如果该任务未在进行中的话，就不确立该任务的通知了，
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"subject_title"],[dic objectForKey:@"reward"]]]) {
                            //正常的执行确立通知
                            
                            //确立通知
                            //已经拿到了通知授权
                            NSLog(@"%ld",[[NotifiModel notifiModel] countForDataIn:[[dic objectForKey:@"id"] integerValue]]);
                            for (NSInteger i=0; i<([[NotifiModel notifiModel] countForDataIn:[[dic objectForKey:@"id"] integerValue]]); i++) {
                                NSString *alarm_day=[[[[NotifiModel notifiModel] selectItemsIn:[[dic objectForKey:@"id"] integerValue]] objectAtIndex:i] objectForKey:@"alarm_day"];
                                NSString *alarm_hour=[[[[NotifiModel notifiModel] selectItemsIn:[[dic objectForKey:@"id"] integerValue]] objectAtIndex:i] objectForKey:@"alarm_hour"];
                                NSString *alarm_minute=[[[[NotifiModel notifiModel] selectItemsIn:[[dic objectForKey:@"id"] integerValue]] objectAtIndex:i] objectForKey:@"alarm_minute"];
                                NSString *imageIndex=[dic objectForKey:@"image"];
                                
                                //周日是从1开始的
                                if ([alarm_day isEqualToString:@"每天"]) {
                                    //现在使用的是最笨的办法循坏来确立通知时间----->如果有更好的办法则升级
                                    for (NSInteger i=1; i<8; i++) {
                                        UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                        
                                        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                        
                                        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                        
                                        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                        content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                        //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                        content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                        content.badge = @1;
                                        NSError *error = nil;
                                        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];//图片必须放在文件目录下，不能放入Assets.xcassets
                                        
                                        // 2.设置通知附件内容
                                        UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                        if (error) {
                                            NSLog(@"attachment error %@", error);
                                        }
                                        content.attachments = @[att];
                                        //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                        content.categoryIdentifier =@"category";
                                        
                                        // 2.设置声音
                                        UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                        content.sound = sound;
                                        
                                        //从选取器中获取的内容，来设置trigger
                                        //每天都提醒
                                        
                                        NSDateComponents *component = [[NSDateComponents alloc] init];
                                        component.weekday = i;
                                        component.hour = [alarm_hour integerValue];
                                        component.minute=[alarm_minute integerValue];
                                        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                        
                                        // 4.设置UNNotificationRequest
                                        NSString *requestIdentifer =[NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]];
                                        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                        
                                        //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                        }];
                                    }
                                }else if ([alarm_day isEqualToString:@"工作日"]){
                                    //工作日 2，3，4，5，6
                                    for (NSInteger i=2; i<7; i++) {
                                        UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                        
                                        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                        
                                        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                        
                                        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                        content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                        //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                        content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                        content.badge = @1;
                                        NSError *error = nil;
                                        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                        
                                        // 2.设置通知附件内容
                                        UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                        if (error) {
                                            NSLog(@"attachment error %@", error);
                                        }
                                        content.attachments = @[att];
                                        //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                        content.categoryIdentifier =@"category";
                                        
                                        // 2.设置声音
                                        UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                        content.sound = sound;
                                        
                                        //从选取器中获取的内容，来设置trigger
                                        //工作日
                                        
                                        NSDateComponents *component = [[NSDateComponents alloc] init];
                                        component.weekday = i;
                                        component.hour = [alarm_hour integerValue];
                                        component.minute=[alarm_minute integerValue];
                                        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                        
                                        // 4.设置UNNotificationRequest
                                        NSString *requestIdentifer = [NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]];
                                        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                        
                                        //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                        }];
                                    }
                                    
                                }else if ([alarm_day isEqualToString:@"每周一"]){
                                    //2
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周一
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 2;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"2notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }else if ([alarm_day isEqualToString:@"每周二"]){
                                    //3
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周二
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 3;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"3notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }else if ([alarm_day isEqualToString:@"每周三"]){
                                    //4
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周三
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 4;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"4notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }else if ([alarm_day isEqualToString:@"每周四"]){
                                    //5
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周四
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 5;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"5notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }else if ([alarm_day isEqualToString:@"每周五"]){
                                    //6
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周五
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 6;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"6notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }else if ([alarm_day isEqualToString:@"每周六"]){
                                    //7
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周六
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 7;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"7notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }else if ([alarm_day isEqualToString:@"每周日"]){
                                    //1
                                    UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                    
                                    UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                    
                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                    
                                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                    content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                    //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                    content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                    content.badge = @1;
                                    NSError *error = nil;
                                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                    
                                    // 2.设置通知附件内容
                                    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                    if (error) {
                                        NSLog(@"attachment error %@", error);
                                    }
                                    content.attachments = @[att];
                                    //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                    content.categoryIdentifier =@"category";
                                    
                                    // 2.设置声音
                                    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                    content.sound = sound;
                                    
                                    //从选取器中获取的内容，来设置trigger
                                    //每周日
                                    
                                    NSDateComponents *component = [[NSDateComponents alloc] init];
                                    component.weekday = 1;
                                    component.hour = [alarm_hour integerValue];
                                    component.minute=[alarm_minute integerValue];
                                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                    
                                    // 4.设置UNNotificationRequest
                                    NSString *requestIdentifer = [NSString stringWithFormat:@"1notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                    
                                    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    }];
                                }
                            }
                        }else{
                            //不确立通知
                        }
                    });
                }else{
                    //按照原有逻辑，直接确立通知
                    //已经拿到了通知授权
                if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"subject_title"],[dic objectForKey:@"reward"]]]) {
                    
                    NSLog(@"%ld",[[NotifiModel notifiModel] countForDataIn:[[dic objectForKey:@"id"] integerValue]]);
                    for (NSInteger i=0; i<([[NotifiModel notifiModel] countForDataIn:[[dic objectForKey:@"id"] integerValue]]); i++) {
                        NSString *alarm_day=[[[[NotifiModel notifiModel] selectItemsIn:[[dic objectForKey:@"id"] integerValue]] objectAtIndex:i] objectForKey:@"alarm_day"];
                        NSString *alarm_hour=[[[[NotifiModel notifiModel] selectItemsIn:[[dic objectForKey:@"id"] integerValue]] objectAtIndex:i] objectForKey:@"alarm_hour"];
                        NSString *alarm_minute=[[[[NotifiModel notifiModel] selectItemsIn:[[dic objectForKey:@"id"] integerValue]] objectAtIndex:i] objectForKey:@"alarm_minute"];
                        NSString *imageIndex=[dic objectForKey:@"image"];
                        
                        //周日是从1开始的
                        if ([alarm_day isEqualToString:@"每天"]) {
                            //现在使用的是最笨的办法循坏来确立通知时间----->如果有更好的办法则升级
                            for (NSInteger i=1; i<8; i++) {
                                UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                
                                UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                
                                [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                
                                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                content.badge = @1;
                                NSError *error = nil;
                                NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];//图片必须放在文件目录下，不能放入Assets.xcassets
                                
                                // 2.设置通知附件内容
                                UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                if (error) {
                                    NSLog(@"attachment error %@", error);
                                }
                                content.attachments = @[att];
                                //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                content.categoryIdentifier =@"category";
                                
                                // 2.设置声音
                                UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                content.sound = sound;
                                
                                //从选取器中获取的内容，来设置trigger
                                //每天都提醒
                                
                                NSDateComponents *component = [[NSDateComponents alloc] init];
                                component.weekday = i;
                                component.hour = [alarm_hour integerValue];
                                component.minute=[alarm_minute integerValue];
                                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                
                                // 4.设置UNNotificationRequest
                                NSString *requestIdentifer =[NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]];
                                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                
                                //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                }];
                            }
                        }else if ([alarm_day isEqualToString:@"工作日"]){
                            //工作日 2，3，4，5，6
                            for (NSInteger i=2; i<7; i++) {
                                UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                                
                                UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                
                                [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                
                                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                                //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                content.body=[[GetSaying shareGetSaying] getRandomSaying];
                                content.badge = @1;
                                NSError *error = nil;
                                NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                                
                                // 2.设置通知附件内容
                                UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                                if (error) {
                                    NSLog(@"attachment error %@", error);
                                }
                                content.attachments = @[att];
                                //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                                content.categoryIdentifier =@"category";
                                
                                // 2.设置声音
                                UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                                content.sound = sound;
                                
                                //从选取器中获取的内容，来设置trigger
                                //工作日
                                
                                NSDateComponents *component = [[NSDateComponents alloc] init];
                                component.weekday = i;
                                component.hour = [alarm_hour integerValue];
                                component.minute=[alarm_minute integerValue];
                                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                
                                // 4.设置UNNotificationRequest
                                NSString *requestIdentifer = [NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]];
                                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                
                                //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                }];
                            }
                            
                        }else if ([alarm_day isEqualToString:@"每周一"]){
                            //2
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周一
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 2;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"2notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }else if ([alarm_day isEqualToString:@"每周二"]){
                            //3
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周二
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 3;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"3notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }else if ([alarm_day isEqualToString:@"每周三"]){
                            //4
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周三
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 4;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"4notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }else if ([alarm_day isEqualToString:@"每周四"]){
                            //5
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周四
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 5;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"5notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }else if ([alarm_day isEqualToString:@"每周五"]){
                            //6
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周五
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 6;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"6notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }else if ([alarm_day isEqualToString:@"每周六"]){
                            //7
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周六
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 7;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"7notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }else if ([alarm_day isEqualToString:@"每周日"]){
                            //1
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"进入Will Power" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = [dic objectForKey:@"subject_title"];//标题应该是获取到对应项目的标题
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body=[[GetSaying shareGetSaying] getRandomSaying];
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@",imageIndex,imageIndex] ofType:@"png"];
                            
                            // 2.设置通知附件内容
                            UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                            if (error) {
                                NSLog(@"attachment error %@", error);
                            }
                            content.attachments = @[att];
                            //                content.launchImageName = @"跑步机";//这里无条件显示了上面载入的图片，该行没有起作用，或者说该行的作用是什么
                            content.categoryIdentifier =@"category";
                            
                            // 2.设置声音
                            UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.m4a"];
                            content.sound = sound;
                            
                            //从选取器中获取的内容，来设置trigger
                            //每周日
                            
                            NSDateComponents *component = [[NSDateComponents alloc] init];
                            component.weekday = 1;
                            component.hour = [alarm_hour integerValue];
                            component.minute=[alarm_minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer = [NSString stringWithFormat:@"1notifiAND%ld",[[dic objectForKey:@"id"] integerValue]];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }//判断周几的
                    }//for循环的
                }else{
                    //什么都不做
                }//判断bool任务是否是打开的
            }//比较日期的
            }//for 循环的
        }else{
            //这里是还没有确立通知的，所以提出打开通知提示框
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"未打开通知" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"打开通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (IS_IOS10_OR_ABOVE) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            UIAlertAction *nooAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:yesAction];
            [alertController addAction:nooAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
    }];
    
    

}

//取消置顶通知
//时间复杂度比较麻烦
-(void)removePending:(NSString*)identi{
    [[UNUserNotificationCenter currentNotificationCenter]getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"count%lu",(unsigned long)requests.count);
        for (NSInteger i=0; i<requests.count; i++) {
            UNNotificationRequest *pendingRequest = [requests objectAtIndex:i];
            if ([pendingRequest.identifier isEqualToString:identi]) {
//                NSString *teststring=pendingRequest.identifier;
                [[UNUserNotificationCenter currentNotificationCenter]removePendingNotificationRequestsWithIdentifiers:@[pendingRequest.identifier]];
            }
        }
    }];
}

//对起始日期和当前日期进行比较，如果是在之后的日期就跳出，不确立通知




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
