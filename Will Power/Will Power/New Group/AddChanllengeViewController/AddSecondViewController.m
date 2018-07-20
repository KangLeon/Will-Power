//
//  AddSecondViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

//该VC代码太多，太厚重，希望可以分散一下业务逻辑到其他页面


#import "AddSecondViewController.h"
#import "AlertView.h"
#import "ColorDefine.h"
#import <FlatUIKit.h>
#import <ReactiveObjC.h>
#import "TapMusicButton.h"
#import "SizeDefine.h"
#import "PickerTableViewCell.h"
#import <Masonry.h>
#import "AddSecondView.h"
#import "SwitchTableViewCell.h"
#import "AddTableViewCell.h"
#import "NotifiModel.h"
#import "AddThirdViewController.h"
#import "AddModel.h"
#import "NSString+DateTitle.h"
#import <SCLAlertView.h>
#import "WrongMusic.h"
#import <UserNotifications/UserNotifications.h>
#import "NSDate+LocalDate.h"
#import "NSString+DateTitle.h"

static NSString *cell_picker_id=@"picker";
static NSString *cell_picker_id_notifi=@"picker_notifi";
static NSString *cell_picker_id_add=@"picker_add";

@interface AddSecondViewController ()<FUIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)AddSecondView *secondView;//选取器view

@property(nonatomic,strong)AlertView *alertView;

//第一个tableView的相关部分
@property(nonatomic,strong) UITableView *datePick_tableView;//设置坚持目标和项目开始日期的tableView
@property(nonatomic,strong)NSArray *cellTitle;//cell标题的array
@property(nonatomic,strong)NSArray *cellImageName;//cell图片的array
@property(nonatomic,strong) UIView *forTableView;//第一个tableView的父view

//第二个tableView的相关部分
@property(nonatomic,strong) UITableView *datePick_tableView_notifi;//提醒时间tableView
@property(nonatomic,strong)NSArray *cellTitle_notifi;//cell标题的array
@property(nonatomic,strong)NSMutableArray *cellTitle_added;//cell添加的标题的array
@property(nonatomic,strong)NotifiModel *notifiModel;
@property(nonatomic,strong)NSArray *cellImageName_notifi;//cell图片的array
@property(nonatomic,strong) UIView *forTableView_notifi;//第二个tavleView的父view

//保存从viwe传过来的字符串值
@property(nonatomic,strong)NSString *repeat_goal_forShow;//设置坚持目标的显示label
@property(nonatomic,strong)NSString *start_date_forShow;//设置起始日期的显示label
@property(nonatomic,strong)NSString *alarm_date_forShow;//提醒的时间的label


@end

@implementation AddSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navItem];
    [self navTitle];
    [self loadUI];
}

//配置UI
-(void)loadUI{
    [self.view addSubview:self.secondView];
    
    [self.forTableView addSubview:self.datePick_tableView];
    [self.secondView addSubview:self.forTableView];
    [self.secondView sendSubviewToBack:self.forTableView];
    
    //初始化array
    self.cellTitle=@[@"设置坚持目标",@"设置起始日期"];
    self.cellImageName=@[@"repeat_image",@"start_repeat_image"];
    
    
    //1.坚持目标的picker操作
    //取消❌按钮的点击
    [[self.secondView.cancelButton_repeat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }else{
                self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }
        } completion:nil];
    }];
    
    //给完成按钮设置监听事件
    //完成按钮的点击，应该保存数据
    [[self.secondView.finishPickerButton_repeat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }else{
                self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }
            //完成按钮里面不仅有收起日期选取器的业务逻辑，还应该把选择好的日期显示在右边的label上，还应该把值存在model中
            //1.第一步显示值
            self.repeat_goal_forShow=self.secondView.repeat_str;
            [self.datePick_tableView reloadData];
            //2.第二步存值到Addmodel中
            //通过判断文字然后转换成相应整形值，这里的操作是在类别中做的
            [AddModel shareAddMode].goal_total=[self.repeat_goal_forShow gotalStringToInteger:self.repeat_goal_forShow];//总共重复几天这里是NSInteger类型的
        } completion:nil];
    }];
    
    //2.起始时间的picker操作
    [[self.secondView.cancelButton_start rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }else{
                self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }
        } completion:nil];
    }];
    
    //给完成按钮添加点击事件
    //完成按钮的点击，应该保存数据
    [[self.secondView.finishPickerButton_start rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }else{
                self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }
            //这里需要有一个判断逻辑来判断是否选择的日期是之前的日期，之前的日期是不可选取的
            if([self.secondView.start_str isEqualToString:@"不正确的日期"] | [self.secondView.start_str isEqualToString:@"2018年1月1日"]){
                //弹出警告框，选择了不正确的日期
                
                WrongMusic *wrongMusic=[[WrongMusic alloc] init];
                [wrongMusic playSoundEffect_wrong];
                
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self title:@"不正确的起始日期" subTitle:@"起始日期不可以选择过去的时间" closeButtonTitle:@"好的，重新选择" duration:0.0f];
            }else{
                //正常执行
                //完成按钮里面不仅有收起日期选取器的业务逻辑，还应该把选择好的日期显示在右边的label上，还应该把值存在model中
                //1.第一步显示值
                self.start_date_forShow=self.secondView.start_str;
                [self.datePick_tableView reloadData];
                //2.第二步存值到Addmodel中
                [AddModel shareAddMode].start_date=self.start_date_forShow;//存到model中是字符串类型的
            }
            
            
        } completion:nil];
    }];
    
    //3.提醒时间的picker操作
    //取消❌按钮的点击
    [[self.secondView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }else{
                self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }
        } completion:nil];
    }];
    
    //给完成按钮添加点击事件
    //完成按钮的点击，应该保存数据
    [[self.secondView.finishPickerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }else{
                self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            }
            //完成按钮里面不仅有收起日期选取器的业务逻辑，还应该把选择好的日期显示在右边的label上，还应该把值存在model中
            self.alarm_date_forShow=self.secondView.alarm_str;
            //从字典中删除最后一项值，把新值添加进去，然后刷新字典
            //1.第一步显示值
            //一个字典删除旧值添加新值
            [self.cellTitle_added removeObjectAtIndex:self.cellTitle_added.count-1];
            [self.cellTitle_added addObject:self.alarm_date_forShow];
            //第二个字典执行同样的操作
            [self.notifiModel.notifi_date_array removeObjectAtIndex:self.notifiModel.notifi_date_array.count-1];
            [self.notifiModel.notifi_date_array addObject:self.alarm_date_forShow];
            [self.datePick_tableView_notifi reloadData];
            
            NSLog(@"这里notifiModel.notifi_date_array的值%@",self.notifiModel.notifi_date_array);
            
            //2.第二步存值到model中
            //这个操作在上面第一步就做了
        } completion:nil];
    }];
    
    
    
    
    //选择提醒时间
    //选择坚持目标与设置起始日期
    
    //初始化array
    self.cellTitle_notifi=@[@"提醒未开启"];//后面这里应该改成可变数组，或者从model里面拿值，因为是提醒时间
    self.cellImageName_notifi=@[@"clock_image",@"minus_image",@"plus_image"];
    self.cellTitle_added=[[NSMutableArray alloc] init];
    self.notifiModel=[NotifiModel notifiModel];//初始化model
    self.notifiModel.notifi_date_array=[[NSMutableArray alloc] init];
    

    [self.forTableView_notifi addSubview:self.datePick_tableView_notifi];
    [self.secondView addSubview:self.forTableView_notifi];
    [self.secondView sendSubviewToBack:self.forTableView_notifi];//这里是因为forTableView_notifi是后来添加的，所以他会覆盖选取器，这里把forTableView_notifi放置到最底层，已解决该问题
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"我要做" message:@"科学的自控方法并不是”暴力自控“：明天开始我就变了成了一个绝对完美自控的人，而是培养习惯，来达到自控。\n接下来请完成您自控力养成计划" cancelButtonTitle:@"好的" ];
    });
}

#pragma mark --懒加载
-(AddSecondView *)secondView{
    if (!_secondView) {
        self.secondView=[[AddSecondView alloc] initWithFrame:self.view.frame];
    }
    return _secondView;
}
- (UIView *)forTableView{
    if (!_forTableView) {
        //选择坚持目标与设置起始日期
        self.forTableView=[[UIView alloc]initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, 59*2)];
        self.forTableView.backgroundColor=[UIColor whiteColor];
        self.forTableView.layer.cornerRadius=12;
    }
    return _forTableView;
}
-(UITableView *)datePick_tableView{
    if (!_datePick_tableView) {
        self.datePick_tableView=[[UITableView alloc] init];
        self.datePick_tableView.frame=CGRectMake(0,4,SCREEN_WIDTH-20,60*2);
        self.datePick_tableView.dataSource=self;
        self.datePick_tableView.delegate=self;
        self.datePick_tableView.layer.cornerRadius=12;
        self.datePick_tableView.scrollEnabled=NO;
        
        [self.datePick_tableView registerClass:[PickerTableViewCell class] forCellReuseIdentifier:cell_picker_id];
    }
    return _datePick_tableView;
}
- (UIView *)forTableView_notifi{
    if (!_forTableView_notifi) {
        self.forTableView_notifi=[[UIView alloc]initWithFrame:CGRectMake(10, 177, SCREEN_WIDTH-20, 59*(self.cellTitle_notifi.count+self.cellTitle_added.count))];//根据项目数来决定frame的大小
        
        self.forTableView_notifi.backgroundColor=[UIColor whiteColor];
        self.forTableView_notifi.layer.cornerRadius=12;
    }
    return _forTableView_notifi;
}
- (UITableView *)datePick_tableView_notifi{
    if (!_datePick_tableView_notifi) {
        self.datePick_tableView_notifi=[[UITableView alloc] init];
        self.datePick_tableView_notifi.frame=CGRectMake(0,4,SCREEN_WIDTH-20,60*(self.cellTitle_notifi.count+self.cellTitle_added.count));//根据项目数来决定frame的大小
        self.datePick_tableView_notifi.dataSource=self;
        self.datePick_tableView_notifi.delegate=self;
        self.datePick_tableView_notifi.layer.cornerRadius=12;
        self.datePick_tableView_notifi.scrollEnabled=NO;
        
        [self.datePick_tableView_notifi registerClass:[SwitchTableViewCell class] forCellReuseIdentifier:cell_picker_id_notifi];
        [self.datePick_tableView_notifi registerClass:[AddTableViewCell class] forCellReuseIdentifier:cell_picker_id_add];

    }
    return _datePick_tableView_notifi;
}

#pragma mark --配置导航栏相关

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"我要做";
    titleLabel.textColor=BACKGROUND_COLOR;
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
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
    //右上帮助按钮
    TapMusicButton *barButton_right_help=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_help.backgroundColor=[UIColor clearColor];
    [barButton_right_help setImage:[UIImage imageNamed:@"need_help_image"] forState:UIControlStateNormal];
    [[barButton_right_help rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"我要做" message:@"科学的自控方法并不是”暴力自控“：明天开始我就变了成了一个绝对完美自控的人，而是培养习惯，来达到自控。\n接下来请完成您自控力养成计划" cancelButtonTitle:@"好的" ];
    }];
    
    UIBarButtonItem *barButtonItem_right_help=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_help];
    
    //右上下一步按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"next_image"] forState:UIControlStateNormal];
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        //页面跳转验证
        if ([self.repeat_goal_forShow length]>0&&[self.start_date_forShow length]>0&&self.cellTitle_added.count>0) {
            AddThirdViewController *addThird_VC=[[AddThirdViewController alloc] init];
            [self.navigationController pushViewController:addThird_VC animated:true];
            
            NSLog(@"self.cellTitle_added %@",self.cellTitle_added);
            NSInteger for_plus=[[NotifiModel notifiModel] countForData];//sb
            //完成数据存储
            //从字典中遍历值，填充到数据库中
            for (NSString *alarm_string in self.cellTitle_added) {
                //对字符串进行判断处理
                
                NSString *day_type;
                NSString *hour_type;
                NSString *minute_type;
                
                //第一个滚轮的逻辑 一.
                if([[alarm_string substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"每"]){
                    if ([[alarm_string substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"周"]) {
                        //第一个滚轮的逻辑 二.
                        day_type=[alarm_string substringWithRange:NSMakeRange(0, 3)];
                        //第二个滚轮的逻辑 a.
                        if([[alarm_string substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"点"]){
                            hour_type=[alarm_string substringWithRange:NSMakeRange(3, 1)];
                            //第三个滚轮的逻辑 1.
                            if ([[alarm_string substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]) {
                                minute_type=[alarm_string substringWithRange:NSMakeRange(5, 1)];
                            }else if ([[alarm_string substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]){
                                minute_type=[alarm_string substringWithRange:NSMakeRange(5, 2)];
                            }
                            
                            //第二个滚轮的逻辑 b.
                        }else if ([[alarm_string substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"点"]){
                            hour_type=[alarm_string substringWithRange:NSMakeRange(3, 2)];
                            //第三个滚轮的逻辑 2.
                            if ([[alarm_string substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]) {
                                minute_type=[alarm_string substringWithRange:NSMakeRange(6, 1)];
                            }else if ([[alarm_string substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"分"]){
                                minute_type=[alarm_string substringWithRange:NSMakeRange(6, 2)];
                            }
                        }
                    }else{
                        day_type=[alarm_string substringWithRange:NSMakeRange(0, 2)];
                        //第二个滚轮的逻辑 a.
                        if([[alarm_string substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"点"]){
                            //第三个滚轮的逻辑 1.
                            hour_type=[alarm_string substringWithRange:NSMakeRange(2, 1)];
                            if ([[alarm_string substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"分"]) {
                                minute_type=[alarm_string substringWithRange:NSMakeRange(4, 1)];
                            }else if ([[alarm_string substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]){
                                minute_type=[alarm_string substringWithRange:NSMakeRange(4, 2)];
                            }
                            
                            //第二个滚轮的逻辑 b.
                        }else if ([[alarm_string substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"点"]){
                            hour_type=[alarm_string substringWithRange:NSMakeRange(2, 2)];
                            //第三个滚轮的逻辑 2.
                            if ([[alarm_string substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]) {
                                minute_type=[alarm_string substringWithRange:NSMakeRange(5, 1)];
                            }else if ([[alarm_string substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]){
                                minute_type=[alarm_string substringWithRange:NSMakeRange(5, 2)];
                            }
                        }
                    }
                }else{
                    //第一个滚轮的逻辑 二.
                    day_type=[alarm_string substringWithRange:NSMakeRange(0, 3)];
                    //第二个滚轮的逻辑 a.
                    if([[alarm_string substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"点"]){
                        hour_type=[alarm_string substringWithRange:NSMakeRange(3, 1)];
                        //第三个滚轮的逻辑 1.
                        if ([[alarm_string substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]) {
                            minute_type=[alarm_string substringWithRange:NSMakeRange(5, 1)];
                        }else if ([[alarm_string substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]){
                            minute_type=[alarm_string substringWithRange:NSMakeRange(5, 2)];
                        }
                        
                        //第二个滚轮的逻辑 b.
                    }else if ([[alarm_string substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"点"]){
                        hour_type=[alarm_string substringWithRange:NSMakeRange(3, 2)];
                        //第三个滚轮的逻辑 2.
                        if ([[alarm_string substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]) {
                            minute_type=[alarm_string substringWithRange:NSMakeRange(6, 1)];
                        }else if ([[alarm_string substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"分"]){
                            minute_type=[alarm_string substringWithRange:NSMakeRange(6, 2)];
                        }
                    }
                }
                /*
                 这是数据库存储的提醒的数据结构,
                 1 1 每天 7,30
                 2 1 周一 9 30
                 3 1 周二 8 30
                 
                 1 2 每天 7,30
                 2 2 周一 9 30
                 3 2 周二 8 30
                 */
                //每循环一次就存储一条数据到数据库
                [NotifiModel notifiModel].alarm_id=for_plus;//关联该任务的数据条数累加
                [NotifiModel notifiModel].subject_id=[AddModel shareAddMode].subject_id;
                [NotifiModel notifiModel].alarm_day=day_type;
                [NotifiModel notifiModel].alarm_hour=hour_type;
                [NotifiModel notifiModel].alarm_minute=minute_type;
                [[NotifiModel notifiModel] insertData];
                [[NotifiModel notifiModel] selectItemsIn:[AddModel shareAddMode].subject_id];//输出用于验证
                
                //问题：
                
                for_plus++;
            }
           
        }else{
            WrongMusic *wrongMusic=[[WrongMusic alloc] init];
            [wrongMusic playSoundEffect_wrong];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"仍有未选择项期" subTitle:@"请完成所有选择项后再跳转到下一步" closeButtonTitle:@"好的" duration:0.0f];
        }

    }];
    
    UIBarButtonItem *barButtonItem_right_next=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_next];
    self.navigationItem.rightBarButtonItems=@[barButtonItem_right_next,barButtonItem_right_help];
}


#pragma mark --tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.datePick_tableView]) {
        return 1;
    }
    //如果是设置提醒时间的话
    else if([tableView isEqual:self.datePick_tableView_notifi]){
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.datePick_tableView]) {
        return 2;
    }else if([tableView isEqual:self.datePick_tableView_notifi]){
         //如果是设置提醒时间的话
        return self.cellTitle_notifi.count+self.cellTitle_added.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //起始日期 坚持时间相关的cell
    //第一个tabelView
    if ([tableView isEqual:self.datePick_tableView]) {
        PickerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_picker_id];
        if (cell==nil) {
            cell=[[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_picker_id];
        }
        cell.cell_image.image=[UIImage imageNamed:self.cellImageName[indexPath.row]];
        cell.cell_title.text=self.cellTitle[indexPath.row];
        //在这里设置cell的副标题
        if (indexPath.row==0) {
            cell.cell_time.text=self.repeat_goal_forShow;
        }else if(indexPath.row==1){
            cell.cell_time.text=self.start_date_forShow;
        }
        
        return cell;
    }
     //提醒按钮相关的cell
    //第二个tableView
    if ([tableView isEqual:self.datePick_tableView_notifi]) {
        //如果是第一行
        if (indexPath.row==0) {
            SwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_picker_id_notifi];
            if (cell==nil) {
                cell=[[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_picker_id_notifi];
            }
            //给小switch添加事件
            [[cell.cell_switch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
                
                //将三个pickerView推下去，但是这里应该将frame的变考虑到，
                    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        if (self.notifiModel.notifi_date_array.count>6) {
                            
                            self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                        }else{
                            self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                        }
                    } completion:nil];

                    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        if (self.notifiModel.notifi_date_array.count>6) {
                            self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                        }else{
                            self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                        }
                    } completion:nil];

                    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        if (self.notifiModel.notifi_date_array.count>6) {
                            self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                        }else{
                            self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                        }
                    } completion:nil];
                
                //判断switch状态，然后决定怎么显示
                if (cell.cell_switch.isOn) {
                    //在这里应该判断一下是否已经获得了通知权限，如果没有获得权限，则引导用户再次进入设置大家通知权限
                    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
                        {

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
                    //一切照常
                    //打开所有显示
                    //1.
                    self.cellTitle_notifi=nil;
                    self.cellTitle_notifi=@[@"提醒已经开启",@"点击添加更多时间"];
                    //2.
                    [self.cellTitle_added removeAllObjects];
                    for (NSString *date in [NotifiModel notifiModel].notifi_date_array) {
                        [self.cellTitle_added addObject:date];
                    }
                    
                    //3.添加所有的frame动画效果
                    //因为cell的项的项目变化动态的变化frame的大小
                    [UIView animateWithDuration:0.3 animations:^{
                        self.forTableView_notifi.frame=CGRectMake(10, 177, SCREEN_WIDTH-20, 60*(self.cellTitle_notifi.count+self.cellTitle_added.count)+5);
                        self.datePick_tableView_notifi.frame=CGRectMake(0, 4, SCREEN_WIDTH-20, 60*(self.cellTitle_notifi.count+self.cellTitle_added.count));
                        if (self.notifiModel.notifi_date_array.count>6) {
                        self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                        }
                    }];
                    [tableView reloadData];
                }else{
                    //关闭通知功能，所有的通知都失效，注意：requestWithIdentifie，取消指定，或者取消所有
                    //但是这里不用主动代码关闭通知，即所有的通知都取消，不发送即可
                    
                    //关闭所有显示
                    //1.
                    if (self.cellTitle_notifi.count!=0) {
                        self.cellTitle_notifi=nil;//把字典置空
                        self.cellTitle_notifi=@[@"提醒未开启"];
                    }else{
                        self.cellTitle_notifi=@[@"提醒未开启"];
                    }
                    //2.
                    [self.cellTitle_added removeAllObjects];
                    
                    //3.收回所有的frame动画效果
                    [UIView animateWithDuration:0.3 animations:^{
                        self.forTableView_notifi.frame=CGRectMake(10, 177, SCREEN_WIDTH-20, 60+5);
                        self.datePick_tableView_notifi.frame=CGRectMake(0, 4, SCREEN_WIDTH-20, 60);
                        //将secondeView的画布大小缩小
                        self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
                    }];
                    [tableView reloadData];
                }
                
            }];
            
            cell.cell_image.image=[UIImage imageNamed:self.cellImageName_notifi[0]];
            cell.cell_title.text=self.cellTitle_notifi[0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
            //给cell添加副标题
            
            return cell;
        }
        //如果是第二行的话 添加更多时间
        if(indexPath.row==1){
            AddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_picker_id_add];
            if (cell==nil) {
                cell=[[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_picker_id_add];
            }
            cell.cell_image.image=[UIImage imageNamed:self.cellImageName_notifi[2]];
            cell.cell_title.text=self.cellTitle_notifi[1];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
            
            return cell;
        }
        //如果显示的行超过三行，除了开头行和紧随的第二行都是这个行，删除行
        else if(indexPath.row>1){
            AddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_picker_id_add];
            if (cell==nil) {
                cell=[[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_picker_id_add];
            }
            cell.cell_image.image=[UIImage imageNamed:self.cellImageName_notifi[1]];
            cell.cell_title.text=self.cellTitle_added[indexPath.row-2];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
            
            return cell;
        }
    }
    return nil;//不可能出现这种情况的
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不管是点击的哪行，都要在这里检查一下通知的权限，如果没有权限需要重新获取，
    
    //如果是点击第一个tableView的话
    if ([tableView isEqual:self.datePick_tableView]) {
        if (indexPath.row==0){
            //如果是第一行的话
            //设置坚持目标
             [self.secondView sendSubviewToBack:self.forTableView_notifi];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.notifiModel.notifi_date_array.count>6) {
                    //首先将scrollView滚动到指定位置
                    [self.secondView setContentOffset:CGPointMake(0,SCREEN_HEIGHT*0.50+60*(self.notifiModel.notifi_date_array.count-6)*0.55) animated:YES];
                    self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);//根据当前secondView的frame高计算应该将当前的选取器添加到哪里
                }else{
                    self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT*0.50, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }
                
            } completion:nil];
            //将另两个pickerView推下去
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.notifiModel.notifi_date_array.count>6) {
                    self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }else{
                    self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }
            } completion:nil];

            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.notifiModel.notifi_date_array.count>6) {
                    self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }else{
                    self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }
            } completion:nil];
           
           
            
        }else{
            //设置起始日期
            [self.secondView sendSubviewToBack:self.forTableView_notifi];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.notifiModel.notifi_date_array.count>6) {
                    //首先将scrollView滚动到指定位置
                    [self.secondView setContentOffset:CGPointMake(0,SCREEN_HEIGHT*0.50+60*(self.notifiModel.notifi_date_array.count-6)*0.55) animated:YES];
                    self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);//根据当前secondView的frame高计算应该将当前的选取器添加到哪里
                }else{
                    self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT*0.50, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }
//                self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT*0.50, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            } completion:nil];
            //将另两个pickerView推下去
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.notifiModel.notifi_date_array.count>6) {
                    self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }else{
                    self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }
            } completion:nil];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.notifiModel.notifi_date_array.count>6) {
                    self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }else{
                    self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                }
            } completion:nil];
           
        }
    }
    
    //如果是点击第二个tableView的话
    if ([tableView isEqual:self.datePick_tableView_notifi]) {
        //如果是点击开关按钮的话
        
        //如果是点击添加的话
        if (indexPath.row==0) {
            //该行是提醒是否开启的标题行
            //改行取消选中状态
            AddTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//取消选中状态
        }else{
            
            //改行是点击添加更多时间的行
            if (indexPath.row==1){

                [self.cellTitle_added addObject:@"12:00"];//添加新的提醒时间到array里面
                [self.notifiModel.notifi_date_array addObject:@"12:00"];//提醒时间的model添加新的提醒项
                
                //以下部分的动画是正常的，上面的动画是不正常的
                if (self.notifiModel.notifi_date_array.count>6) {//如果显示的提醒项的项目数多于4项的时候就扩大frame的大小
                    self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6)+SCREEN_HEIGHT*0.45);//改变secondView的画布大小
                //随着提醒时间的项变多，将边框扩大，同步把各个选取器下移
                //将所有选取器下移
            self.secondView.forPicker_view.center=CGPointMake(self.secondView.forPicker_view.center.x,self.secondView.forPicker_view.center.y+600*(self.notifiModel.notifi_date_array.count-6));
            self.secondView.forPicker_view_repeat.center=CGPointMake(self.secondView.forPicker_view_repeat.center.x, self.secondView.forPicker_view_repeat.center.y+600*(self.notifiModel.notifi_date_array.count-6));
            self.secondView.forPicker_view_start.center=CGPointMake(self.secondView.forPicker_view_start.center.x, self.secondView.forPicker_view_start.center.y+600*(self.notifiModel.notifi_date_array.count-6));
                }
                
                //将tabelview和底图view的frame变大
                [UIView animateWithDuration:0.3 animations:^{
                    self.forTableView_notifi.frame=CGRectMake(10, 177, SCREEN_WIDTH-20, 60*(self.cellTitle_notifi.count+self.cellTitle_added.count)+5);
                    self.datePick_tableView_notifi.frame=CGRectMake(0, 4, SCREEN_WIDTH-20, 60*(self.cellTitle_notifi.count+self.cellTitle_added.count));
                }];
                //在这里改变Array的值
                
                [tableView reloadData];
                
                //将提醒时间的选取器拉上来
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.notifiModel.notifi_date_array.count>6) {
                        //首先将scrollView滚动到指定位置
                        [self.secondView setContentOffset:CGPointMake(0,SCREEN_HEIGHT*0.50+60*(self.notifiModel.notifi_date_array.count-6)*0.55) animated:YES];
                        self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);//根据当前secondView的frame高计算应该将当前的选取器添加到哪里
                    }else{
                        self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT*0.50, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }
//                    self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT*0.50, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                } completion:nil];
                
                //将两外两个选取器推下去
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.notifiModel.notifi_date_array.count>6) {
                        self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }else{
                        self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }
                } completion:nil];

                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.notifiModel.notifi_date_array.count>6) {
                        self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }else{
                        self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }
                } completion:nil];
               
               
            }
            else{
                
                //如果按的是减去的行
               [self.notifiModel.notifi_date_array removeObjectAtIndex:indexPath.row-2];
                [self.cellTitle_added removeAllObjects];
                for (NSString *date in [NotifiModel notifiModel].notifi_date_array) {
                    [self.cellTitle_added addObject:date];
                }
                NSLog(@"notifiModel.notifi_date_array%@",self.notifiModel.notifi_date_array);
                //将frame缩小
                [UIView animateWithDuration:0.3 animations:^{
                    self.forTableView_notifi.frame=CGRectMake(10, 177, SCREEN_WIDTH-20, 60*(self.cellTitle_notifi.count+self.cellTitle_added.count)+5);
                    self.datePick_tableView_notifi.frame=CGRectMake(0, 4, SCREEN_WIDTH-20, 60*(self.cellTitle_notifi.count+self.cellTitle_added.count));
                }];
                
                //收起所有的选取器
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.notifiModel.notifi_date_array.count>6) {
                        
                        self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }else{
                        self.secondView.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }
                } completion:nil];
                
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.notifiModel.notifi_date_array.count>6) {
                        self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }else{
                        self.secondView.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }
                } completion:nil];
                
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.notifiModel.notifi_date_array.count>6) {
                        self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT+600*(self.notifiModel.notifi_date_array.count-6), SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }else{
                        self.secondView.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                    }
                } completion:nil];
                
                //改变secondView画布的大小
                if (self.notifiModel.notifi_date_array.count>6) {
                self.secondView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60*(self.notifiModel.notifi_date_array.count-6));//改变secondView的画布大小
                }
                
                [tableView reloadData];
            }
        }
    }
    [tableView reloadData];
}

#pragma mark target-action方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
