//
//  SubjectDeleteViewController.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubjectDeleteViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import <ReactiveObjC.h>
#import "TapMusicButton.h"
#import <SCLAlertView.h>
#import "TextFieldTableViewCell.h"
#import "PickerTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "AddTableViewCell.h"
#import "AddModel.h"
#import "NotifiModel.h"
#import "AlertView.h"
#import <FlatUIKit.h>
#import "PickerView.h"
#import "SubjectCountViewController.h"

#define COTENT_SIZE (370+self.second_modify_tableView.frame.size.height+10+40+10+240+10+40+10+60+26+59+20+70)

static NSString *cell_id_firstStep=@"first_modify_tableView_cell_id";
static NSString *cell_id_secondStep=@"second_modify_tableView_cell_id";
static NSString *cell_id_thirdStep=@"third_modify_tableView_cell_id";
static NSString *cell_id_forthStep=@"forth_modify_tableView_cell_id";
static NSString *cell_id_fifthStep=@"fifth_modify_tableView_cell_id";
static NSString *cell_id_sixthStep=@"sixth_modify_tableView_cell_id";
static NSString *cell_id_seventhStep=@"seventh_modify_tableView_cell_id";
static NSString *cell_id_eighthStep=@"eighth_modify_tableView_cell_id";

@interface SubjectDeleteViewController ()<UITableViewDelegate,UITableViewDataSource,FUIAlertViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *first_modify_tableView;
@property(nonatomic,strong)UITableView *second_modify_tableView;
@property(nonatomic,strong)UITableView *third_modify_tableView;
@property(nonatomic,strong)UITableView *fourth_modify_tableView;

@property(nonatomic,strong)UILabel *first_title;
@property(nonatomic,strong)UILabel *second_title;
@property(nonatomic,strong)UILabel *third_title;
@property(nonatomic,strong)UILabel *fourth_title;

@property(nonatomic,strong)TapMusicButton *finishButton;

@property(nonatomic,strong)PickerView *pickerView_three;

@property(nonatomic,assign)BOOL isModify;

//图片赋值的array
//1.
@property(nonatomic,strong)NSArray *imageName_array;
@property(nonatomic,strong)NSArray *placeHoder_array;
//2.

//3.
@property(nonatomic,strong)NSArray *cell_textFiled_array;
@property(nonatomic,strong)NSArray *cell_textField_placeHolder;

@property(nonatomic,strong) AlertView *alertView;
@property(nonatomic,strong) AlertView *alertView_complete;
@property(nonatomic,strong) AlertView *alertView_back;

@property(nonatomic,assign)NSIndexPath *indexPath_repeat;
@property(nonatomic,assign)NSIndexPath *indexPath_start;

//用于存储和验证部分的
//@property(nonatomic,assign)BOOL isFinish;
@property(nonatomic,strong)RACSignal *enableSignal;
@property(nonatomic,strong)RACSignal *enableSignal_2;
@property(nonatomic,strong)RACSignal *first_cell;
@property(nonatomic,strong)RACSignal *second_cell;
@property(nonatomic,strong)RACSignal *third_cell;
@property(nonatomic,strong)RACSignal *fourth_cell;
@property(nonatomic,strong)RACSignal *fifth_cell;
@property(nonatomic,strong)RACSignal *sixth_cell;
@property(nonatomic,strong)RACSignal *seventh_cell;
@property(nonatomic,strong)RACSignal *eightth_cell;
@property(nonatomic,strong)RACSignal *nineth_cell;

//1.我想要
@property(nonatomic,copy)NSString *subject_title;
@property(nonatomic,copy)NSString *subject_get;
@property(nonatomic,copy)NSString *subject_love_get;
@property(nonatomic,copy)NSString *subject_best_me;

//2.我要做
@property(nonatomic,strong)NSMutableArray *alarm_temporary_array;//临时存放提醒时间的array,用于显示
@property(nonatomic,strong)NSMutableArray *alarm_all_array;
@property(nonatomic,strong)NSDictionary *alarm_single_dic;
@property(nonatomic,strong)NSString *for_repeat_cell_text;//临时存放坚持目标的字符串
@property(nonatomic,strong)NSString *for_start_cell_text;//临时存放起始时间的字符串

//3. 我不要
@property(nonatomic,copy)NSString *things_text;
@property(nonatomic,copy)NSString *people_text;
@property(nonatomic,copy)NSString *time_text;
@property(nonatomic,copy)NSString *thought_text;

//4.奖励
@property(nonatomic,copy)NSString *reward_text;

@end

@implementation SubjectDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navItem];
    [self navTitle];
    [self loadUI];
}
-(void)loadUI{
    //滚动父视图
    //添加项目修改第一步：tableView（我想要）
    [self.pickerView_three addSubview:self.first_title];
    [self.pickerView_three addSubview:self.first_modify_tableView];
    //添加项目修改第二部：tableView（我要做）
    [self.pickerView_three addSubview:self.second_title];
    [self.pickerView_three addSubview:self.second_modify_tableView];
    //添加项目修改第三部：tableView（我不要）
    [self.pickerView_three addSubview:self.third_title];
    [self.pickerView_three addSubview:self.third_modify_tableView];
    //添加项目修改第四部:奖励
    [self.pickerView_three addSubview:self.fourth_title];
    [self.pickerView_three addSubview:self.fourth_modify_tableView];
    //添加完成按钮
    [self.pickerView_three addSubview:self.finishButton];
    
    [self.pickerView_three sendSubviewToBack:self.first_title];
    [self.pickerView_three sendSubviewToBack:self.first_modify_tableView];
    [self.pickerView_three sendSubviewToBack:self.second_title];
    [self.pickerView_three sendSubviewToBack:self.second_modify_tableView];
    [self.pickerView_three sendSubviewToBack:self.third_title];
    [self.pickerView_three sendSubviewToBack:self.third_modify_tableView];
    [self.pickerView_three sendSubviewToBack:self.fourth_title];
    [self.pickerView_three sendSubviewToBack:self.fourth_modify_tableView];
    [self.pickerView_three sendSubviewToBack:self.finishButton];
    
    [self.view addSubview:self.pickerView_three];
}

#pragma mark 懒加载部分
#pragma mark 第一个修改部分的
-(UITableView *)first_modify_tableView{
    if (!_first_modify_tableView) {
        _first_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 70, (SCREEN_WIDTH-20), 236)];
        _first_modify_tableView.dataSource=self;
        _first_modify_tableView.delegate=self;
        [_first_modify_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:cell_id_firstStep
         ];
        _first_modify_tableView.backgroundColor=[UIColor whiteColor];
        _first_modify_tableView.layer.cornerRadius=12;
    }
    return _first_modify_tableView;
}
-(UILabel*)first_title{
    if (!_first_title) {
        _first_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 40)];
        _first_title.backgroundColor=[UIColor clearColor];
        _first_title.text=@"Step 1 我想要";
        _first_title.textColor=[UIColor whiteColor];
        _first_title.textAlignment=NSTextAlignmentLeft;
        _first_title.font=[UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    }
    return _first_title;
}

-(NSArray *)imageName_array{
    if (!_imageName_array) {
        _imageName_array=@[@"title_image",@"get_image",@"love_image",@"self_image"];
    }
    return _imageName_array;
}
-(NSArray *)placeHoder_array{
    if (!_placeHoder_array) {
        _placeHoder_array=@[@"请输入想坚持的事情",@"我会从挑战成功直接得到什么？",@"爱我和我爱的人会得到什么？",@"那个美好的自己是怎样的？"];
    }
    return _placeHoder_array;
}
-(NSArray *)cell_textFiled_array{
    if (!_cell_textFiled_array) {
        _cell_textFiled_array=@[@"bad_thing_image",@"bad_people_image",@"bad_time_image",@"bad_will_image"];
    }
    return _cell_textFiled_array;
}
-(NSArray *)cell_textField_placeHolder{
    if (!_cell_textField_placeHolder) {
        _cell_textField_placeHolder=@[@"可能让我失控的事情或东西",@"可能让我失控的人",@"可能让我失控的时间",@"可能让我失控的心理"];
    }
    return _cell_textField_placeHolder;
}
-(NSString *)for_repeat_cell_text{
    if (!_for_repeat_cell_text) {
        _for_repeat_cell_text=[NSString stringWithFormat:@"%@天",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"goal_total"]];
    }
    return _for_repeat_cell_text;
}
#pragma mark 第二个修改部分的
-(UITableView *)second_modify_tableView{
    if (!_second_modify_tableView) {
        _second_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 370, (SCREEN_WIDTH-20), 236+[[NotifiModel notifiModel] countForDataIn:(self.delete_index+1)]*59)];
        _second_modify_tableView.dataSource=self;
        _second_modify_tableView.delegate=self;
        [_second_modify_tableView registerClass:[PickerTableViewCell class] forCellReuseIdentifier:cell_id_secondStep
         ];
        [_second_modify_tableView registerClass:[SwitchTableViewCell class] forCellReuseIdentifier:cell_id_thirdStep
         ];
        [_second_modify_tableView registerClass:[AddTableViewCell class] forCellReuseIdentifier:cell_id_forthStep
         ];
        _second_modify_tableView.backgroundColor=[UIColor whiteColor];
        _second_modify_tableView.layer.cornerRadius=12;
    }
    return _second_modify_tableView;
}
-(UILabel*)second_title{
    if (!_second_title) {
        _second_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 320, 150, 40)];
        _second_title.backgroundColor=[UIColor clearColor];
        _second_title.text=@"Step 2 我要做";
        _second_title.textColor=[UIColor whiteColor];
        _second_title.textAlignment=NSTextAlignmentLeft;
        _second_title.font=[UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    }
    return _second_title;
}
-(NSMutableArray *)alarm_temporary_array{
    if (!_alarm_temporary_array) {
        _alarm_temporary_array=[[NSMutableArray alloc] init];
        //构造显示文字字符串
        NSArray *resultArray=[[NotifiModel notifiModel] selectItemsIn:self.delete_index+1];
        for (NSDictionary *dic in resultArray) {
          NSString *dateString=[NSString stringWithFormat:@"%@%@点%@分",[dic objectForKey:@"alarm_day"],[dic objectForKey:@"alarm_hour"],[dic objectForKey:@"alarm_minute"]];
            [_alarm_temporary_array addObject:dateString];
            [self.alarm_all_array addObject:dic];
        }
    }
    return _alarm_temporary_array;
}
-(NSMutableArray*)alarm_all_array{
    if (!_alarm_all_array) {
        _alarm_all_array=[[NSMutableArray alloc] init];
    }
    return _alarm_all_array;
}

-(PickerView *)pickerView_three{
    if (!_pickerView_three) {
        _pickerView_three=[[PickerView alloc] initWithFrame:self.view.frame];
        _pickerView_three.backgroundColor=[UIColor clearColor];
        _pickerView_three.delegate=self;
        _pickerView_three.contentSize=CGSizeMake(SCREEN_WIDTH, 370+self.second_modify_tableView.frame.size.height+10+40+10+240+10+40+10+60+26+59+20+70);
        _pickerView_three.showsVerticalScrollIndicator=NO;//不限时垂直的滚动条
        //1.设置坚持目标的
        [[_pickerView_three.cancelButton_repeat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_pickerView_three.forPicker_view_repeat.frame=CGRectMake(0, COTENT_SIZE*1.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                self.pickerView_three.scrollEnabled=true;
            } completion:nil];
        }];
        
        //给完成按钮添加点击事件
        //完成按钮的点击，应该保存数据
        [[_pickerView_three.finishPickerButton_repeat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_pickerView_three.forPicker_view_repeat.frame=CGRectMake(0, COTENT_SIZE*1.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                //将cell的值改变
                self.for_repeat_cell_text=self->_pickerView_three.repeat_str;//将值显示到cell上
                [self.second_modify_tableView reloadData];
                self.pickerView_three.scrollEnabled=true;
            } completion:nil];
        }];
        //2.设置起始时间的
        //取消❌按钮的点击
        [[_pickerView_three.cancelButton_start rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_pickerView_three.forPicker_view_start.frame=CGRectMake(0, COTENT_SIZE*1.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                self.pickerView_three.scrollEnabled=true;
            } completion:nil];
        }];
        
        //给完成按钮添加点击事件
        //完成按钮的点击，应该保存数据
        [[_pickerView_three.finishPickerButton_start rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_pickerView_three.forPicker_view_start.frame=CGRectMake(0, COTENT_SIZE*1.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                //将cell的值改变
                self.for_start_cell_text=self->_pickerView_three.start_str;//将值显示到cell上
                [self.second_modify_tableView reloadData];
                self.pickerView_three.scrollEnabled=true;
            } completion:nil];
        }];
        //3.提醒时间的
        //取消❌按钮的点击
        [[_pickerView_three.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_pickerView_three.forPicker_view.frame=CGRectMake(0, COTENT_SIZE*1.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                self.pickerView_three.scrollEnabled=true;
            } completion:nil];
        }];
        
        //给完成按钮添加点击事件
        //完成按钮的点击，应该保存数据
        [[_pickerView_three.finishPickerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_pickerView_three.forPicker_view.frame=CGRectMake(0, COTENT_SIZE*1.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
                [self.alarm_temporary_array addObject:self->_pickerView_three.alarm_str];//将值添加到数组中
                //为了存值到数据库中的操作
                self.alarm_single_dic=[[NSDictionary alloc] init];
                //对拿来的字符串进行一次解析
                NSString *day_type;
                NSString *hour_type;
                NSString *minute_type;
                
                //第一个滚轮的逻辑 一.
                if([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"每"]){
                    if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"周"]) {
                        //第一个滚轮的逻辑 二.
                        day_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(0, 3)];
                        //第二个滚轮的逻辑 a.
                        if([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"点"]){
                            hour_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(3, 1)];
                            //第三个滚轮的逻辑 1.
                            if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]) {
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 1)];
                            }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]){
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 2)];
                            }
                            
                            //第二个滚轮的逻辑 b.
                        }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"点"]){
                            hour_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(3, 2)];
                            //第三个滚轮的逻辑 2.
                            if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]) {
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 1)];
                            }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"分"]){
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 2)];
                            }
                        }
                    }else{
                        day_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(0, 2)];
                        //第二个滚轮的逻辑 a.
                        if([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"点"]){
                            //第三个滚轮的逻辑 1.
                            hour_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(2, 1)];
                            if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"分"]) {
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(4, 1)];
                            }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]){
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(4, 2)];
                            }
                            
                            //第二个滚轮的逻辑 b.
                        }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"点"]){
                            hour_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(2, 2)];
                            //第三个滚轮的逻辑 2.
                            if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]) {
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 1)];
                            }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]){
                                minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 2)];
                            }
                        }
                    }
                }else{
                    //第一个滚轮的逻辑 二.
                    day_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(0, 3)];
                    //第二个滚轮的逻辑 a.
                    if([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"点"]){
                        hour_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(3, 1)];
                        //第三个滚轮的逻辑 1.
                        if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"分"]) {
                            minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 1)];
                        }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]){
                            minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 2)];
                        }
                        
                        //第二个滚轮的逻辑 b.
                    }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"点"]){
                        hour_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(3, 2)];
                        //第三个滚轮的逻辑 2.
                        if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"分"]) {
                            minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 1)];
                        }else if ([[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"分"]){
                            minute_type=[self->_pickerView_three.alarm_str substringWithRange:NSMakeRange(6, 2)];
                        }
                    }
                }
                self.alarm_single_dic=@{@"alarm_day":day_type,
                                        @"alarm_hour":hour_type,
                                        @"alarm_minute":minute_type
                                        };
                [self.alarm_all_array addObject:self.alarm_single_dic];
                
                [self.second_modify_tableView reloadData];
                 self.pickerView_three.scrollEnabled=true;
            } completion:nil];
        }];
        
//        //添加点击事件
//        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct)];
//        tapGes.numberOfTapsRequired=1;
//        tapGes.numberOfTapsRequired=1;
//        [_pickerView_three addGestureRecognizer:tapGes];
    }
    return _pickerView_three;
}

-(NSString *)for_start_cell_text{
    if (!_for_start_cell_text) {
        _for_start_cell_text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"start_date"];
    }
    return _for_start_cell_text;
}

#pragma mark 第三个修改部分的
-(UITableView *)third_modify_tableView{
    if (!_third_modify_tableView) {
        _third_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 370+self.second_modify_tableView.frame.size.height+10+40+10, (SCREEN_WIDTH-20), 236)];
        _third_modify_tableView.dataSource=self;
        _third_modify_tableView.delegate=self;
        [_third_modify_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:cell_id_fifthStep
         ];
        _third_modify_tableView.backgroundColor=[UIColor whiteColor];
        _third_modify_tableView.layer.cornerRadius=12;
    }
    return _third_modify_tableView;
}
-(UILabel*)third_title{
    if (!_third_title) {
        _third_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 370+self.second_modify_tableView.frame.size.height+10, 150, 40)];
        _third_title.backgroundColor=[UIColor clearColor];
        _third_title.text=@"Step 3 我不要";
        _third_title.textColor=[UIColor whiteColor];
        _third_title.textAlignment=NSTextAlignmentLeft;
        _third_title.font=[UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    }
    return _third_title;
}
#pragma mark 第四个修改部分的
-(UITableView *)fourth_modify_tableView{
    if (!_fourth_modify_tableView) {
        _fourth_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 370+self.second_modify_tableView.frame.size.height+10+40+10+240+10+40+10, (SCREEN_WIDTH-20), 59)];
        _fourth_modify_tableView.dataSource=self;
        _fourth_modify_tableView.delegate=self;
        [_fourth_modify_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:cell_id_sixthStep
         ];
        _fourth_modify_tableView.backgroundColor=[UIColor whiteColor];
        _fourth_modify_tableView.layer.cornerRadius=12;
    }
    return _fourth_modify_tableView;
}
-(UILabel*)fourth_title{
    if (!_fourth_title) {
        _fourth_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 370+self.second_modify_tableView.frame.size.height+10+40+10+240+10, 150, 40)];
        _fourth_title.backgroundColor=[UIColor clearColor];
        _fourth_title.text=@"Step 4 奖励";
        _fourth_title.textColor=[UIColor whiteColor];
        _fourth_title.textAlignment=NSTextAlignmentLeft;
        _fourth_title.font=[UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    }
    return _fourth_title;
}
#pragma mark 完成部分
-(TapMusicButton *)finishButton{
    if (!_finishButton) {
        _finishButton=[[TapMusicButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*0.90338)/2, 370+self.second_modify_tableView.frame.size.height+10+40+10+240+10+40+10+60+26, SCREEN_WIDTH*0.90338, SCREEN_HEIGHT*0.07880434)];
        [_finishButton setImage:[UIImage imageNamed:@"modify_complete_image"] forState:UIControlStateNormal];
        [[_finishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           //弹出提醒框是否确认修改，
            self.alertView_complete=[[AlertView alloc] init];
            [self.alertView_complete showAlertWithTitle:@"确认所有修改？" message:@"点击确认后，所有修改将生效，无法撤销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
        }];
    }
    return _finishButton;
}
//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text=@"修改项目";
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
        if (self.isModify) {
            //修改过内容，但是未点击过完成按钮
            self.alertView_back=[[AlertView alloc] init];
            [self.alertView_back showAlertWithTitle:@"确定放弃所有未保存修改吗？" message:@"返回上一级会导致所有未保存的修改无效" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        }else{
            [self.navigationController popViewControllerAnimated:true];
        }
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
    //右上下一步按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"确定删除该任务吗？" message:@"删除任务后与该任务相关的所有记录一并被删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除"];
    }];
    
    UIBarButtonItem *barButtonItem_right_next=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_next];
    self.navigationItem.rightBarButtonItem=barButtonItem_right_next;
    
}

#pragma mark 数据源和代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.first_modify_tableView]) {
        return 4;
    }else if ([tableView isEqual:self.second_modify_tableView]){
        return (4+self.alarm_temporary_array.count);//通过内联计算得出的行数，这样就把model和View层关联太紧密了,希望以后找到好的办法
    }else if ([tableView isEqual:self.third_modify_tableView]){
        return 4;
    }else if ([tableView isEqual:self.fourth_modify_tableView]){
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.first_modify_tableView]) {
        TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_firstStep];
        if (cell==nil) {
            cell=[[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_firstStep];
        }
        
        cell.imageView.image=[UIImage imageNamed:self.imageName_array[indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
        cell.cellTextField.placeholder=self.placeHoder_array[indexPath.row];
        //根据索引值确定内容
        switch (indexPath.row) {
            case 0:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_title"];
                //用于更新数据库值的
                self.subject_title=cell.cellTextField.text;
                self.first_cell=cell.cellTextField.rac_textSignal;
                break;
            case 1:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_get"];
                //用于更新数据库值的
                self.subject_get=cell.cellTextField.text;
                self.second_cell=cell.cellTextField.rac_textSignal;
                break;
            case 2:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_love_get"];
                //用于更新数据库值的
                self.subject_love_get=cell.cellTextField.text;
                 self.third_cell=cell.cellTextField.rac_textSignal;
                break;
            case 3:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_best_me"];
                //用于更新数据库值的
                self.subject_best_me=cell.cellTextField.text;
                 self.fourth_cell=cell.cellTextField.rac_textSignal;
                break;
            default:
                break;
        }

        
        
//        if (!(self.first_cell&&self.second_cell&&self.third_cell&&self.fourth_cell)) {
//            NSLog(@"未初始化完成");
//        }else{
//            self.enableSignal=[[RACSignal combineLatest:@[self.first_cell,self.second_cell,self.third_cell,self.fourth_cell]] map:^id _Nullable(RACTuple * _Nullable value) {
//                self.subject_title=value[0];
//                self.subject_get=value[1];
//                self.subject_love_get=value[2];
//                self.subject_best_me=value[3];
//                return @([value[0] length]>0&&[value[1] length]>0&&[value[2] length]>0&&[value[3] length]>0);
//            }];
////            [self.enableSignal subscribeNext:^(id  _Nullable x) {
////
////            }];
//        }
        
        return cell;
    }else if ([tableView isEqual:self.second_modify_tableView]){
        //第一行是选择坚持目标的
        if (indexPath.row==0) {
            PickerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_secondStep];
            if (cell==nil) {
                cell=[[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_secondStep];
            }
            cell.cell_image.image=[UIImage imageNamed:@"repeat_image"];
            cell.cell_title.text=@"设置坚持目标";
            cell.cell_time.text=self.for_repeat_cell_text;
            self.indexPath_repeat=indexPath;
            
            
            return cell;
        }else if (indexPath.row==1) {
             //第二行是选择起始日期的
            PickerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_secondStep];
            if (cell==nil) {
                cell=[[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_secondStep];
            }
            cell.cell_image.image=[UIImage imageNamed:@"start_repeat_image"];
            cell.cell_title.text=@"设置起始日期";
            cell.cell_time.text=self.for_start_cell_text;
            self.indexPath_start=indexPath;
            
            return cell;
        }else if (indexPath.row==2) {
             //第三行是选择提醒是否开启的
            SwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_thirdStep];
            if (cell==nil) {
                cell=[[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_thirdStep];
            }
            cell.cell_image.image=[UIImage imageNamed:@"clock_image"];
            cell.cell_switch.on=[[NSUserDefaults standardUserDefaults] boolForKey:@"isAlarm"];
            if (!cell.cell_switch.isOn) {
                cell.cell_title.text=@"提醒未开启";
            }else{
                cell.cell_title.text=@"提醒已经开启";
            }
            //开关的切换事件
            [[cell.cell_switch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
                //将是否打开提醒存储在NSUserDefaults中
                if (cell.cell_switch.isOn) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAlarm"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAlarm"];
                }
            }];
            return cell;
        }else if(indexPath.row==3){
            //第四行是添加提醒时间的
            AddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_forthStep];
            if (cell==nil) {
                cell=[[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_forthStep];
            }
            cell.cell_image.image=[UIImage imageNamed:@"plus_image"];
            cell.cell_title.text=@"点击添加更多时间";
            
            return cell;
        }else{
            //除去前面的行，后面的所有行
            AddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_forthStep];
            if (cell==nil) {
                cell=[[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_forthStep];
            }
            cell.cell_image.image=[UIImage imageNamed:@"minus_image"];
            
            cell.cell_title.text=self.alarm_temporary_array[indexPath.row-4];
            
            return cell;
        }
    }else if ([tableView isEqual:self.third_modify_tableView]){
        TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_fifthStep];
        if (cell==nil) {
            cell=[[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_fifthStep];
        }
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.cell_textFiled_array[indexPath.row]]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
        cell.cellTextField.placeholder=self.cell_textField_placeHolder[indexPath.row];
        //根据索引值确定内容
        switch (indexPath.row) {
            case 0:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_things"];
                //用于更新数据库值的
                self.things_text=cell.cellTextField.text;
                self.fifth_cell=cell.cellTextField.rac_textSignal;
                break;
            case 1:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_people"];
                //用于更新数据库值的
                self.people_text=cell.cellTextField.text;
                self.sixth_cell=cell.cellTextField.rac_textSignal;
                break;
            case 2:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_time"];
                //用于更新数据库值的
                self.time_text=cell.cellTextField.text;
                self.seventh_cell=cell.cellTextField.rac_textSignal;
                break;
            case 3:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_thought"];
                //用于更新数据库值的
                self.thought_text=cell.cellTextField.text;
                self.eightth_cell=cell.cellTextField.rac_textSignal;
                break;
            default:
                break;
        }
        
        if (!(self.fifth_cell&&self.sixth_cell&&self.seventh_cell&&self.eightth_cell)) {
            NSLog(@"未初始化完成");
        }else{
            self.enableSignal_2=[[RACSignal combineLatest:@[self.fifth_cell,self.sixth_cell,self.seventh_cell,self.eightth_cell]] map:^id _Nullable(RACTuple * _Nullable value) {
                self.things_text=value[0];
                self.people_text=value[1];
                self.time_text=value[2];
                self.thought_text=value[3];
                return @([value[0] length]>0&&[value[1] length]>0&&[value[2] length]>0&&[value[3] length]>0);
            }];
            //            [self.enableSignal subscribeNext:^(id  _Nullable x) {
            //
            //            }];
        }
        
        return cell;
    }else if ([tableView isEqual:self.fourth_modify_tableView]){
        TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_sixthStep];
        if (cell==nil) {
            cell=[[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_sixthStep];
        }
        cell.left_ImageView.image=[UIImage imageNamed:@"reward_image_forFourth"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
        cell.cellTextField.placeholder=@"请输入完成任后的奖励";
        cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reward"];
        
        //用于更新数据库值的
        self.reward_text=cell.cellTextField.text;
        
        self.nineth_cell=cell.cellTextField.rac_textSignal;
        [self.nineth_cell subscribeNext:^(id  _Nullable x) {
            if ([x length]>0) {
                self.reward_text=x;
            }
        }];
       
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

//表视图的选择代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.second_modify_tableView]) {
        self.isModify=true;
        //如果是点击设置坚持目标的行
        if (indexPath.row==0) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //设置scrollView的滚动位置
                [self.pickerView_three setContentOffset:CGPointMake(0, SCREEN_HEIGHT*0.45) animated:true];
                //设置弹出的位置
                self.pickerView_three.forPicker_view_repeat.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            } completion:nil];
            //将scrollView设置为不可滑动
            self.pickerView_three.scrollEnabled=false;
            //选择完时间后，将选择框弹出
            //将scrllView设置为可滑动
        }
        //如果是点击设置起始日期的行
        if (indexPath.row==1) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //设置scrollView的滚动位置
                [self.pickerView_three setContentOffset:CGPointMake(0, SCREEN_HEIGHT*0.45) animated:true];
                //设置弹出的位置
                self.pickerView_three.forPicker_view_start.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            } completion:nil];
            //将scrollView设置为不可滑动
            self.pickerView_three.scrollEnabled=false;
            //选择完时间后，将选择框弹出
            //将scrllView设置为可滑动
        }
        
        //如果是点击添加更多时间的行
        if (indexPath.row==3) {
            //弹出选择框，选择时间，然后重新加载表视图就可以了，不用做太复杂的动画了，以后有时间再完善这里的动画吧，
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //设置scrollView的滚动位置
                [self.pickerView_three setContentOffset:CGPointMake(0, SCREEN_HEIGHT*0.45) animated:true];
                //设置弹出的位置
                self.pickerView_three.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
            } completion:nil];
            //将scrollView设置为不可滑动
            self.pickerView_three.scrollEnabled=false;
            //选择完时间后，将选择框弹出
            //将scrllView设置为可滑动
        }
        if (indexPath.row>3) {
            //将点按的一行从数组中删除
            AddTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            for (NSString *str in self.alarm_temporary_array) {
                if ([cell.cell_title.text isEqualToString:str]) {
                    [self.alarm_temporary_array removeObject:str];
                }
            }
            [self.second_modify_tableView reloadData];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pickerView_three endEditing:YES];
}

//弹出框的代理方法
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:self.alertView_complete.myAlertView]) {
        //如果是确认是否修改完成
        if (buttonIndex==0) {
            //取消
        }else if(buttonIndex==1){
            //确认修改
            self.isModify=false;
            //存储所有值到数据库中
            [self.first_cell subscribeNext:^(id  _Nullable x) {
                self.subject_title=x;
            }];
            [self.second_cell subscribeNext:^(id  _Nullable x) {
                self.subject_get=x;
            }];
            [self.third_cell subscribeNext:^(id  _Nullable x) {
                self.subject_love_get=x;
            }];
            [self.fourth_cell subscribeNext:^(id  _Nullable x) {
                self.subject_best_me=x;
            }];
            [self.fifth_cell subscribeNext:^(id  _Nullable x) {
                self.things_text=x;
            }];
            [self.sixth_cell subscribeNext:^(id  _Nullable x) {
                self.people_text=x;
            }];
            [self.seventh_cell subscribeNext:^(id  _Nullable x) {
                self.time_text=x;
            }];
            [self.eightth_cell subscribeNext:^(id  _Nullable x) {
                self.thought_text=x;
            }];
            [self.nineth_cell subscribeNext:^(id  _Nullable x) {
                self.reward_text=x;
            }];
            NSLog(@"%@",self.subject_title);
            NSLog(@"%@",self.subject_get);
            NSLog(@"%@",self.subject_love_get);
            NSLog(@"%@",self.subject_best_me);
            NSLog(@"%@",self.things_text);
            NSLog(@"%@",self.people_text);
            NSLog(@"%@",self.time_text);
            NSLog(@"%@",self.thought_text);
            NSLog(@"%@",self.reward_text);
            [[AddModel shareAddMode] updateDataWithSubject_title:self.subject_title subject_get:self.subject_get subject_love_get:self.subject_love_get subject_best_me:self.subject_best_me goal_total:[self.for_repeat_cell_text integerValue] start_date:self.for_start_cell_text reject_things:self.things_text reject_people:self.people_text reject_time:self.time_text reject_thought:self.thought_text reward:self.reward_text where:(self.delete_index+1)];
            //将数组中的提醒时间值存到NotifiModel中
            //1.先删除
            [[NotifiModel notifiModel] deleteDataByID:(self.delete_index+1)];
            //2.再存储
            NSInteger for_plus=1;
            for (NSDictionary *dic in self.alarm_all_array) {
                //每循环一次就存储一条数据到数据库
                [NotifiModel notifiModel].alarm_id=for_plus;//关联该任务的数据条数累加
                [NotifiModel notifiModel].subject_id=(self.delete_index+1);
                [NotifiModel notifiModel].alarm_day=[dic objectForKey:@"alarm_day"];
                [NotifiModel notifiModel].alarm_hour=[dic objectForKey:@"alarm_hour"];
                [NotifiModel notifiModel].alarm_minute=[dic objectForKey:@"alarm_minute"];
                [[NotifiModel notifiModel] insertData];
                
                for_plus++;
            }
            //取消之前的通知事项，现在重新确立通知事项
            //关闭每日待办项目提醒
            //根据标识取消每日通知
            //循环所有任务取消所有通知
            for (NSDictionary *dic in [[AddModel shareAddMode] selectEveryThing]) {
                for (NSInteger i=1; i<8; i++)  {
                    [self removePending:[NSString stringWithFormat:@"%ldnotifiAND%ld",i,[[dic objectForKey:@"id"] integerValue]]];//取消指定标识符下的通知
                }
            }
            //重新确立通知
            [self startNotifi];
            //返回上一级
            [self.navigationController popViewControllerAnimated:true];
        }
    }else if ([alertView isEqual:self.alertView.myAlertView]){
        //如果是确认是否删除
        if (buttonIndex==0) {
            //取消
        }else if(buttonIndex==1){
            //继续删除
            NSArray *controllers = self.navigationController.viewControllers;
            [[AddModel shareAddMode] deleteDataByID:(self.delete_index+1)];
            for ( id viewController in controllers) {
                if ([viewController isKindOfClass:[SubjectCountViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                }
            }
        }
    }else if ([alertView isEqual:self.alertView_back.myAlertView]){
        //如果是确认是否放弃修改
        if (buttonIndex==0) {
            //取消
        }else if (buttonIndex==1){
            //继续返回
            [self.navigationController popViewControllerAnimated:true];
        }
    }

}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.isModify=true;
////    [self.view endEditing:YES];
//}
//-(void)tapAct{
//    [self.pickerView_three endEditing:YES];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
//    [aTextfield resignFirstResponder];//关闭键盘
//    return YES;
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
