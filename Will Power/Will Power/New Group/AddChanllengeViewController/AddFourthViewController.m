//
//  AddFourthViewController.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/4/26.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AddFourthViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import <FlatUIKit.h>
#import "AlertView.h"
#import "TapMusicButton.h"
#import "TextFieldTableViewCell.h"
#import "CuteAlert.h"
#import "AddModel.h"
#import "SubjectModel.h"
#import "HomeViewController.h"
#import "SuccessMusic.h"
#import "NSString+DateTitle.h"

static NSString *cell_id=@"text_cell";

@interface AddFourthViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)AlertView *alertView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)CuteAlert *cuteAlert;
@property(nonatomic,strong)UITableView *reward_tableView;

//用于判断用户输入是否完成的
@property(nonatomic,strong)RACSignal *firstSignal;
@property(nonatomic,strong)RACSignal *enableSignal;
@property(nonatomic,assign)BOOL isFinish;
@property(nonatomic,copy)NSString *reward_text;

@end

@implementation AddFourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navTitle];
    [self navItem];
    [self loadUI];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"奖励" message:@"这是最后一步，你必须知道大脑像一个小孩，你必须像玩游戏的时候那样，让大脑及时的获得奖励，培养良性循坏，现在思考一个适合当前任务的奖励吧。" cancelButtonTitle:@"明白了"];
    });

}

-(void)loadUI{
    [self.backView addSubview:self.reward_tableView];
    [self.view addSubview:self.backView];
}


#pragma mark 懒加的部分
-(UIView*)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, 55)];
        _backView.backgroundColor=[UIColor whiteColor];
        _backView.layer.cornerRadius=12;
    }
    return _backView;
}
-(UITableView*)reward_tableView{
    if (!_reward_tableView) {
        _reward_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 55)];
        _reward_tableView.backgroundColor=[UIColor whiteColor];
        _reward_tableView.layer.cornerRadius=12;
        
        _reward_tableView.delegate=self;
        _reward_tableView.dataSource=self;
        _reward_tableView.scrollEnabled=false;
        [_reward_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:cell_id];
    }
    return _reward_tableView;
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"奖励";
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
        NSLog(@"右上角的帮助，我被惦记了");
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"奖励" message:@"这是最后一步，你必须知道大脑像一个小孩，你必须像玩游戏的时候那样，让大脑及时的获得奖励，培养良性循坏，现在思考一个适合当前任务的奖励吧。" cancelButtonTitle:@"明白了"];
    }];
    
    UIBarButtonItem *barButtonItem_right_help=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_help];
    
    //右上完成按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 70, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"complete_edit_image"] forState:UIControlStateNormal];
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的完成我被惦记了");
        
        //关闭键盘显示
        [self.view endEditing:YES];
        
        //验证用户是否输入完毕
        if (self.isFinish) {
            
                //1.设置model
                [AddModel shareAddMode].reward=self.reward_text;
                //现在model的所有内容都设置完了，可以收集所有model数据并存储数据了
                [[AddModel shareAddMode] insertData];//插入所有数据
                
                //2.设置SubjectModel
                //需要得到 a.开始时间,b.到目标持续时间 c.关联的任务id
                //循环存到数据库中
                
                NSDate *start_date_for_subject=[self dateFrom:[AddModel shareAddMode].start_date];//2018-07-05 00:00:00 UTC
                [SubjectModel shareSubjectModel].add_array=[[NSMutableArray alloc] init];
            
                //每循坏一次，存储一次条任务时间到数据库
                for (NSInteger i=0; i<[AddModel shareAddMode].goal_total; i++) {
                    [SubjectModel shareSubjectModel].plus_id=[[SubjectModel shareSubjectModel] countForData]+arc4random()%10;
                    [SubjectModel shareSubjectModel].subject_id=[AddModel shareAddMode].subject_id;//当前任务关联的id
                    [SubjectModel shareSubjectModel].subject_execute=[NSString stringFrom:[start_date_for_subject dateByAddingTimeInterval:i*24*60*60]];//需要执行的任务时间
                    NSDictionary *dic=@{@"subject_id":@([SubjectModel shareSubjectModel].subject_id),
                                        @"subject_execute":[SubjectModel shareSubjectModel].subject_execute,
                                        @"plus_id":@([SubjectModel shareSubjectModel].plus_id)
                                        };
                    [[SubjectModel shareSubjectModel].add_array addObject:dic];
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",[AddModel shareAddMode].subject_title,[AddModel shareAddMode].reward]];//该任务正在执行
                [[SubjectModel shareSubjectModel] insertData];
                [self startNotifi];
            
//                [[SubjectModel shareSubjectModel] selectEveryThing:[AddModel shareAddMode].subject_id];//输出验证一下
            
//                NSLog(@"现在有%ld条数据",[[AddModel shareAddMode] countForData]);//查询现在有多少条出局用户验证
//                NSLog(@"存储在数据库的字典是%@",[[AddModel shareAddMode] selectEveryThing]);//输出字典
                
                [self.navigationController setNavigationBarHidden:true animated:true];
                self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
                //3.弹出顺利立项弹出框
                self.cuteAlert=[[CuteAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [self.view addSubview:self.cuteAlert];
                
                //4.成功确立计划的声音提示
                SuccessMusic *successMusic=[[SuccessMusic alloc] init];
                [successMusic playSoundEffect_success];
                //6.轻点返回首页
                UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct)];
                tapGes.numberOfTapsRequired=1;
                tapGes.numberOfTapsRequired=1;
                [self.cuteAlert addGestureRecognizer:tapGes];
                
                
                //4.在这里发送通知告诉首页更新数据，因为还没有完全学会rac的通知，所以这里还是使用oc里面的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_subject_data" object:nil];
            
        }else{
            //这里不新建一个的话，退出去再点就不起作用了，
            self.alertView=[[AlertView alloc] init];
            [self.alertView showAlertWithTitle:@"仍有未输入的内容" message:@"请完成本页的所有输入内容后再跳转到下一页面" cancelButtonTitle:@"好的"];
        }
        
    }];
    
    //添加右上角的所有按钮
    UIBarButtonItem *barButtonItem_right_next=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_next];
    self.navigationItem.rightBarButtonItems=@[barButtonItem_right_next,barButtonItem_right_help];
}

-(void)tapAct{
    NSArray *controllers = self.navigationController.viewControllers;
    for ( id viewController in controllers) {
        if ([viewController isKindOfClass:[HomeViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
    [self.cuteAlert removeFromSuperview];
}

#pragma mark datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil) {
        cell=[[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.left_ImageView.image=[UIImage imageNamed:@"reward_image_forFourth"];
    cell.cellTextField.placeholder=@"请输入任务完成时的奖励";
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
    //信号初始化
    self.firstSignal=cell.cellTextField.rac_textSignal;
    [self.firstSignal subscribeNext:^(id  _Nullable x) {
        if ([x length]>0) {
            self.reward_text=x;
            self.isFinish=YES;
        }
    }];
    //关闭按钮
    if (indexPath.row==0) {
        cell.cellTextField.delegate=self;
        cell.cellTextField.returnKeyType=UIReturnKeyDone;
        [[cell.cellTextField rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [cell.cellTextField resignFirstResponder];
            NSLog(@"输入完了");
        }];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
//关闭键盘显示
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
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
