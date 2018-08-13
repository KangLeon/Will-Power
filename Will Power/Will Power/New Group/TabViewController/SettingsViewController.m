//
//  SettingsViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SettingsViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import <ReactiveObjC.h>
#import "TapMusicButton.h"
#import "SetSwitchTableViewCell.h"
#import "SetLabelTableViewCell.h"
#import "ShareTableViewCell.h"
#import "DonateViewController.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"
#import "TapMusic.h"
#import <objc/runtime.h>
#import "SignView.h"
#import <UserNotifications/UserNotifications.h>
#import "NotifiModel.h"
#import "AddModel.h"
#import "MusicSelect.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

static NSString *cell_id_switch=@"cell_switch";
static NSString *cell_id_label=@"cell_label";
static NSString *cell_id_share=@"cell_share";

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic,strong) UITableView *notifi_tableView_set;//提醒
@property(nonatomic,strong) UITableView *music_tableView_set;//音效
@property(nonatomic,strong) UITableView *about_tableView_set;//关于
@property(nonatomic,strong) UITableView *donate_tableView_set;//捐赠
@property(nonatomic,strong) UIScrollView *scollrView;

@property(nonatomic,assign)NSInteger isAlarm;
@property(nonatomic,assign)NSInteger isSign;

@property(nonatomic,strong)MusicSelect *musicSelctView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navItem];
    [self navTitle];
    [self loadUI];
}

-(void)loadUI{
    //一些变量的初始化
    self.scollrView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scollrView.contentSize=CGSizeMake(SCREEN_WIDTH, 700+80);
    
    self.scollrView.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:self.scollrView];
    [self.view sendSubviewToBack:self.scollrView];
    
    
    //提醒时间设置
    UILabel *notifi_label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 55)];
    notifi_label.text=@"通知";
    notifi_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    notifi_label.backgroundColor=[UIColor clearColor];
    notifi_label.textColor=[UIColor whiteColor];
    
    [self.scollrView addSubview:notifi_label];
    
    self.notifi_tableView_set=[[UITableView alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-20, 55*4)];
    self.notifi_tableView_set.layer.cornerRadius=12;
    self.notifi_tableView_set.dataSource=self;
    self.notifi_tableView_set.delegate=self;
    self.notifi_tableView_set.scrollEnabled=NO;
    [self.notifi_tableView_set registerClass:[SetSwitchTableViewCell class] forCellReuseIdentifier:cell_id_switch];
    [self.notifi_tableView_set registerClass:[SetLabelTableViewCell class] forCellReuseIdentifier:cell_id_label];
    
    [self.scollrView addSubview:self.notifi_tableView_set];
    
    //音效设置
    UILabel *music_label=[[UILabel alloc] initWithFrame:CGRectMake(20, 290, 100, 55)];
    music_label.text=@"音效";
    music_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    music_label.backgroundColor=[UIColor clearColor];
    music_label.textColor=[UIColor whiteColor];
    
    [self.scollrView addSubview:music_label];
    
    self.music_tableView_set=[[UITableView alloc] initWithFrame:CGRectMake(10, 340, SCREEN_WIDTH-20, 55)];
    self.music_tableView_set.layer.cornerRadius=12;
    self.music_tableView_set.dataSource=self;
    self.music_tableView_set.delegate=self;
    self.music_tableView_set.scrollEnabled=NO;
    [self.music_tableView_set registerClass:[SetSwitchTableViewCell class] forCellReuseIdentifier:cell_id_switch];
    
    [self.scollrView addSubview:self.music_tableView_set];
    
    //关于设置
    UILabel *about_label=[[UILabel alloc] initWithFrame:CGRectMake(20, 405, 100, 55)];
    about_label.text=@"关于";
    about_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    about_label.backgroundColor=[UIColor clearColor];
    about_label.textColor=[UIColor whiteColor];
    
    [self.scollrView addSubview:about_label];
    
    self.about_tableView_set=[[UITableView alloc] initWithFrame:CGRectMake(10, 455, SCREEN_WIDTH-20, 55*2)];
    self.about_tableView_set.layer.cornerRadius=12;
    self.about_tableView_set.dataSource=self;
    self.about_tableView_set.delegate=self;
    self.about_tableView_set.scrollEnabled=NO;
    [self.about_tableView_set registerClass:[SetSwitchTableViewCell class] forCellReuseIdentifier:cell_id_switch];
    
    [self.scollrView addSubview:self.about_tableView_set];
    
    //捐赠
    UILabel *donate_label=[[UILabel alloc] initWithFrame:CGRectMake(20, 575, 100, 55)];
    donate_label.text=@"支持";
    donate_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    donate_label.backgroundColor=[UIColor clearColor];
    donate_label.textColor=[UIColor whiteColor];

    [self.scollrView addSubview:donate_label];

    self.donate_tableView_set=[[UITableView alloc] initWithFrame:CGRectMake(10, 625, SCREEN_WIDTH-20, 55)];
    self.donate_tableView_set.layer.cornerRadius=12;
    self.donate_tableView_set.dataSource=self;
    self.donate_tableView_set.delegate=self;
    self.donate_tableView_set.scrollEnabled=NO;
    [self.donate_tableView_set registerClass:[SetSwitchTableViewCell class] forCellReuseIdentifier:cell_id_switch];

    [self.scollrView addSubview:self.donate_tableView_set];
    
    
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"设置";
    titleLabel.textColor=BACKGROUND_COLOR;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBar.layer.cornerRadius=17;
}

//导航栏按钮
-(void)navItem{
    //左上角按钮
    TapMusicButton *barButton_left=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_left.backgroundColor=[UIColor clearColor];
    [barButton_left setImage:[UIImage imageNamed:@"back_image"] forState:UIControlStateNormal];
    [[barButton_left rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"左上角的我被惦记了");
        [self.navigationController popViewControllerAnimated:true];
        self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
}

#pragma mark --tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.notifi_tableView_set]) {
        return 1;
    }else if ([tableView isEqual:self.music_tableView_set]){
       return 1;
    }else if ([tableView isEqual:self.about_tableView_set]){
        return 1;
    }else if ([tableView isEqual:self.donate_tableView_set]){
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.notifi_tableView_set]) {
        return 4;
    }else if ([tableView isEqual:self.music_tableView_set]){
        return 1;
    }else if ([tableView isEqual:self.about_tableView_set]){
        return 2;
    }else if ([tableView isEqual:self.donate_tableView_set]){
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.notifi_tableView_set]) {
        if (indexPath.row==0) {
            SetSwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_switch];
            if (cell==nil) {
                cell=[[SetSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_switch];
            }
            cell.cell_title.text=@"每日待办项目提醒";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
            self.isAlarm=[[NSUserDefaults standardUserDefaults] boolForKey:@"isAlarm"];
            if (self.isAlarm) {
                cell.cell_switch.on=YES;
                //确立通知
                [self startNotifi];
            }else{
                cell.cell_switch.on=NO;
                //取消通知
                for (NSDictionary *dic in [[AddModel shareAddMode] selectEveryThing]) {
                    for (NSInteger i=1; i<8; i++)  {
                        [self removePending:[NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]]];//取消指定标识符下的通知
                    }
                }
            }
            [[cell.cell_switch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (cell.cell_switch.isOn) {
                    //打开每日待办项目提醒
                    //重新确立通知
                    [self startNotifi];
                }else{
                    //关闭每日待办项目提醒
                    //根据标识取消每日通知
                    //循环所有任务取消所有通知
                     for (NSDictionary *dic in [[AddModel shareAddMode] selectEveryThing]) {
                         for (NSInteger i=1; i<8; i++)  {
                             [self removePending:[NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]]];//取消指定标识符下的通知
                         }
                     }
                }
             [[NSUserDefaults standardUserDefaults] setBool:!self.isAlarm forKey:@"isAlarm"];
            }];
            
            return cell;
        }else if (indexPath.row==1){
            SetSwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_switch];
            if (cell==nil) {
                cell=[[SetSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_switch];
            }
            cell.cell_title.text=@"每日签到提醒";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
            self.isSign=[[NSUserDefaults standardUserDefaults] boolForKey:@"isSign"];
            //初始化，判断偏好设置中是否打开
            if (self.isSign) {
                cell.cell_switch.on=YES;
                //如果打开按钮
                //重新确立通知
                [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
                    {
                        //从偏好设置中拿到关于通知时间的字符串
                        NSString *hour=[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_hour"];
                        NSString *minute=[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_minute"];
                        
                        for (NSInteger i=1; i<8; i++) {
                            UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"每日签到" options:UNNotificationActionOptionForeground];
                            
                            UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                            
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                            
                            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                            content.title = @"每日签到";
                            //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                            content.body = @"今天完成任务了吗,回到App记录一下吧！";
                            content.badge = @1;
                            NSError *error = nil;
                            NSString *path = [[NSBundle mainBundle] pathForResource:@"跑步机" ofType:@"png"];
                            
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
                            component.hour = [hour integerValue];
                            component.minute=[minute integerValue];
                            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                            
                            // 4.设置UNNotificationRequest
                            NSString *requestIdentifer =[NSString stringWithFormat:@"%ld_notifi_Serious",i];
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                            
                            //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            }];
                        }
                    }else{
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
                
              
            }else{
                cell.cell_switch.on=NO;
                for (NSInteger i=1; i<8; i++)  {
                    [self removePending:[NSString stringWithFormat:@"%ld_notifi_Serious",i]];//取消指定标识符下的通知
                }
            }
            //按钮的点击事件
            [[cell.cell_switch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (cell.cell_switch.isOn) {
                    //如果打开按钮
                    //重新确立通知
                    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
                        {
                            //从偏好设置中拿到关于通知时间的字符串
                            NSString *hour=[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_hour"];
                            NSString *minute=[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_minute"];
                            
                            for (NSInteger i=1; i<8; i++) {
                                UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"每日签到" options:UNNotificationActionOptionForeground];
                                
                                UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                                
                                [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                                
                                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                                content.title = @"每日签到";
                                //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                                content.body = @"今天完成任务了吗,回到App记录一下吧！";
                                content.badge = @1;
                                NSError *error = nil;
                                NSString *path = [[NSBundle mainBundle] pathForResource:@"跑步机" ofType:@"png"];
                                
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
                                component.hour = [hour integerValue];
                                component.minute=[minute integerValue];
                                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                                
                                // 4.设置UNNotificationRequest
                                NSString *requestIdentifer =[NSString stringWithFormat:@"%ld_notifi_Serious",i];
                                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                                
                                //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                }];
                            }
                        }else{
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
                    
                }else{
                    //如果关闭按钮
                    //取消通知
                    for (NSInteger i=1; i<8; i++)  {
                        [self removePending:[NSString stringWithFormat:@"%ld_notifi_Serious",i]];//取消指定标识符下的通知
                    }
                }
                
                [[NSUserDefaults standardUserDefaults] setBool:!self.isSign forKey:@"isSign"];
            }];
            return cell;
        }else if (indexPath.row==2){
            SetLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_label];
            if (cell==nil) {
                cell=[[SetLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_label];
            }
            
            cell.title_label.text=@"每日签到提醒时间";
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_hour"] isEqualToString:@""] | [[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_minute"] isEqualToString:@""]) {
                cell.content_label.text=@"";
            }else{
                cell.content_label.text=[NSString stringWithFormat:@"%@点%@分",[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_hour"],[[NSUserDefaults standardUserDefaults] objectForKey:@"sign_minute"]];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }else if (indexPath.row==3){
            SetLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_label];
            if (cell==nil) {
                cell=[[SetLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_label];
            }
            
            cell.title_label.text=@"提醒音乐";
            cell.content_label.text=@"Intro XX";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }else if ([tableView isEqual:self.music_tableView_set]){
        SetSwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_switch];
        if (cell==nil) {
            cell=[[SetSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_switch];
        }
        cell.cell_title.text=@"App点击音效";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
        //从NSUSerDefault中拿到值
        BOOL isMusicOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isMusicOn"];
        cell.cell_switch.on=isMusicOn;
        [[cell.cell_switch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //判断并关闭
            BOOL isCell=cell.cell_switch.isOn;
            if (isCell) {
                //打开点击音效
                //runtime交换方法实现
                Method oldMethod=class_getInstanceMethod([[TapMusic shareTapMusic] class], @selector(playSoundEffect));
                Method newMethod=class_getInstanceMethod([[TapMusic shareTapMusic] class], @selector(empty));
                method_exchangeImplementations(oldMethod, newMethod);
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMusicOn"];

            }else{
                //关闭点击音效
                 //runtime交换方法实现
                Method oldMethod=class_getInstanceMethod([[TapMusic shareTapMusic] class], @selector(playSoundEffect));
                Method newMethod=class_getInstanceMethod([[TapMusic shareTapMusic] class], @selector(empty));
                method_exchangeImplementations(oldMethod, newMethod);
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMusicOn"];
            }
        }];
        
        return cell;
    }else if ([tableView isEqual:self.about_tableView_set]){
        if (indexPath.row==0) {
            SetLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_label];
            if (cell==nil) {
                cell=[[SetLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_label];
            }
            
            cell.title_label.text=@"版本";
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"]; // 当前应用软件版本  比如：1.0.1
            cell.content_label.text=appCurVersion;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }else if (indexPath.row==1){
            SetLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_label];
            if (cell==nil) {
                cell=[[SetLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_label];
            }
            
            cell.title_label.text=@"反馈给开发者";
            cell.content_label.text=@"";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }else if ([tableView isEqual:self.donate_tableView_set]){
//        if (indexPath.row==0) {
//            SetLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_label];
//            if (cell==nil) {
//                cell=[[SetLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_label];
//            }
//
//            cell.title_label.text=@"我的产品真的帮到了你";
//            cell.content_label.text=@"捐赠";
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//
//            return cell;
//        }else if (indexPath.row==1){
//            ShareTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_share];
//            if (cell==nil) {
//                cell=[[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_share];
//            }
//
//            cell.title_label.text=@"分享";
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//
//            return cell;
//        }else if (indexPath.row==2){
//            SetLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_label];
//            if (cell==nil) {
//                cell=[[SetLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_label];
//            }
//
//            cell.title_label.text=@"给个好评";
//            cell.content_label.text=@"";
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//
//            return cell;
//        }
        ShareTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_share];
        if (cell==nil) {
            cell=[[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_share];
        }
        
        cell.title_label.text=@"分享";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //通知的tableView操作
    if ([tableView isEqual:self.notifi_tableView_set]) {
        if (indexPath.row==2) {
            //每日签到提醒的时间
            
            //添加选取器view
            SignView *signView=[[SignView alloc] initWithFrame:CGRectMake(0, 900, SCREEN_WIDTH, SCREEN_HEIGHT*0.45)];
            [self.view addSubview:signView];
            //动态的把signView拉上来
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                signView.frame=CGRectMake(0, SCREEN_HEIGHT*0.55, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            } completion:nil];
            //订阅取消按钮的信号
            [[signView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                signView.frame=CGRectMake(0, 900, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                [signView removeFromSuperview];
            }];
            //订阅完成按钮的信号
            [[signView.finishPickerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                signView.frame=CGRectMake(0, 900, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                SetLabelTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
                cell.content_label.text=signView.signString;
                [signView removeFromSuperview];
                
                NSString *hour;
                NSString *minute;
                //对拿到的字符串进行处理，
                if ([[cell.content_label.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"点"]) {
                    hour=[cell.content_label.text substringWithRange:NSMakeRange(0, 1)];
                    if ([[cell.content_label.text substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"分"]) {
                        minute=[cell.content_label.text substringWithRange:NSMakeRange(2, 1)];
                    }else{
                        minute=[cell.content_label.text substringWithRange:NSMakeRange(2, 2)];
                    }
                }else{
                    hour=[cell.content_label.text substringWithRange:NSMakeRange(0, 2)];
                    if ([[cell.content_label.text substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"分"]) {
                        minute=[cell.content_label.text substringWithRange:NSMakeRange(3, 1)];
                    }else{
                        minute=[cell.content_label.text substringWithRange:NSMakeRange(3, 2)];
                    }
                }
                //判断每日签到按钮是否打开了（默认按钮是打开的）
                if (self.isSign) {
                    //先撤销了确立的签到通知，然后再确认，防止确认两次同样的tong zhi
                    for (NSInteger i=1; i<8; i++)  {
                        [self removePending:[NSString stringWithFormat:@"%ld_notifi_Serious",i]];//取消指定标识符下的通知
                    }
                     //1.如果按钮是开着的，就确立通知
                    //确立通知
                    //现在使用的是最笨的办法循坏来确立通知时间----->如果有更好的办法则升级
                    for (NSInteger i=1; i<8; i++) {
                        UNNotificationAction *action= [UNNotificationAction actionWithIdentifier:@"action" title:@"每日签到" options:UNNotificationActionOptionForeground];
                        
                        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                        
                        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category,nil]];
                        
                        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                        content.title = @"每日签到";
                        //获取对应到的每日一句，1.每日一句API？2.或者是本地的数组，然后每个项目跟随一句
                        content.body = @"今天完成任务了吗,回到App记录一下吧！";
                        content.badge = @1;
                        NSError *error = nil;
                        NSString *path = [[NSBundle mainBundle] pathForResource:@"跑步机" ofType:@"png"];
                        
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
                        component.hour = [hour integerValue];
                        component.minute=[minute integerValue];
                        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
                        
                        // 4.设置UNNotificationRequest
                        NSString *requestIdentifer =[NSString stringWithFormat:@"%ld_notifi_Seriuos",i];
                        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
                        
                        //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        }];
                        
                        //在NSUserDefault存储值
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",hour] forKey:@"sign_hour"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",minute] forKey:@"sign_minute"];
                    }
                }else{
                     //2.如果按钮是关着的，就不确立通知,只存储值到偏好设置
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",hour] forKey:@"sign_hour"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",minute] forKey:@"sign_minute"];
                }
            }];
        }else if (indexPath.row==3){
            if (!self.musicSelctView) {
                 self.musicSelctView=[[MusicSelect alloc] initWithFrame:CGRectMake(20, 950, (SCREEN_WIDTH-40), 200)];
            }
            [self.view addSubview:self.musicSelctView];
            self.musicSelctView.musicTableView.delegate=self;
            //动画显示到当前屏幕中心
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.musicSelctView.frame=CGRectMake(20, (SCREEN_HEIGHT-200-64)/2, (SCREEN_WIDTH-40), 200);
            } completion:nil];
            [[self.musicSelctView.close_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.musicSelctView.frame=CGRectMake(20, 950, (SCREEN_WIDTH-40), 200);
                } completion:nil];
            }];
        }
    }
    
    
    //捐赠tableView的操作
    if ([tableView isEqual:self.donate_tableView_set]){
//        if(indexPath.row==0){
//            //捐赠给开发者
//            [self.navigationController pushViewController:[[DonateViewController alloc] init] animated:true];
//        }
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            if (platformType==UMSocialPlatformType_WechatTimeLine) {
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            }else if (platformType==UMSocialPlatformType_WechatSession){
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            }
        }];
        
    }
    //反馈给开发者
    if ([tableView isEqual:self.about_tableView_set]) {
        if (indexPath.row==0) {
            [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:true];
        }
        
        if (indexPath.row==1) {
            //反馈给开发者
            BOOL isSendEmail = [MFMailComposeViewController canSendMail];
            if (!isSendEmail) {
                // 不可发送邮件
                NSLog(@"不可发送邮件");
                return ;
            }
            // 创建对象
            MFMailComposeViewController * emailVc = [[MFMailComposeViewController alloc]init];
            // 设置邮件的代理
            emailVc.mailComposeDelegate = self;
            // 设置邮件的主题
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];// app名称
            if (app_Name) {
            
            }else{
                app_Name=@"Will Power";
            }
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// app版本
            NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];//手机系统版本
            NSString* phoneModel = [[UIDevice currentDevice] model]; //手机型号
//            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"]; // 当前应用软件版本  比如：1.0.1
            [emailVc setSubject:[NSString stringWithFormat:@"%@ %@ %@ %@",app_Name,app_Version,phoneModel,phoneVersion]];//设置邮件的主题
            
            // TODO: To、Cc、Bcc 的区别
            // To: 是发送给指定的某一个人。
            // Cc: 是 Carbon Copy 的缩写。是抄送的意思。收件人可以看到邮件还抄送给其他的那些人。
            // Bcc : 是 Blind Carbon Copy 的缩写。是秘密抄送的意思。收件人看不到还抄送了其他的那些人。
            // 设置发送单一指定邮件的接收人
            [emailVc setToRecipients:@[@"15048471585@163.com"]];
            // 设置抄送人
            [emailVc setCcRecipients:@[@"397879704@qq.com"]];
            // 设置密送人
            [emailVc setBccRecipients:@[@"15048471585@163.com"]];
            
            // 调出界面
            [self presentViewController:emailVc animated:YES completion:nil];
        }
    }
    
    //这是音乐选择的tableView的点击事件
    if ([tableView isEqual:self.musicSelctView.musicTableView]) {
        //动画显示到屏幕下面
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.musicSelctView.frame=CGRectMake(20, 950, (SCREEN_WIDTH-40), 200);
        } completion:nil];
    }
}

#pragma mark 邮件发送后结果处理代理
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    // 邮件发送结果的处理
    switch (result) {
            // 用户取消邮件发送
        case MFMailComposeResultCancelled:{
            [self alertWithMessage:@"用户取消"];
        }
            break;
            // 邮件保存草稿箱
        case MFMailComposeResultSaved:{
            [self alertWithMessage:@"邮件已保存"];
        }
            break;
            // 邮件发送成功
        case MFMailComposeResultSent:{
            [self alertWithMessage:@"邮件发送成功"];
        }
            break;
            // 邮件发送失败
        case MFMailComposeResultFailed:{
            [self alertWithMessage:@"邮件发送失败"];
        }
            break;
            
        default:
            break;
    }
    // 清楚发送邮件的界面
    [controller dismissViewControllerAnimated:YES completion:nil];
}
// 消息提示(自动消失)
-(void)alertWithMessage:(NSString*)message {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [alertVc dismissViewControllerAnimated:YES completion:^{
                    [timer invalidate];
                }];
            }];
        }];
    });
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"「分享」 Will Power 自控力 美好的生活源于自控" descr:@"" thumImage:[UIImage imageNamed:@"Rectangle 21"]];
    //设置网页地址
    shareObject.webpageUrl =@"https://kangleon.github.io/2018/07/01/Will%20Power/";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
