//
//  SubjectCountViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubjectCountViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import "TapMusicButton.h"
#import <ReactiveObjC.h>
#import "SubjectCountView.h"
#import "SubSubjectcountViewController.h"
#import "CalendenView.h"
#import "AddModel.h"
#import "SubjectCountViewCell.h"
#import "NSString+DateTitle.h"
#import "NSDate+LocalDate.h"
#import "CheckedModel.h"
#import "EmptyView.h"
#import "GetColor.h"

static NSString *cell_id1=@"subject_cell_1";
static NSString *cell_id2=@"subject_cell_2";
static NSString *cell_id3=@"subject_cell_3";

@interface SubjectCountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *firstTableView;
@property(nonatomic,strong)UITableView *secondTableView;
@property(nonatomic,strong)UITableView *thirdTableView;

@end

@implementation SubjectCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navItem];
    [self navTitle];
    [self loadUI];
}

-(void)loadUI{
    
    //添加在滚动视图上防止项目多的的时候一个页面无法显示所有内容
    UIScrollView *scollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);//画布大小
    scollView.showsVerticalScrollIndicator=false;
    
    //从数据库中查数据，查询当前有几条数据
    for (NSInteger i=0; i<4; i++) {
        if ([[AddModel shareAddMode] countForData]==0) {
            //当前数据库中没有数据
            //显示空数据的视图（采用第三方库）
            EmptyView *empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 100, 288, 341)];
            empty.imageView.image=[UIImage imageNamed:@"empty_mission_2_image"];
            
            [self.view addSubview:empty];
        }else if([[AddModel shareAddMode] countForData]==1){
            //当前数据库中有一条数据
            //创建一个项目view并显示
            [scollView addSubview:self.firstTableView];
        }else if([[AddModel shareAddMode] countForData]==2){
            //当前数据库中有两条数据
            //创建一个项目view并显示
            [scollView addSubview:self.firstTableView];
            [scollView addSubview:self.secondTableView];
        }else if([[AddModel shareAddMode] countForData]==3){
            //当前数据库中有一条数据
            //创建一个项目view并显示
            scollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.4);//改变画布大小
            [scollView addSubview:self.firstTableView];
            [scollView addSubview:self.secondTableView];
            [scollView addSubview:self.thirdTableView];
        }
    }
    
    [self.view addSubview:scollView];
    
}
#pragma mark 懒加载

-(UITableView *)firstTableView{
    if (!_firstTableView) {
        _firstTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35)];
        _firstTableView.dataSource=self;
        _firstTableView.delegate=self;
        _firstTableView.scrollEnabled=false;
        _firstTableView.backgroundColor=[UIColor whiteColor];
        _firstTableView.layer.cornerRadius=12.0;
        [_firstTableView registerClass:[SubjectCountViewCell class] forCellReuseIdentifier:cell_id1];
    }
    return _firstTableView;
}
-(UITableView *)secondTableView{
    if (!_secondTableView) {
        _secondTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 26+SCREEN_HEIGHT*0.35+26, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35)];
        _secondTableView.dataSource=self;
        _secondTableView.delegate=self;
        _secondTableView.scrollEnabled=false;
        _secondTableView.backgroundColor=[UIColor whiteColor];
        _secondTableView.layer.cornerRadius=12.0;
        [_secondTableView registerClass:[SubjectCountViewCell class] forCellReuseIdentifier:cell_id2];
    }
    return _secondTableView;
}
-(UITableView *)thirdTableView{
    if (!_thirdTableView) {
        _thirdTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 26+(SCREEN_HEIGHT*0.35+26)*2, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35)];
        _thirdTableView.dataSource=self;
        _thirdTableView.delegate=self;
        _thirdTableView.scrollEnabled=false;
        _thirdTableView.backgroundColor=[UIColor whiteColor];
        _thirdTableView.layer.cornerRadius=12.0;
        [_thirdTableView registerClass:[SubjectCountViewCell class] forCellReuseIdentifier:cell_id3];
    }
    return _thirdTableView;
}


//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"我的项目";
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_subject_data" object:nil];
        self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
}

#pragma mark tableView的代理与数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.firstTableView]) {
        //如果是第一个tableView
        //从数据库中拿数据，设置显示内容
        SubjectCountViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id1];
        if (cell==nil) {
            cell=[[SubjectCountViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id1];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //设置cell内容(目前为止还不完全)------------------>这就是MVC框架的确定，在这里model层和cell紧密耦合了，
        cell.titleLabel.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"subject_title"];
        //通过id查找到对应的所有的提醒时间条数
        cell.repeatDay_label.text=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:1] count]];
        //设置DayView的判断逻辑
        if ([cell.repeatDay_label.text isEqualToString:@"0"]) {
            cell.dayView_repeat.day_label.text=@"Day";
        }else{
            cell.dayView_repeat.day_label.text=@"Days";
        }
        cell.goalDiscription.text=[NSString stringWithFormat:@"距%@天目标还有",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"goal_total"]];
        
        cell.goalDay_label.text=[NSString stringWithFormat:@"%ld",[self countDaysAtIndex:indexPath]]; //距离目标天数还有多少天，这里需要再次修改lable的frame值
        //设置DayView的判断逻辑
        if ([cell.goalDay_label.text isEqualToString:@"0"]) {
            cell.dayView_goal.day_label.text=@"Day";
        }else{
            cell.dayView_goal.day_label.text=@"Days";
        }
        cell.titleImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"image"]]];
        cell.headView.backgroundColor=[[GetColor shareGetColor] getMyColorWith:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"image"]];
        cell.subject_start_time.text=[NSString stringWithFormat:@"Since %@",[[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"start_date"] startDateForm:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"start_date"]]];
        cell.reward_label.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"reward"];
        
        return cell;
        
    }else if ([tableView isEqual:self.secondTableView]){
        //如果是第二个tableView
        //从数据库中拿数据，设置显示内容
        SubjectCountViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id2];
        if (cell==nil) {
            cell=[[SubjectCountViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id2];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //设置cell内容(目前为止还不完全)
        cell.titleLabel.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"subject_title"];
        cell.repeatDay_label.text=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:2] count]];
        //设置DayView的判断逻辑
        if ([cell.repeatDay_label.text isEqualToString:@"0"]) {
            cell.dayView_repeat.day_label.text=@"Day";
        }else{
            cell.dayView_repeat.day_label.text=@"Days";
        }
        cell.titleImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"image"]]];
        cell.headView.backgroundColor=[[GetColor shareGetColor] getMyColorWith:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"image"]];
        cell.goalDiscription.text=[NSString stringWithFormat:@"距%@天目标还有",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"goal_total"]];
        cell.goalDay_label.text=[NSString stringWithFormat:@"%ld",[self countDaysAtIndex:indexPath]]; //距离目标天数还有多少天
        //设置DayView的判断逻辑
        if ([cell.goalDay_label.text isEqualToString:@"0"]) {
            cell.dayView_goal.day_label.text=@"Day";
        }else{
            cell.dayView_goal.day_label.text=@"Days";
        }
        cell.subject_start_time.text=[NSString stringWithFormat:@"Since %@",[[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"start_date"] startDateForm:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"start_date"]]];
        cell.reward_label.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+1] objectForKey:@"reward"];
        
        return cell;
    }
    else if ([tableView isEqual:self.thirdTableView]){
        //如果是第二个tableView
        //从数据库中拿数据，设置显示内容
        SubjectCountViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id3];
        if (cell==nil) {
            cell=[[SubjectCountViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id3];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //设置cell内容(目前为止还不完全)
        cell.titleLabel.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"subject_title"];
        cell.repeatDay_label.text=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:3] count]];
        //设置DayView的判断逻辑
        if ([cell.repeatDay_label.text isEqualToString:@"0"]) {
            cell.dayView_repeat.day_label.text=@"Day";
        }else{
            cell.dayView_repeat.day_label.text=@"Days";
        }
        cell.titleImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"image"]]];
        cell.headView.backgroundColor=[[GetColor shareGetColor] getMyColorWith:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"image"]];
        cell.goalDiscription.text=[NSString stringWithFormat:@"距%@天目标还有",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"goal_total"]];
        cell.goalDay_label.text=[NSString stringWithFormat:@"%ld",[self countDaysAtIndex:indexPath]]; //距离目标天数还有多少天
        //设置DayView的判断逻辑
        if ([cell.goalDay_label.text isEqualToString:@"0"]) {
            cell.dayView_goal.day_label.text=@"Day";
        }else{
            cell.dayView_goal.day_label.text=@"Days";
        }
        cell.subject_start_time.text=[NSString stringWithFormat:@"Since %@",[[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"start_date"] startDateForm:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"start_date"]]];
        cell.reward_label.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row+2] objectForKey:@"reward"];
        
        return cell;
    }
    return nil;
}

//列表项点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不同的tableView设置不同的跳转事件
    if ([tableView isEqual:self.firstTableView]) {
        //如果是第一个tableView
        //在这里把数据传过去
        
        //把索引传到下一个VC，让子VC自己来查询自己的内容
        SubSubjectcountViewController *subSubject_VC=[[SubSubjectcountViewController alloc] init];
        subSubject_VC.index=0;
        subSubject_VC.indexPath=indexPath;
        
        [self.navigationController pushViewController:subSubject_VC animated:true];
    }else if ([tableView isEqual:self.secondTableView]){
        //如果是第二个tableView
        //在这里把数据传过去
        
        SubSubjectcountViewController *subSubject_VC=[[SubSubjectcountViewController alloc] init];
        subSubject_VC.index=1;
        subSubject_VC.indexPath=indexPath;
        
        [self.navigationController pushViewController:subSubject_VC animated:true];
    }
    else if ([tableView isEqual:self.thirdTableView]){
        //如果是第三个tableView
        //在这里把数据传过去
        SubSubjectcountViewController *subSubject_VC=[[SubSubjectcountViewController alloc] init];
        subSubject_VC.index=2;
        subSubject_VC.indexPath=indexPath;
        
        [self.navigationController pushViewController:subSubject_VC animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.35;
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
    NSDate *startDate=[self dateFrom:startDate_String];
    //4.计算当前时间与项目开始时间之间的间隔
    NSTimeInterval timeInterval=[currentDate timeIntervalSinceDate:startDate];
    //5.计算时间间隔总共换算为多少天
    //计算天数
    NSInteger days = ((NSInteger)timeInterval)/(3600*24);
    //6.获得数据库中总目标天数
    NSInteger total_days=[[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:indexPath.row] objectForKey:@"goal_total"] integerValue];
    
    return total_days-days;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[AddModel shareAddMode] countForData]==0) {
        //什么都不做
        [self.firstTableView removeFromSuperview];
        [self.secondTableView removeFromSuperview];
        [self.thirdTableView removeFromSuperview];
        EmptyView *empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 100, 288, 341)];
        empty.imageView.image=[UIImage imageNamed:@"empty_mission_2_image"];
        [self.view addSubview:empty];
    }else if ([[AddModel shareAddMode] countForData]==1) {
        [self.firstTableView reloadData];
    }else if ([[AddModel shareAddMode] countForData]==2){
        [self.firstTableView reloadData];
        [self.secondTableView reloadData];
    }else{
        [self.firstTableView reloadData];
        [self.secondTableView reloadData];
        [self.thirdTableView reloadData];
    }
    //把所有内容都删除掉
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self loadUI];
}

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
