//
//  HomeViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "HomeViewController.h"
#import "ColorDefine.h"
#import "BallView.h"
#import "ToggleView.h"
#import "RewardView.h"
#import "RemarkView.h"
#import "HelpView.h"
#import "CountView.h"
#import <ReactiveObjC.h>
#import "AddFirstViewController.h"
#import "TapMusic.h"
#import <FlatUIKit.h>
#import "PopChallengeViewController.h"
#import "AlertView.h"
#import "RemarkViewController.h"
#import "HelpViewController.h"
#import "CountViewController.h"
#import "NotificationViewController.h"
#import "CheckedViewController.h"
#import "SubjectCountViewController.h"
#import "SettingsViewController.h"
#import "SizeDefine.h"
#import "CheckView.h"
#import "CheckMusic.h"
#import <TSMessage.h>
#import "CuteMessage.h"
#import "AddModel.h"
#import <NSObject+RACKVOWrapper.h>
#import "AddFourthViewController.h"
#import "SubjectModel.h"
#import "CheckedModel.h"
#import "NSDate+LocalDate.h"
#import "NotifiModel.h"
#import "EmptyView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <Lottie/Lottie.h>
#import "ScoreView.h"
#import "CheckEmptyView.h"

@interface HomeViewController ()<UIPopoverPresentationControllerDelegate,FUIAlertViewDelegate>
@property(nonatomic) TapMusic *tapMusic;

//5个小按钮
@property(nonatomic,strong) ToggleView *changeChanllenge;//懒加载
@property(nonatomic,strong) RewardView *reward;//懒加载
@property(nonatomic,strong) RemarkView *remark;//懒加载
@property(nonatomic,strong) HelpView *help;//懒加载
@property(nonatomic,strong) CountView *count;//懒加载

//3个球
@property(nonatomic,strong) BallView *yellowView;//懒加载
@property(nonatomic,strong) BallView *purpleView;//懒加载
@property(nonatomic,strong) BallView *pinkView;//懒加载

//每日签到
@property(nonatomic,strong)CheckView *check_view;//懒加载

@property(nonatomic,strong)CuteMessage *cuteMessage;

@property(nonatomic,strong) PopChallengeViewController *pop_challenge;

@property(nonatomic,strong) AlertView *alertView;

//用于动态切换内容的中间传值
@property(nonatomic,strong)NSString *reward_message;

//用于创建新任务后更新视图
@property(nonatomic,strong)AddFourthViewController *addFourth_VC;

//用于查询数据库中值的索引
@property(nonatomic,assign)NSInteger subject_index;

//空视图view
@property(nonatomic,strong)EmptyView *empty;

//中间动画视图
@property(nonatomic,strong)LOTAnimationView *animation;

//中间动画视图
@property(nonatomic,strong)LOTAnimationView *sun_animation;

//添加score的view
@property(nonatomic,strong)ScoreView *score_view;

//用于保存任务日期数组
@property(nonatomic,strong)NSArray *array_mission1;
@property(nonatomic,strong)NSArray *array_mission2;
@property(nonatomic,strong)NSArray *array_mission3;

//今日没有任务view
@property(nonatomic,strong)CheckEmptyView *checkEmptyView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[CheckedModel shareCheckedModel] selectEveryThing];
//    [[CheckedModel shareCheckedModel] deleteAll];
    
    [self myTabButton];//加载底部3个button
    [self myDragView];//加载5个小button
    [self loadUI];//加载三个球
    [self navItem];//加载导航栏
    
    //监听通知以更新首页的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh_data) name:@"refresh_subject_data" object:nil];
    
    //任务日期数组
    if ([[AddModel shareAddMode] countForData]==0) {
        
    }else if ([[AddModel shareAddMode] countForData]==1){
        self.array_mission1=[[SubjectModel shareSubjectModel] selectEveryThing:1];
    }else if ([[AddModel shareAddMode] countForData]==2){
        self.array_mission1=[[SubjectModel shareSubjectModel] selectEveryThing:1];
        self.array_mission2=[[SubjectModel shareSubjectModel] selectEveryThing:2];
    }else if ([[AddModel shareAddMode] countForData]==3){
        self.array_mission1=[[SubjectModel shareSubjectModel] selectEveryThing:1];
        self.array_mission2=[[SubjectModel shareSubjectModel] selectEveryThing:2];
        self.array_mission3=[[SubjectModel shareSubjectModel] selectEveryThing:3];
    }
    
    //初始化一次项目索引
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.subject_index=[[AddModel shareAddMode] countForData]-1;
    });
}

//懒加载

//导航条上面的按钮
-(void)navItem{
    
    //左上角按钮
    TapMusicButton *barButton_left=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_left.backgroundColor=[UIColor clearColor];
    [barButton_left setImage:[UIImage imageNamed:@"notification_image"] forState:UIControlStateNormal];
    [[barButton_left rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"左上角的我被惦记了");
        NotificationViewController *notifi_VC=[[NotificationViewController alloc] init];
        [self.navigationController pushViewController:notifi_VC animated:true];
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
    //右上角按钮
    UIButton *barButton_right=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right.backgroundColor=[UIColor clearColor];
    [barButton_right setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
    [[barButton_right rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.tapMusic=[[TapMusic alloc] init];
        [self.tapMusic playSoundEffect];
        NSLog(@"右上角的我被惦记了");
        //在这里判断，如果现在已经有两个任务了，第三个任务需要判断是否要开，第四个任务是不允许开的
        //注意：但是应该注意，如果已经有的任务是永久性项目，也是应该注意的，为了让这个项目有效，你还是不应该安排更多的任务给当下
        
        //关于确立任务的判断逻辑
        if ([[AddModel shareAddMode] countForData]<2) {//如果当前小于两条数据
            AddFirstViewController *addFist_VC=[[AddFirstViewController alloc] init];
            [self.navigationController pushViewController:addFist_VC animated:true];
        }else if ([[AddModel shareAddMode] countForData]>1) {//如果当前有两条数据
            if ([[AddModel shareAddMode] countForData]>2){//如果当前有三条数据
                self.alertView=[[AlertView alloc] init];
                [self.alertView showAlertWithTitle:@"您已经有三个任务" message:@"无法开始更多任务，" cancelButtonTitle:@"好的"];
            }else{
                self.alertView=[[AlertView alloc] init];
                [self.alertView showAlertWithTitle:@"您已经有两个任务" message:@"不建议您在同一时间完成超过两个任务，这将降低任务的成功率，确定要开始一个新任务吗" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"确定再开一个"];
            }
        }
        
        
    }];
    
    UIBarButtonItem *barButtonItem_right=[[UIBarButtonItem alloc] initWithCustomView:barButton_right];
    self.navigationItem.rightBarButtonItem=barButtonItem_right;
    
    
    //设置导航栏隐藏
    
}

//底部三个button
-(void)myTabButton{
    //1
    UIButton *listButton=[[UIButton alloc] initWithFrame:CGRectMake(96, 615, 48, 39.96)];
    listButton.backgroundColor=[UIColor clearColor];
    [listButton setImage:[UIImage imageNamed:@"calender_image"] forState:UIControlStateNormal];
    [[listButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"啊，我是第一个按钮，我被点击了");
        SubjectCountViewController *subjectcount_VC=[[SubjectCountViewController alloc] init];
        [self.navigationController pushViewController:subjectcount_VC animated:true];
    }];
    
    [self.view addSubview:listButton];
    
    //2
    UIButton *checkButton=[[UIButton alloc] initWithFrame:CGRectMake(187, 615, 50, 40)];
    checkButton.backgroundColor=[UIColor clearColor];
    [checkButton setImage:[UIImage imageNamed:@"checked_image"] forState:UIControlStateNormal];
    [[checkButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"啊，我是第二个按钮，我被点击了");
        CheckedViewController *checked_VC=[[CheckedViewController alloc] init];
        [self.navigationController pushViewController:checked_VC animated:true];
    }];
    
    [self.view addSubview:checkButton];
    
    //3.
    UIButton *settingsButton=[[UIButton alloc] initWithFrame:CGRectMake(278, 615, 48, 40)];
    settingsButton.backgroundColor=[UIColor clearColor];
    [settingsButton setImage:[UIImage imageNamed:@"settings_image"] forState:UIControlStateNormal];
    [[settingsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"啊，我是第三个按钮，我被点击了");
        SettingsViewController *set_VC=[[SettingsViewController alloc] init];
        [self.navigationController pushViewController:set_VC animated:true];
    }];
    
    [self.view addSubview:settingsButton];
    
}

 //5个toggleView
-(void)myDragView{
    if ([[AddModel shareAddMode] countForData]==0) {
        //当没有数据的时候
        NSLog(@"当前数据库中还没有数据");
        //当没有数据的时候就不应该往view上面
        //然后将空列表的视图显示（第三方库）
    }else if ([[AddModel shareAddMode] countForData]>0){
        //当有数据的时候,才添加5个按钮
        NSLog(@"当前数据库中的数据有%ld条",[[AddModel shareAddMode] countForData]);
        //1 第一个切换挑战
        [self.view addSubview:self.changeChanllenge];
        //给切换挑战按钮增加点击事件，点击后弹出弹窗
        [[self.changeChanllenge.toggle_view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.pop_challenge=[[PopChallengeViewController alloc] init];
            self.pop_challenge.preferredContentSize=CGSizeMake(150, 40*3+50);//设置浮窗的宽高
            self.pop_challenge.modalPresentationStyle=UIModalPresentationPopover;

            UIPopoverPresentationController *popover=[self.pop_challenge popoverPresentationController];
            popover.delegate=self;
            popover.permittedArrowDirections=UIPopoverArrowDirectionAny;//设置箭头位置
            popover.sourceView=self.changeChanllenge;//设置目标视图
            popover.sourceRect=self.changeChanllenge.bounds;//弹出视图显示位置
            popover.backgroundColor=[UIColor whiteColor];
            [self presentViewController:self.pop_challenge animated:false completion:nil];
            
            //在这里监听通知并且修改当前页面挑战
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSubject:) name:@"changeSubject" object:nil];
        }];
        
        //2 第二个显示奖励内容的
        [self.view addSubview:self.reward];
        
        //如果是初始化的时候默认加载的是新添加的数据，即最后一条数据
        self.reward_message=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:([[AddModel shareAddMode] countForData]-1)] objectForKey:@"reward"];//设置标题
        //给奖励按钮增加点击事件，点击后弹出弹出框
        [[self.reward.reward_view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            self.alertView=[[AlertView alloc] init];
            [self.alertView showAlertWithTitle:@"当前任务奖励" message:self.reward_message cancelButtonTitle:@"Okay,期待"];
        }];
        
        
        //3 第三个添加备注的
        [self.view addSubview: self.remark];
        //给备注按钮增加点击事件，点击后跳转到备注控制器
        [[self.remark.remark_view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            RemarkViewController *remark_VC=[[RemarkViewController alloc] init];
            [self presentViewController:remark_VC animated:true completion:^{
            }];
        }];
        
        //4 第四个进入论坛的
        [self.view addSubview:self.help];
        //给帮助按钮增加点击事件，点击后跳转到帮助控制器
        [[self.help.help_view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            HelpViewController *help_VC=[[HelpViewController alloc] init];
            [self.navigationController pushViewController:help_VC animated:true];
        }];
        
        
        
        //5 第五个更多功能
        [self.view addSubview:self.count];
        //给统计按钮增加点击事件，点击后跳转到统计控制器
        [[self.count.count_view rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CountViewController *count_VC=[[CountViewController alloc] init];
            [self.navigationController pushViewController:count_VC animated:true];
        }];
        
    }
    
}
//懒加载5个小button,
-(ToggleView *)changeChanllenge{
    if (!_changeChanllenge) {
        _changeChanllenge=[[ToggleView alloc] initWithFrame:CGRectMake(-29, 185, 93, 37)];
        _changeChanllenge.toggle_imageView.image=[UIImage imageNamed:@"toggle_image"];
        _changeChanllenge.toggle_imageView.adjustsImageSizeForAccessibilityContentSizeCategory=YES;
    }
    return _changeChanllenge;
}
-(RewardView *)reward{
    if (!_reward) {
        _reward=[[RewardView alloc] initWithFrame:CGRectMake(-29, 229, 93, 37)];
        _reward.reward_imageView.image=[UIImage imageNamed:@"reward_image"];
        _reward.reward_imageView.adjustsImageSizeForAccessibilityContentSizeCategory=YES;
    }
    return _reward;
}
-(RemarkView *)remark{
    if (!_remark) {
        _remark=[[RemarkView alloc] initWithFrame:CGRectMake(352, 185, 93, 37)];
        _remark.remark_imageView.image=[UIImage imageNamed:@"remark_image"];
        _remark.remark_imageView.adjustsImageSizeForAccessibilityContentSizeCategory=YES;
    }
    return _remark;
}
-(HelpView *)help{
    if (!_help) {
        _help=[[HelpView alloc] initWithFrame:CGRectMake(352, 229, 93, 37)];
        _help.help_imageView.image=[UIImage imageNamed:@"help_image"];
        _help.help_imageView.adjustsImageSizeForAccessibilityContentSizeCategory=YES;
    }
    return _help;
}
-(CountView *)count{
    if (!_count) {
        _count=[[CountView alloc] initWithFrame:CGRectMake(352, 273, 93, 37)];
        _count.count_imageView.image=[UIImage imageNamed:@"count_image"];
        _count.count_imageView.adjustsImageSizeForAccessibilityContentSizeCategory=YES;
    }
    return _count;
}




//加载球视图
-(void)loadUI{
    
    if ([[AddModel shareAddMode] countForData]==0) {
        //当没有数据的时候
        NSLog(@"当前数据库中还没有数据");
        //当没有数据的时候就不应该往view上面
        //然后将空列表的视图显示（第三方库）
        self.empty=[[EmptyView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-288)/2, 150, 288, 341)];
        self.empty.imageView.image=[UIImage imageNamed:@"empty_subject_image"];
        
        [self.view addSubview:self.empty];
        
        
    }else if ([[AddModel shareAddMode] countForData]>0){
        [self.empty removeFromSuperview];
        //当有数据的时候，才添加三个黄球
        NSLog(@"当前数据库中的数据有%ld条",[[AddModel shareAddMode] countForData]);
        //黄球
//        [self.view addSubview:self.yellowView];
        //将文字显示在球上面
        //总是将新添加的一条数据拿出来
        //先直接操作数据库的内容，然后后面综合来判断是不是应该新用一组变量来实现修改
        //给当前索引赋值
        //这里应该订阅两个地方以更新值 1.首先是切换挑战，2.然后是新增任务
        
        //页面初始化时的值
//        self.yellowView.ball_titleLabel.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:([[AddModel shareAddMode] countForData]-1)] objectForKey:@"subject_title"];//设置标题
        self.yellowView.ball_titleLabel.text=[NSString stringWithFormat:@"The power I want \n %@",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:([[AddModel shareAddMode] countForData]-1)] objectForKey:@"subject_title"]];
        
        //紫球
//        [self.view addSubview:self.purpleView];
        self.purpleView.ball_titleLabel.text=@"The power I want to do it";
        
        //粉球
//        [self.view addSubview:self.pinkView];
        self.pinkView.ball_titleLabel.text=@"The power I do not want";
        
        //checkview
        self.check_view.check_title.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:([[AddModel shareAddMode] countForData]-1)] objectForKey:@"subject_title"];//开始加载的是倒数第一条数据
        
        //积分板
        [self.view addSubview:self.score_view];
        NSString *score=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:[[AddModel shareAddMode] countForData]] count]];//默认的是取最末尾的一个任务的数据
        if (score.length==1) {
            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
        }else if (score.length==2){
            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
            self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
        }else if (score.length==3){
            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(2, 1)]]];
            self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
            self.score_view.first_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
        }
        
        //每日签到
        //构思逻辑：需要判断今天是否有任务，如果有的话才添加button到界面上
        //1.拿到subjectModel中查询到的数组，转化后拿到年月日，
        //2.当前时间,转化后拿到年月日，
        for (NSInteger j=1; j<([[AddModel shareAddMode] countForData]+1); j++) {
            if ([[self.yellowView.ball_titleLabel.text substringFromIndex:19] isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:j-1] objectForKey:@"subject_title"]]) {
                //添加您今天没有项目
                [self.view addSubview:self.checkEmptyView];
                for (NSInteger i=0; i<[[SubjectModel shareSubjectModel] countForDataAtId:j]; i++) {
                    //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                    //这里默认显示最新的一条任务的关联提醒，
                    //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                    if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[[[SubjectModel shareSubjectModel] selectEveryThing:[[AddModel shareAddMode] countForData]] objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                        [self.checkEmptyView removeFromSuperview];
                        [self.view addSubview:self.check_view];
                    }else{
                       
                    }
                }
            }
        }
        //添加海贼王动画视图
        [self.view addSubview:self.animation];
        [self.view sendSubviewToBack:self.animation];
        //添加太阳动画视图
        [self.view addSubview:self.sun_animation];
        [self.view sendSubviewToBack:self.sun_animation];
    }
    
}

//海贼王动画视图view
-(LOTAnimationView*)animation{
    if (!_animation) {
        // Do any additional setup after loading the view.
        _animation=[LOTAnimationView animationNamed:@"walking"];
        _animation.frame=CGRectMake(-67,200 , 550, 280);
        _animation.loopAnimation=true;
        _animation.contentMode=UIViewContentModeScaleToFill;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}
//太阳动画视图view
-(LOTAnimationView*)sun_animation{
    if (!_sun_animation) {
        // Do any additional setup after loading the view.
        _sun_animation=[LOTAnimationView animationNamed:@"suncloud"];
        _sun_animation.frame=CGRectMake(90, 140 , 80, 80);
        _sun_animation.loopAnimation=true;
        [_sun_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _sun_animation;
}

-(ScoreView*)score_view{
    if (!_score_view) {
        _score_view=[[ScoreView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-195)/2-80, 26, 275, 110)];
    }
    return _score_view;
}


//懒加载三个球
-(BallView *)yellowView{
    if (!_yellowView) {
       _yellowView=[[BallView alloc] initWithFrame:CGRectMake(137, 135, 141, 141)];
        _yellowView.ball_button.backgroundColor=YELLOW_COLOR;
        [[_yellowView.ball_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"黄色按钮被点击了");
        }];
    }
    return _yellowView;
}
-(BallView *)purpleView{
    if (!_purpleView) {
        _purpleView=[[BallView alloc] initWithFrame:CGRectMake(43, 319, 141, 141)];
        _purpleView.ball_button.backgroundColor=PURPLE_COLOR;
        [[_purpleView.ball_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"紫色按钮被点击了");
        }];
    }
    return _purpleView;
}
-(BallView *)pinkView{
    if (!_pinkView) {
        _pinkView=[[BallView alloc] initWithFrame:CGRectMake(232, 319, 141, 141)];
        _pinkView.ball_button.backgroundColor=PINK_COLOR;
        [[_pinkView.ball_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"粉色按钮被点击了");
        }];
    }
    return _pinkView;
}

-(CheckView *)check_view{
    if (!_check_view) {
        //初始化操作
        _check_view=[[CheckView alloc] initWithFrame:CGRectMake(20, 500, SCREEN_WIDTH-40, 70)];
        _check_view.backgroundColor=CUTE_GRAY;
        _check_view.layer.cornerRadius=12;
        
        //显示的判断逻辑，是否今天的任务已经完成了，如果完成则将对号打勾
        for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {//循环所有项目，检测是否和当前checkView的文字标题一致
            if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {//如果是当前项目
                for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
                    if([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[dic objectForKey:@"checked"]]]){//如果数据库中已经存了今天的数据
                        //将对号打勾
                        self.check_view.isChecked=YES;
                        //右边的动画框勾选
                        self.check_view.check_backView.backgroundColor=CUTE_BLUE;
                        [self.check_view loadCheck];
                    }
                }
            }
        }
        
        //每日签到的点击业务逻辑
        //思路：1.得到当前时间 2.转化为NSDate 3.将当前时间存到数据库
        [[_check_view.check_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            
            //NO 取消检查成功状态
            //需要判断是否已经是勾选的状态，如果是的话，就不播放，并取消勾选状态；否的话，勾选并播放声音
            if (self->_check_view.isChecked) {
                self->_check_view.isChecked=!self->_check_view.isChecked;
                //1.不播放音乐
                //2.不播放动画，
                //右边的选择框取消勾选
                self->_check_view.check_backView.backgroundColor=CALENDER_GRAY;
                [self->_check_view removeCheck];
                
                //3.将数据库中的该条数据移除
                for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {
                    if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {
                        for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
                            if([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[dic objectForKey:@"checked"]]]){//如果数据库中已经存了今天的数据
                              [[CheckedModel shareCheckedModel] deleteDataByChecked:[dic objectForKey:@"checked"]];
                            }
                        }
                    }
                }
                
                //4.scoreView改变内容
                for (NSInteger j=1; j<([[AddModel shareAddMode] countForData]+1); j++) {
                    //如果当前是当前显示的任务的话
                    if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:j-1] objectForKey:@"subject_title"]]) {
                        //查询当前任务下已经坚持的天数
                        NSString *score=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:self.subject_index+1] count]];//默认的是取最末尾的一个任务的数据
                        if (score.length==1) {
                            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
                        }else if (score.length==2){
                            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
                            self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
                        }else if (score.length==3){
                            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(2, 1)]]];
                            self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
                            self.score_view.first_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
                        }
                    }
                }
            }else{
                
                //YES 检查成功
                //1.播放音乐
                [[[CheckMusic alloc] init] playSoundEffect_check];
                //2.播放动画
                [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self->_check_view.transform=CGAffineTransformMakeScale(1*0.6, 1*0.6);
                    self->_check_view.transform=CGAffineTransformMakeScale(1*1, 1*1);

                } completion:^(BOOL finished) {
                    
                }];

                //把检查状态置为true
                self.check_view.isChecked=!self->_check_view.isChecked;
                //右边的动画框勾选
                self.check_view.check_backView.backgroundColor=CUTE_BLUE;
                [self.check_view loadCheck];
                
                //显示成功提醒框
                self.cuteMessage=[[CuteMessage alloc] initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, 80)];
                
                [self.navigationController.view addSubview:self.cuteMessage];
                [self.cuteMessage showCuteSuccessWithTitle:@"干的好！" subTitle:@"您距离胜利又近了一步！"];
                
                //3.存储数据到数据库(这里存储到数据库的格式是以NSDate，可以直接存NSString，比较的时候比较好比较，但是开始存到数据库的时候就比较麻烦，所以希望之后找到优化的办法)
                //a.得到当前的时间
                //b.当前时间已经是NSDate了，所以直接存就可以
                
                //判断当前显示的是哪条任务
                for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {//循环所有任务
                    if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {//判断是否为该条任务
                        //如果数据库中已经有改天的数据，就不应该再存储数据了,本身是不应该有这个
//                        for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
//                            if([[self stringFrom:[NSDate localdate_4real]] isEqualToString:[self stringFrom:[dic objectForKey:@"checked"]]]){//如果数据库中已经存了今天的数据
//
//                            }else{
//                                //没有存改天的数据
//                                [CheckedModel shareCheckedModel].count=([[CheckedModel shareCheckedModel] countForDataByID:i]+1);
//                                [CheckedModel shareCheckedModel].subject_id=i;
//                                [CheckedModel shareCheckedModel].checked=[NSDate localdate];
//                                [[CheckedModel shareCheckedModel] insertData];
//                            }
//                        }
                        [CheckedModel shareCheckedModel].count=([[CheckedModel shareCheckedModel] countForDataByID:i]+1);
                        [CheckedModel shareCheckedModel].subject_id=i;
                        [CheckedModel shareCheckedModel].checked=[NSDate localdate];
                        [[CheckedModel shareCheckedModel] insertData];
                        [[CheckedModel shareCheckedModel] selectEveryThing];
                    }
                }
                
                //4.scoreView改变内容
                for (NSInteger j=1; j<([[AddModel shareAddMode] countForData]+1); j++) {
                    //如果当前是当前显示的任务的话
                    if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:j-1] objectForKey:@"subject_title"]]) {
                        //查询当前任务下已经坚持的天数
                        NSString *score=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:self.subject_index+1] count]];//默认的是取最末尾的一个任务的数据
                        if (score.length==1) {
                            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
                        }else if (score.length==2){
                            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
                            self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
                        }else if (score.length==3){
                            self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(2, 1)]]];
                            self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
                            self.score_view.first_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
                        }
                    }
                }
               
            }
        }];
        
    }
    return _check_view;
}
-(CheckEmptyView*)checkEmptyView{
    if (!_checkEmptyView) {
        _checkEmptyView=[[CheckEmptyView alloc] initWithFrame:CGRectMake(20, 500, SCREEN_WIDTH-40, 70)];
        [[_checkEmptyView.check_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self->_checkEmptyView loadEmptyCheck];
        }];
    }
    return _checkEmptyView;
}

#pragma mark --pop
//设置浮窗的弹出样式，效果途中设置style为UIModalPresentationNone
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//点击浮窗背景popover controller是否消失
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return true;
}

//浮窗消失时调用
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
}

#pragma mark 弹出框的代理方法
//弹出框的代理方法
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //这是取消按钮的，取消按钮默认索引是0
    }else if(buttonIndex==1){
        //这是确定按钮的
        //如果用户确定仍然要开
        AddFirstViewController *addFist_VC=[[AddFirstViewController alloc] init];
        [self.navigationController pushViewController:addFist_VC animated:true];
    }
}

#pragma mark target-action的方法
//刷新页面
-(void)refresh_data{
    [self loadUI];
    [self myDragView];
    NSLog(@"刷新数据吧");
}
//通知的selector
-(void)changeSubject:(NSNotification *)not{
    
    //根据通知设置内容
    self.subject_index=[not.userInfo[@"currentIndex"] integerValue];
    
    //收到通知后改变黄球的文字
    self.yellowView.ball_titleLabel.text=[NSString stringWithFormat:@"The power i want \n%@",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:[not.userInfo[@"currentIndex"] integerValue]] objectForKey:@"subject_title"]];//订阅信号并设置标题
    //收到通知后改变奖励的文字
    self.reward_message=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:[not.userInfo[@"currentIndex"] integerValue]] objectForKey:@"reward"];//订阅信号并设置奖励
    
    //先改变checkView的标题和描述文字，同时也改变项目图片
    self.check_view.check_title.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:[not.userInfo[@"currentIndex"] integerValue]] objectForKey:@"subject_title"];
    
        //收到通知后，每日签到判断是否添加到页面上
        //循环任务
        for (NSInteger j=1; j<([[AddModel shareAddMode] countForData]+1); j++) {
            //如果当前是当前显示的任务的话
            if ([[self.yellowView.ball_titleLabel.text substringFromIndex:19] isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:j-1] objectForKey:@"subject_title"]]) {
                //添加您今天没有项目label
                [self.view addSubview:self.checkEmptyView];
                if (j==1) {
                    //循环subjecModel
                    NSLog(@"%@",self.array_mission1);
                    for (NSInteger i=0; i<self.array_mission1.count; i++) {
                        //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                        //这里默认显示最新的一条任务的关联提醒，
                        //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                        if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[self.array_mission1 objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                            [self.checkEmptyView removeFromSuperview];
                            [self.view addSubview:self.check_view];
                        }else{
                            
                        }
                    }
                }else if (j==2){
                    //循环subjecModel
                    for (NSInteger i=0; i<self.array_mission1.count; i++) {
                        //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                        //这里默认显示最新的一条任务的关联提醒，
                        //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                        if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[self.array_mission2 objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                            [self.checkEmptyView removeFromSuperview];
                            [self.view addSubview:self.check_view];
                        }else{
                            
                        }
                    }
                }else if (j==3){
                    //循环subjecModel
                    for (NSInteger i=0; i<self.array_mission1.count; i++) {
                        //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                        //这里默认显示最新的一条任务的关联提醒，
                        //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                        if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[self.array_mission3 objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                            [self.checkEmptyView removeFromSuperview];
                            [self.view addSubview:self.check_view];
                        }else{
                            
                        }
                    }
                }
                
            }
        }

    //是否对号打勾
    //显示的判断逻辑，是否今天的任务已经完成了，如果完成则将对号打勾
    for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {//循环所有项目
        if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {//如果是当前项目
            //如果已经空数据了
            if ([[CheckedModel shareCheckedModel] selectEveryThingById:i].count==0) {
                self.check_view.isChecked=NO;
                //1.不播放音乐
                //2.不播放动画，
                //右边的选择框取消勾选
                self.check_view.check_backView.backgroundColor=CALENDER_GRAY;
                [self.check_view removeCheck];
            }
            for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
                if([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[dic objectForKey:@"checked"]]]){//如果数据库中已经存了今天的数据
                    //将对号打勾
                    self.check_view.isChecked=YES;
                    //右边的动画框勾选
                    self.check_view.check_backView.backgroundColor=CUTE_BLUE;
                    [self.check_view loadCheck];
                }else{
                    self.check_view.isChecked=NO;
                    //1.不播放音乐
                    //2.不播放动画，
                    //右边的选择框取消勾选
                    self.check_view.check_backView.backgroundColor=CALENDER_GRAY;
                    [self.check_view removeCheck];
                }
            }
        }
    }
    
    //积分板改变内容
    NSString *score=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:([not.userInfo[@"currentIndex"] integerValue]+1)] count]];//根据任务，拿出数据
    if (score.length==1) {
        self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
    }else if (score.length==2){
        self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
        self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
    }else if (score.length==3){
        self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(2, 1)]]];
        self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
        self.score_view.first_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
    }
    
    //同时将弹出视图消失掉
    [self.pop_challenge dismissViewControllerAnimated:false completion:^{
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //是否添加每日签到
    //构思逻辑：需要判断今天是否有任务，如果有的话才添加button到界面上
    //1.拿到subjectModel中查询到的数组，转化后拿到年月日，
    //2.当前时间,转化后拿到年月日，
    //循环任务
    for (NSInteger j=1; j<([[AddModel shareAddMode] countForData]+1); j++) {
        //如果当前是当前显示的任务的话
        if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:j-1] objectForKey:@"subject_title"]]) {
            //添加您今天没有项目label
            [self.view addSubview:self.checkEmptyView];
            if (j==1) {
                //循环subjecModel
                NSLog(@"%@",self.array_mission1);
                for (NSInteger i=0; i<self.array_mission1.count; i++) {
                    //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                    //这里默认显示最新的一条任务的关联提醒，
                    //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                    if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[self.array_mission1 objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                        [self.checkEmptyView removeFromSuperview];
                        [self.view addSubview:self.check_view];
                    }else{
                        
                    }
                }
            }else if (j==2){
                //循环subjecModel
                for (NSInteger i=0; i<self.array_mission1.count; i++) {
                    //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                    //这里默认显示最新的一条任务的关联提醒，
                    //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                    if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[self.array_mission2 objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                        [self.checkEmptyView removeFromSuperview];
                        [self.view addSubview:self.check_view];
                    }else{
                        
                    }
                }
            }else if (j==3){
                //循环subjecModel
                for (NSInteger i=0; i<self.array_mission1.count; i++) {
                    //3.比较二者，如果相等的话，则添加check_view到页面上------------------------------------------>selectEveryThing的参数可能有误，
                    //这里默认显示最新的一条任务的关联提醒，
                    //如果今天的日期等于总计划数组里的日期值，则把view添加到视图上
                    if ([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[[self.array_mission3 objectAtIndex:i] objectForKey:@"subject_execute"]]]) {
                        [self.checkEmptyView removeFromSuperview];
                        [self.view addSubview:self.check_view];
                    }else{
                        
                    }
                }
            }
            
        }
    }
    
    //是否对号打勾
    //显示的判断逻辑，是否今天的任务已经完成了，如果完成则将对号打勾
    for (NSInteger i=1; i<([[AddModel shareAddMode] countForData]+1); i++) {//循环所有项目
        if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]]) {//如果是当前项目
            //如果已经空数据了
            if ([[CheckedModel shareCheckedModel] selectEveryThingById:i].count==0) {
                self.check_view.isChecked=NO;
                //1.不播放音乐
                //2.不播放动画，
                //右边的选择框取消勾选
                self.check_view.check_backView.backgroundColor=CALENDER_GRAY;
                [self.check_view removeCheck];
            }
            for (NSDictionary *dic in [[CheckedModel shareCheckedModel] selectEveryThingById:i]) {
                if([[self stringFrom:[NSDate localdate]] isEqualToString:[self stringFrom:[dic objectForKey:@"checked"]]]){//如果数据库中已经存了今天的数据
                    //将对号打勾
                    self.check_view.isChecked=YES;
                    //右边的动画框勾选
                    self.check_view.check_backView.backgroundColor=CUTE_BLUE;
                    [self.check_view loadCheck];
                }else{
                    self.check_view.isChecked=NO;
                    //1.不播放音乐
                    //2.不播放动画，
                    //右边的选择框取消勾选
                    self.check_view.check_backView.backgroundColor=CALENDER_GRAY;
                    [self.check_view removeCheck];
                }
            }
        }
    }
    
    
    //scoreView的变化
    //积分板改变内容
    for (NSInteger j=1; j<([[AddModel shareAddMode] countForData]+1); j++) {
        //如果当前是当前显示的任务的话
        if ([self.check_view.check_title.text isEqualToString: [[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:j-1] objectForKey:@"subject_title"]]) {
            //查询当前任务下已经坚持的天数
            NSString *score=[NSString stringWithFormat:@"%ld",[[[CheckedModel shareCheckedModel] selectEveryThingById:self.subject_index+1] count]];//假如之前没切换国项目的话，  默认的是取最末尾的一个任务的数据
            if (score.length==1) {
                self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
            }else if (score.length==2){
                self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
                self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
            }else if (score.length==3){
                self.score_view.third_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(2, 1)]]];
                self.score_view.second_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(1, 1)]]];
                self.score_view.first_number.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_number_image",[score substringWithRange:NSMakeRange(0, 1)]]];
            }
        }
    }
}
#pragma mark --生命周期方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果是根视图控制器就把导航栏颜色置为蓝色，其他的页面不影响
    self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
    //1.首先把navigationController的Translucent取消勾选，颜色与背景色一致
    //2.然后同多下面一行代码，取消当行懒分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
     self.fd_interactivePopDisabled=YES;//取消该页面的右滑返回
    
    //注册程序进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (startTimer) name: UIApplicationWillEnterForegroundNotification object:nil];
    
    //注册程序进入后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (pauseTimer) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

//程序进入前台
-(void)startTimer{
    [self.animation play];
    [self.sun_animation play];
}
//程序进入后台
-(void)pauseTimer{
    [self.animation stop];
    [self.sun_animation stop];
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
