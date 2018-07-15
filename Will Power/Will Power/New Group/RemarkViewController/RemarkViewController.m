//
//  RemarkViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/8.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "RemarkViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import "TapMusicButton.h"
#import <ReactiveObjC.h>
#import "AlertView.h"
#import "AddRemarkViewController.h"
#import "PopChallengeViewController.h"
#import "RemarkModel.h"
#import "EmptyView.h"
#import "ReviewRemarkViewController.h"

static NSString *cell_title_id=@"cell_title";
@interface RemarkViewController ()<UITableViewDelegate,UITableViewDataSource,refreshAllRemark>

@property(nonatomic,strong)AlertView *alertView;
@property(nonatomic,strong)AddRemarkViewController *add_remark_VC;
@property(nonatomic,strong)UITableView *remarkTitle_tableView;
@property(nonatomic,strong)NSMutableArray* remark_title_array;
@property(nonatomic,strong)NSMutableArray* remark_date_array;
@property(nonatomic,strong)EmptyView *empty;

@property(nonatomic,strong) PopChallengeViewController *pop_challenge;//用于订阅改变的

@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    
    //初始化array，
    self.remark_title_array=[[NSMutableArray alloc] init];
    self.remark_date_array=[[NSMutableArray alloc] init];
    //从数据库中查出值,并填充到数组中
    for (NSInteger i=0; i<[[RemarkModel shareAddMode] countForData]; i++) {
        [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_title"]];//获得当前备注的标题
        [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_date"]];//获得当前备注的标题
    }
    
    if (kDevice_Is_iPhoneX) {
        //添加tableView
        self.remarkTitle_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 110, SCREEN_WIDTH-20, 55*self.remark_title_array.count)];
        self.remarkTitle_tableView.layer.cornerRadius=12;
        self.remarkTitle_tableView.scrollEnabled=NO;
        self.remarkTitle_tableView.dataSource=self;
        self.remarkTitle_tableView.delegate=self;
        
        if (self.remark_title_array.count==0) {
            self.empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 170, 288, 341)];
            self.empty.imageView.image=[UIImage imageNamed:@"empty_remark_image"];
            
            [self.view addSubview:self.empty];
        }else{
            [self.view addSubview:self.remarkTitle_tableView];
        }
    }else{
        //添加tableView
        self.remarkTitle_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH-20, 55*self.remark_title_array.count)];
        self.remarkTitle_tableView.layer.cornerRadius=12;
        self.remarkTitle_tableView.scrollEnabled=NO;
        self.remarkTitle_tableView.dataSource=self;
        self.remarkTitle_tableView.delegate=self;
        
        if (self.remark_title_array.count==0) {
            self.empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 150, 288, 341)];
            self.empty.imageView.image=[UIImage imageNamed:@"empty_remark_image"];
            
            [self.view addSubview:self.empty];
        }else{
            [self.view addSubview:self.remarkTitle_tableView];
        }
    }
    
}

-(void)loadUI{
    if (kDevice_Is_iPhoneX) {
        //如果是IPhone X
        UIView *nav_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
        nav_view.backgroundColor=NAV_BACKGROUND;
        
        TapMusicButton *left_back_button=[[TapMusicButton alloc] init];
        left_back_button.frame=CGRectMake(22, 42, 52, 41);
        left_back_button.backgroundColor=[UIColor clearColor];
        [left_back_button setImage:[UIImage imageNamed:@"back_image"] forState:UIControlStateNormal];
        [[left_back_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"左上角的我被惦记了");
            [self dismissViewControllerAnimated:true completion:^{
                
            }];
        }];
        
        UILabel *title_label=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-64)/2, 55, 64, 20)];
        title_label.text=@"备注";
        title_label.textColor=BACKGROUND_COLOR;
        title_label.textAlignment=NSTextAlignmentCenter;
        title_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
        
        
        TapMusicButton *right_add_button=[[TapMusicButton alloc] init];
        right_add_button.frame=CGRectMake(SCREEN_WIDTH-72, 42, 52, 41);
        right_add_button.backgroundColor=[UIColor clearColor];
        [right_add_button setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
        [[right_add_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"右上角的我被惦记了");
            self.add_remark_VC=[[AddRemarkViewController alloc] init];
            self.add_remark_VC.delegate=self;
            [self presentViewController:self.add_remark_VC animated:true completion:^{
            }];
        }];
        
        [nav_view addSubview:right_add_button];
        [nav_view addSubview:title_label];
        [nav_view addSubview:left_back_button];
        [self.view addSubview:nav_view];
    }else{
        UIView *nav_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        nav_view.backgroundColor=NAV_BACKGROUND;
        
        TapMusicButton *left_back_button=[[TapMusicButton alloc] init];
        left_back_button.frame=CGRectMake(22, 22, 52, 41);
        left_back_button.backgroundColor=[UIColor clearColor];
        [left_back_button setImage:[UIImage imageNamed:@"back_image"] forState:UIControlStateNormal];
        [[left_back_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"左上角的我被惦记了");
            [self dismissViewControllerAnimated:true completion:^{
                
            }];
        }];
        
        UILabel *title_label=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-64)/2, 35, 64, 20)];
        title_label.text=@"备注";
        title_label.textColor=BACKGROUND_COLOR;
        title_label.textAlignment=NSTextAlignmentCenter;
        title_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
        
        
        TapMusicButton *right_add_button=[[TapMusicButton alloc] init];
        right_add_button.frame=CGRectMake(SCREEN_WIDTH-72, 22, 52, 41);
        right_add_button.backgroundColor=[UIColor clearColor];
        [right_add_button setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
        [[right_add_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"右上角的我被惦记了");
            self.add_remark_VC=[[AddRemarkViewController alloc] init];
            self.add_remark_VC.delegate=self;
            [self presentViewController:self.add_remark_VC animated:true completion:^{
            }];
        }];
        
        [nav_view addSubview:right_add_button];
        [nav_view addSubview:title_label];
        [nav_view addSubview:left_back_button];
        [self.view addSubview:nav_view];
    }
    
}

#pragma mark --tableView dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[RemarkModel shareAddMode] countForData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_title_id];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_title_id];
    }
    
    NSLog(@"%@",self.remark_title_array[indexPath.row]);
    
    NSString *cell_text=[NSString stringWithFormat:@"%ld.%@",indexPath.row+1,self.remark_title_array[indexPath.row]];
    cell.textLabel.text=cell_text;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.remark_date_array[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewRemarkViewController *review_VC=[[ReviewRemarkViewController alloc] init];
    review_VC.select_index=indexPath.row;
    [self presentViewController:review_VC animated:true completion:nil];
}

//RAC信号的理解还不是很深入，所以暂时还是使用代理的方式来反向传值吧
-(void)refresh{
    if (kDevice_Is_iPhoneX) {
        if (self.remark_title_array.count==0) {
            [self.view addSubview:self.empty];
            [self.remarkTitle_tableView removeFromSuperview];
        }else{
            [self.empty removeFromSuperview];
            [self.view addSubview:self.remarkTitle_tableView];
        }
    }else{
        if (self.remark_title_array.count==0) {
            EmptyView *empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 150, 288, 341)];
            empty.imageView.image=[UIImage imageNamed:@"empty_remark_image"];
            
            [self.view addSubview:empty];
        }else{
            [self.view addSubview:self.remarkTitle_tableView];
        }
    }
    
    
    //从数据库中查出最后一条值，添加到数组中
    [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:[[RemarkModel shareAddMode] countForData]-1] objectForKey:@"remark_title"]];//获得当前备注的标题
    [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:[[RemarkModel shareAddMode] countForData]-1] objectForKey:@"remark_date"]];//获得当前日期的标题
    
    self.remarkTitle_tableView.frame=CGRectMake(10, 90, SCREEN_WIDTH-20, 55*self.remark_title_array.count);
    
    //刷新表格
    [self.remarkTitle_tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //刷新表格
    [self.remarkTitle_tableView reloadData];
}

#pragma mark target-action方法
////通知的selector
//-(void)changeSubject:(NSNotification *)not{
////    self.yellowView.ball_titleLabel.text=[NSString stringWithFormat:@"The power i want \n%@",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:[not.userInfo[@"currentIndex"] integerValue]] objectForKey:@"subject_title"]];//订阅信号并设置标题
////    self.reward_message=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:[not.userInfo[@"currentIndex"] integerValue]] objectForKey:@"reward"];//订阅信号并设置奖励
//    //使关联于当前挑战索引的评论都显示
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
