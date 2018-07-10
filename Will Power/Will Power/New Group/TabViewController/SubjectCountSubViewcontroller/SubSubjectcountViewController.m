//
//  SubSubjectcountViewController.m
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubSubjectcountViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import "TapMusicButton.h"
#import <ReactiveObjC.h>
#import "SubjectCountView.h"
#import "SubjectCountViewController.h"
#import "CalendenView.h"
#import "AddModel.h"
#import "NSString+DateTitle.h"
#import "NSDate+LocalDate.h"
#import "CheckedModel.h"
#import "PopRemarkView.h"
#import "SubjectDeleteViewController.h"

@interface SubSubjectcountViewController ()

@end

@implementation SubSubjectcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navItem];
    [self navTitle];
    [self loadUI];
}

#pragma mark 懒加载部分


-(void)loadUI{
    SubjectCountView *view_subject1=[[SubjectCountView alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH, SCREEN_HEIGHT*0.3)];
    
    //1.项目概览的情况部分
    view_subject1.titleLabel.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.index] objectForKey:@"subject_title"];
    view_subject1.repeatDay_label.text=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:self.index+1] count]];
    //设置DayView的判断逻辑
    if ([view_subject1.repeatDay_label.text isEqualToString:@"0"]) {
        view_subject1.dayView.day_label.text=@"Day";
    }else{
        view_subject1.dayView.day_label.text=@"Days";
    }
    view_subject1.goalDiscription.text=[NSString stringWithFormat:@"距%@天目标还有",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.index] objectForKey:@"goal_total"]];
    
    view_subject1.goalDay_label.text=[NSString stringWithFormat:@"%ld",[self countDaysAtIndex:self.indexPath]]; //距离目标天数还有多少天，这里需要再次修改lable的frame值
    //设置DayView的判断逻辑
    if ([view_subject1.goalDay_label.text isEqualToString:@"0"]) {
        view_subject1.dayView_goal.day_label.text=@"Day";
    }else{
        view_subject1.dayView_goal.day_label.text=@"Days";
    }
    
    view_subject1.subject_start_time.text=[NSString stringWithFormat:@"Since %@",[[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.index] objectForKey:@"start_date"] startDateForm:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.index] objectForKey:@"start_date"]]];
    view_subject1.reward_label.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.index] objectForKey:@"reward"];
    
    [self.view addSubview:view_subject1];
    
    
    //滚动视图部分
    UIScrollView *scollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.1);
    scollView.showsVerticalScrollIndicator=false;
    
    //2.日历view部分
    self.view_calender=[[CalendenView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT*0.35+26+10, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.6)];
    self.view_calender.index_calender=self.index+1;
    
    //在这里设置日历的统计情况。日历统计情况的业务逻辑
    //思路：
    //一.每月统计模式
    //1.完成任务在日历cell上标记具体日期
    //2.日历cell可查看当天存储的备注，->可操作弹出框,
    //二.年度统计模式
    //1.完成任务在日历上标记具体日期
    //2.改正月份在年度统计模式下的单元格数目
    
    [scollView addSubview:view_subject1];
    [scollView addSubview:self.view_calender];
    
    [self.view addSubview:scollView];
    
    //监听通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stpopup:) name:@"stpopup" object:nil];
    
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text=@"Will Power";
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
    
    //右上下一步按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"edit_image"] forState:UIControlStateNormal];
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        SubjectDeleteViewController *delete_VC=[[SubjectDeleteViewController alloc] init];
        delete_VC.delete_index=self.index;
        [self.navigationController pushViewController:delete_VC animated:true];
    }];
    
    UIBarButtonItem *barButtonItem_right_next=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_next];
    self.navigationItem.rightBarButtonItem=barButtonItem_right_next;
    
}

#pragma mark target-Action的方法

//用来计算距离目标天数还有多少天的方法
-(NSInteger)countDaysAtIndex:(NSIndexPath*)indexPath{
    //完成时间格式的转换，计算相隔时间
    //1.拿到当前时间
    NSDate *currentDate=[NSDate localdate];
    //2.拿到项目开始时间
    NSString *startDate_String=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"start_date"];
    //3.将项目开始时间字符串转换成date
    NSDate *startDate=[self dateFrom:startDate_String];//2018-07-05 00:00 UTC
    //4.计算当前时间与项目开始时间之间的间隔
    NSTimeInterval timeInterval=[currentDate timeIntervalSinceDate:startDate];
    //5.计算时间间隔总共换算为多少天
    //计算天数
    NSInteger days = ((NSInteger)timeInterval)/(3600*24);
    //6.获得数据库中总目标天数
    NSInteger total_days=[[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"goal_total"] integerValue];
    
    return total_days-days;
}

//暂时先不做item的点击弹出事件
//#pragma mark --通知的selector方法
//-(void)stpopup:(NSNotification *)noti{
//
//    //添加可操作view
//    PopRemarkView *pop_remark=[[PopRemarkView alloc] init];
//    [self.view addSubview:pop_remark];
//
//    //设置view里面的内容
//
//
//
//    //动画显示view到视图中心
//
//
//}

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
