//
//  CheckedViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CheckedViewController.h"
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
#import "CheckedModel.h"
#import "AddModel.h"
#import "EmptyView.h"

static NSString *cell_id_check=@"cell_check";

@interface CheckedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)AlertView *alertView;
@property(nonatomic,strong)UITableView *notification_tableView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSMutableArray *today_array;//存储任务标题
@property(nonatomic,strong)NSMutableArray *date_array;//存储日期字符串
@end

@implementation CheckedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navItem];
    [self navTitle];
    [self loadUI];
    
    [self.notification_tableView registerClass:[CheckTableViewCell class] forCellReuseIdentifier:cell_id_check];
}

-(void)loadUI{
    self.today_array=[[NSMutableArray alloc] init];
    self.date_array=[[NSMutableArray alloc] init];
    //从数据库中拿值，并填充到数组中
    for (NSInteger i=0; i<[[CheckedModel shareCheckedModel] countForData]; i++) {
        //通过id，得到当前任务的标题,添加到数组中
        [self.today_array addObject:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:([[[[[CheckedModel shareCheckedModel] selectEveryThing] objectAtIndex:i] objectForKey:@"id"] integerValue]-1)] objectForKey:@"subject_title"]];
        //将当前日期添加到日期数组中
        [self.date_array addObject:[[[[CheckedModel shareCheckedModel] selectEveryThing] objectAtIndex:i] objectForKey:@"checked"]];
    }
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
    if (self.date_array.count>12) {
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+(self.date_array.count-12)*65);
    }else{
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    self.scrollView.showsVerticalScrollIndicator=false;
    
    
    self.notification_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, self.today_array.count*55)];
    self.notification_tableView.delegate=self;
    self.notification_tableView.dataSource=self;
    self.notification_tableView.scrollEnabled=false;
    self.notification_tableView.layer.cornerRadius=12.0;
    
    if (self.date_array.count==0) {
        EmptyView *empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 100, 288, 341)];
        empty.imageView.image=[UIImage imageNamed:@"empty_record_image"];
        
        [self.scrollView addSubview:empty];
    }else{
       [self.scrollView addSubview:self.notification_tableView];
    }
    
    [self.view addSubview:self.scrollView];
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"历史记录";
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

#pragma mark --tableView datasource
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
    cell.check_backView.backgroundColor=CUTE_BLUE;
    [cell loadCheck];
    cell.subject_label.text=self.today_array[indexPath.row];
    cell.subject_date_label.text=self.date_array[indexPath.row];
    
    return cell;
}

//在这个页面里面是历史记录，所以不应该有点击事件，而是只可以查看一下什么时候完成了什么事，所以状态是已勾选，同时必须把日期显示在这里

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
