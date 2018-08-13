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
@interface RemarkViewController ()<UITableViewDelegate,UITableViewDataSource,refreshAllRemark,UIViewControllerPreviewingDelegate>

@property(nonatomic,strong)AlertView *alertView;
@property(nonatomic,strong)AddRemarkViewController *add_remark_VC;
@property(nonatomic,strong)UITableView *remarkTitle_tableView;
@property(nonatomic,strong)NSMutableArray* remark_title_array;
@property(nonatomic,strong)NSMutableArray* remark_date_array;
@property(nonatomic,strong)EmptyView *empty;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong) PopChallengeViewController *pop_challenge;//用于订阅改变的

@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化array，
    self.remark_title_array=[[NSMutableArray alloc] init];
    self.remark_date_array=[[NSMutableArray alloc] init];
    //从数据库中查出值,并填充到数组中
    for (NSInteger i=0; i<[[RemarkModel shareAddMode] countForData]; i++) {
        [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_title"]];//获得当前备注的标题
        [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_date"]];//获得当前备注的标题
    }
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
    if (self.remark_date_array.count>11) {
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+(self.remark_date_array.count-11)*65);
    }else{
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    self.scrollView.showsVerticalScrollIndicator=false;
    [self.view addSubview:self.scrollView];
    
    [self loadUI];
    
    
    
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
            
            [self.scrollView addSubview:self.empty];
        }else{
            [self.scrollView addSubview:self.remarkTitle_tableView];
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
            
            [self.scrollView addSubview:self.empty];
        }else{
            [self.scrollView addSubview:self.remarkTitle_tableView];
        }
    }
    
    //注册3D touch
    [self registerForPreviewingWithDelegate:self sourceView:self.remarkTitle_tableView];
    
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
        [self.scrollView addSubview:nav_view];
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
        [self.scrollView addSubview:nav_view];
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

#pragma mark --tableView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除内容
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [[RemarkModel shareAddMode] deleteDataByTitle:[cell.textLabel.text substringFromIndex:2]];

    //更新数组
    self.remark_title_array=[[NSMutableArray alloc] init];
    self.remark_date_array=[[NSMutableArray alloc] init];
    if (kDevice_Is_iPhoneX) {
        //从数据库中查出值,并填充到数组中
        for (NSInteger i=0; i<[[RemarkModel shareAddMode] countForData]; i++) {
            [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_title"]];//获得当前备注的标题
            [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_date"]];//获得当前备注的标题
        }
       
    }else{
        //从数据库中查出值,并填充到数组中
        for (NSInteger i=0; i<[[RemarkModel shareAddMode] countForData]; i++) {
            [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_title"]];//获得当前备注的标题
            [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_date"]];//获得当前备注的标题
        }
        
    }
    
    //更新视图尺寸
    self.remarkTitle_tableView.frame=CGRectMake(10, 90, SCREEN_WIDTH-20, 55*self.remark_title_array.count);
    
    //以动画形式删除行
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];//以动画形式删除该行
    
    if (self.remark_title_array.count==0) {
        [self.scrollView addSubview:self.empty];
        [self.remarkTitle_tableView removeFromSuperview];
    }else{
        [self.empty removeFromSuperview];
        [self.scrollView addSubview:self.remarkTitle_tableView];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewRemarkViewController *review_VC=[[ReviewRemarkViewController alloc] init];
    review_VC.select_index=indexPath.row;
    [self presentViewController:review_VC animated:true completion:nil];
}

//pick功能 代理方法
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
        //重按了tableView
        NSIndexPath *indexPath=[self.remarkTitle_tableView indexPathForRowAtPoint:location];
        if (indexPath) {
            //如果点击的cell不为空的时候
            UITableViewCell *cell=[self.remarkTitle_tableView cellForRowAtIndexPath:indexPath];
            previewingContext.sourceRect=cell.frame;
        }
        ReviewRemarkViewController *secondVC=[[ReviewRemarkViewController alloc] init];
        return secondVC;
}

//pop功能
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self showViewController:viewControllerToCommit sender:self];
}


//RAC信号的理解还不是很深入，所以暂时还是使用代理的方式来反向传值吧
-(void)refresh{
    self.remark_title_array=[[NSMutableArray alloc] init];
    self.remark_date_array=[[NSMutableArray alloc] init];
    if (kDevice_Is_iPhoneX) {
        //从数据库中查出值,并填充到数组中
        for (NSInteger i=0; i<[[RemarkModel shareAddMode] countForData]; i++) {
            [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_title"]];//获得当前备注的标题
            [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_date"]];//获得当前备注的标题
        }
        if (self.remark_title_array.count==0) {
            [self.scrollView addSubview:self.empty];
            [self.remarkTitle_tableView removeFromSuperview];
        }else{
            [self.empty removeFromSuperview];
            [self.scrollView addSubview:self.remarkTitle_tableView];
        }
    }else{
        //从数据库中查出值,并填充到数组中
        for (NSInteger i=0; i<[[RemarkModel shareAddMode] countForData]; i++) {
            [self.remark_title_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_title"]];//获得当前备注的标题
            [self.remark_date_array addObject:[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:i] objectForKey:@"remark_date"]];//获得当前备注的标题
        }
        if (self.remark_title_array.count==0) {
            [self.scrollView addSubview:self.empty];
            [self.remarkTitle_tableView removeFromSuperview];
        }else{
            [self.empty removeFromSuperview];
            [self.scrollView addSubview:self.remarkTitle_tableView];
        }
    }
    
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
