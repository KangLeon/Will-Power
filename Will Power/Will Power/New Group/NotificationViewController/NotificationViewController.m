//
//  NotificationViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/10.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "NotificationViewController.h"
#import "AddSecondViewController.h"
#import "AlertView.h"
#import "ColorDefine.h"
#import <FlatUIKit.h>
#import <ReactiveObjC.h>
#import "TapMusicButton.h"
#import "SizeDefine.h"
#import "CheckTableViewCell.h"
#import "CompleteMusic.h"
#import <SCLAlertView.h>
#import "AddModel.h"
#import "SubjectModel.h"
#import "CheckedModel.h"
#import "NSDate+LocalDate.h"
#import "EmptyView.h"
#import "NSString+DateTitle.h"

static NSString *cell_id_check=@"cell_check";

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)AlertView *alertView;
@property(nonatomic,strong)UITableView *notification_tableView;

@property(nonatomic,strong)NSMutableArray *today_array;//今日需要完成的任务数组
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navItem];
    [self navTitle];
    [self loadUI];
}

-(void)loadUI{
    self.today_array=[[NSMutableArray alloc] init];
    //从数据库中查找值填充数组
     //1.拿到当前时间
     //2.循环与数据库中所有任务关联的提醒时间进行对比，如果相同则添加到数组中
       //遍历所有任务
    for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {
        //遍历该任务下所有的提醒项目
        for (NSDictionary *content_dic in [[SubjectModel shareSubjectModel] selectEveryThing:i]) {
            //只要有相同的值就将该值的i值获取，并通过该值获得任务的标题名
            if ([[self stringFrom:[NSDate localdate]] isEqualToString:[content_dic objectForKey:@"subject_execute"]]) {
                [self.today_array addObject:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]];
            }
        }
    }
    
    self.notification_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, self.today_array.count*55)];
    self.notification_tableView.delegate=self;
    self.notification_tableView.dataSource=self;
    self.notification_tableView.scrollEnabled=false;
    
    //设置空视图view的三方库
    
    self.notification_tableView.layer.cornerRadius=12.0;
    
    [self.notification_tableView registerClass:[CheckTableViewCell class] forCellReuseIdentifier:cell_id_check];
    
    if (self.today_array.count==0) {
        EmptyView *empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 100, 288, 341)];
        empty.imageView.image=[UIImage imageNamed:@"empty_mission_image"];
        
        [self.view addSubview:empty];
    }else{
      [self.view addSubview:self.notification_tableView];
    }
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"今日待完成项目";
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
        self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
}

#pragma mark --tableView 数据源协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.today_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_check];
    if (cell==nil) {
        cell=[[CheckTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_check];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
    cell.subject_label.text=self.today_array[indexPath.row];
    
    //判断逻辑：是否该任务今天在checked里面已经有数据来
    for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {
        if ([cell.subject_label.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {
            for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
                if([[self stringFrom:[NSDate localdate]] isEqualToString:[dic objectForKey:@"checked"]]){
                    cell.status_check=YES;//根据数据库中有没有改天的数据来确定
                    cell.check_backView.backgroundColor=CUTE_BLUE;
                    [cell loadCheck];
                }
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    //注：由于首页的功能和这个功能是相同的，所以需要防止数据重复，
    //播放 检查成功，顺利将值存到数据库
    if (!cell.status_check) {
        
        //1.播放
        cell.status_check=!cell.status_check;
        cell.check_backView.backgroundColor=CUTE_BLUE;
        [cell loadCheck];
        CompleteMusic *completeMusic=[[CompleteMusic alloc] init];
        [completeMusic playSoundEffect_complete];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showSuccess:self title:@"干的好" subTitle:@"请继续坚持完成计划！" closeButtonTitle:@"ok 继续加油" duration:0.0f];
        
        //2. 存储数据到数据库中
        //获得任务id，获得当前日期，存储数据到数据库
        for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {
            if ([cell.subject_label.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {
                [CheckedModel shareCheckedModel].count=[[CheckedModel shareCheckedModel] countForData]+1;//存储count
                [CheckedModel shareCheckedModel].subject_id=i;
                [CheckedModel shareCheckedModel].checked=[NSString stringFrom:[NSDate localdate]];
                [[CheckedModel shareCheckedModel] insertData];
            }
        }
        
    }else{
        //1.删除 取消检查
        cell.status_check=!cell.status_check;
        cell.check_backView.backgroundColor=CALENDER_GRAY;
        [cell removeCheck];
        
        //2.从数据库中删除刚刚的值
        for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {
            if ([cell.subject_label.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {
                for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
                    if([[self stringFrom:[NSDate localdate]] isEqualToString:[dic objectForKey:@"checked"]]){//如果数据库中已经存了今天的数据
                        [[CheckedModel shareCheckedModel] deleteDataByChecked:[dic objectForKey:@"checked"]];
                        [[CheckedModel shareCheckedModel] selectEveryThing];
                    }
                }
            }
        } 
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
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
