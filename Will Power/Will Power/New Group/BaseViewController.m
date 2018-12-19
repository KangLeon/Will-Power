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

#pragma mark 初始化配置
//配置左边按钮标题
-(void)setNavigationBarLeftItemButtonTitle:(NSString *)title{
    
}

/**
  *  设置navigation左按钮（图片）
  *
  *  @param image     normal图片
  */
- (void)setNavigationBarLeftItemImage:(NSString *)image{
    //左上角按钮
    TapMusicButton *barButton_left=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_left.backgroundColor=[UIColor clearColor];
    [barButton_left setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [[barButton_left rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"左上角的我被惦记了");
        [self.navigationController popViewControllerAnimated:true];
        //返回的动作用block设定
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
}

- (void)setNavigationBarRightFirstItemImage:(NSString *)first_image andSecondItemImage:(NSString *)second_image{
    //右上帮助按钮
    TapMusicButton *barButton_right_help=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_help.backgroundColor=[UIColor clearColor];
    [barButton_right_help setImage:[UIImage imageNamed:@"need_help_image"] forState:UIControlStateNormal];
    [[barButton_right_help rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"我想要" message:@"要想培养一个好习惯或者是克服一个坏习惯，动机是最重要的，仔细想想你的出发点是什么？\n 比如：1.如果自控成功，我会直接收获什么？\n2.如果自控成功,我的家人，我的朋友，我喜欢的人会收获什么？\n3.最终那么美好的自己的是什么样子的？" cancelButtonTitle:@"明白了，开始做计划"];
    }];
    
    UIBarButtonItem *barButtonItem_right_help=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_help];
    
    //右上下一步按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"next_image"] forState:UIControlStateNormal];
    
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        //在这里判断，如果没有每一项都有内容的话提示用户继续完成输入
        if (self.isFinish) {
            
            //设置model
            
            //设置id
            //对id值进行判断然后进行加值
            //这里的思路是查询有几条数据
            if ([[AddModel shareAddMode] countForData]==0) {
                [AddModel shareAddMode].subject_id=1;
            }
            if ([[AddModel shareAddMode] countForData]>0) {
                //如果有数据就在条数后面+1
                [AddModel shareAddMode].subject_id=[[AddModel shareAddMode] countForData]+1;
            }
            
            [AddModel shareAddMode].subject_title=self.subject_title;
            [AddModel shareAddMode].subject_get=self.subject_get;
            [AddModel shareAddMode].subject_love_get=self.subject_love_get;
            [AddModel shareAddMode].subject_best_me=self.subject_best_me;
            [AddModel shareAddMode].subject_image_index=self.subjectLogoView.image_index;
            
            //            NSLog(@"%@,%@,%@,%@",self.addModel.subject_title,self.addModel.subject_get,self.addModel.subject_love_get,self.addModel.subject_best_me);
            
            AddSecondViewController *addsecond_VC=[[AddSecondViewController alloc] init];
            [self.navigationController pushViewController:addsecond_VC animated:true];
        }else{
            WrongMusic *wrongMusic=[[WrongMusic alloc] init];
            [wrongMusic playSoundEffect_wrong];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"仍有未输入的内容" subTitle:@"请完成本页的所有输入内容后再跳转到下一页面" closeButtonTitle:@"好的" duration:0.0f];
        }
        
    }];
    
    UIBarButtonItem *barButtonItem_right_next=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_next];
    
    self.navigationItem.rightBarButtonItems=@[barButtonItem_right_next,barButtonItem_right_help];
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
    //2018年11月18日
    NSString *yearString=[dateString substringWithRange:NSMakeRange(0, 4)];//2018
    NSString *monthString=[dateString substringWithRange:NSMakeRange(5, 1)];//1
    NSString *dayString=[dateString substringWithRange:NSMakeRange(7, 1)];//月
    
    //对月份进行处理
    if ([monthString isEqualToString:@"1"]) {
        //为1可能有两种情况：第一种是为1月，第二种是为10月、11月、12月
        if ([[dateString substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"月"]) {
            //确定是一月
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
            monthString=[dateString substringWithRange:NSMakeRange(5, 2)];//11
            dayString=[dateString substringWithRange:NSMakeRange(8, 1)];//1
            //在这里处理该情况下的日情况，日可能有两种情况：第一种是1日，第二种是1*日。
            //对当前日进行处理
            if ([dayString isEqualToString:@"1"]) {
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    //确定是1号
                    dayString=@"01";
                }else{
                    //
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            } else if([dayString isEqualToString:@"2"]){
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"02";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            }else if([dayString isEqualToString:@"3"]){
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
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
        }
        
    }else if([monthString isEqualToString:@"2"]){
        //2018年2月31日
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
                //做一个验证判断，如果计划开始时间是将来
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
                                        //每天类型的通知
                                        [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute if:i];
                                    }
                                }else if ([alarm_day isEqualToString:@"工作日"]){
                                    //工作日 2，3，4，5，6
                                    for (NSInteger i=2; i<7; i++) {
                                        //周一到周五的通知
                                        [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute if:i];
                                    }
                                }else if ([alarm_day isEqualToString:@"每周一"]){
                                    //2
                                    //周一通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                                }else if ([alarm_day isEqualToString:@"每周二"]){
                                    //3
                                    //周二通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                                }else if ([alarm_day isEqualToString:@"每周三"]){
                                    //4
                                    //周三通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                                }else if ([alarm_day isEqualToString:@"每周四"]){
                                    //5
                                    //周四通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                                }else if ([alarm_day isEqualToString:@"每周五"]){
                                    //6
                                    //周五通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                                }else if ([alarm_day isEqualToString:@"每周六"]){
                                    //7
                                    //周六通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                                }else if ([alarm_day isEqualToString:@"每周日"]){
                                    //1
                                    //周日通知
                                    [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
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
                                //每天类型的通知
                                [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute if:i];
                            }
                        }else if ([alarm_day isEqualToString:@"工作日"]){
                            //工作日 2，3，4，5，6
                            for (NSInteger i=2; i<7; i++) {
                                //周一到周五的通知
                                [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute if:i];
                            }
                        }else if ([alarm_day isEqualToString:@"每周一"]){
                            //2
                            //周一通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }else if ([alarm_day isEqualToString:@"每周二"]){
                            //3
                            //周二通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }else if ([alarm_day isEqualToString:@"每周三"]){
                            //4
                            //周三通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }else if ([alarm_day isEqualToString:@"每周四"]){
                            //5
                            //周四通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }else if ([alarm_day isEqualToString:@"每周五"]){
                            //6
                            //周五通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }else if ([alarm_day isEqualToString:@"每周六"]){
                            //7
                            //周六通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }else if ([alarm_day isEqualToString:@"每周日"]){
                            //1
                            //周日通知
                            [self startSingleNotifi:dic imageIndex:imageIndex alarm_hour:alarm_hour alarm_minute:alarm_minute];
                        }
                    }//for循环的
                }else{
                    //什么都不做
                }//判断bool任务是否是打开的
            }//比较日期的
            }//for 循环的
        }else{
            //这里是还没有打开通知权限的，所以提出打开通知提示框
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
        NSLog(@"删除前还有的通知个数：count%lu",(unsigned long)requests.count);
        for (NSInteger i=0; i<requests.count; i++) {
            UNNotificationRequest *pendingRequest = [requests objectAtIndex:i];
            if ([pendingRequest.identifier isEqualToString:identi]) {
//                NSString *teststring=pendingRequest.identifier;
                [[UNUserNotificationCenter currentNotificationCenter]removePendingNotificationRequestsWithIdentifiers:@[pendingRequest.identifier]];
            }
        }
        NSLog(@"删除后还有的通知个数：count%lu",(unsigned long)requests.count);
    }];
}

//1.1 确立一个普通计划通知
-(void)startSingleNotifi:(NSDictionary *)dic imageIndex:(NSString *)imageIndex alarm_hour:(NSString*)alarm_hour alarm_minute:(NSString*)alarm_minute{
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
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.wav"];
    content.sound = sound;
    
    //从选取器中获取的内容，来设置trigger
    //每周几
    
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

//1.2 确立一个普通计划通知 如果是循环添加类型的
-(void)startSingleNotifi:(NSDictionary *)dic imageIndex:(NSString *)imageIndex alarm_hour:(NSString*)alarm_hour alarm_minute:(NSString*)alarm_minute if:(NSInteger)i{
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
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"Intro.wav"];
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

//确立一个普通通知


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
