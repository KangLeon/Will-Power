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

static NSString *cell_id_firstStep=@"first_modify_tableView_cell_id";
static NSString *cell_id_secondStep=@"second_modify_tableView_cell_id";
static NSString *cell_id_thirdStep=@"third_modify_tableView_cell_id";
static NSString *cell_id_forthStep=@"forth_modify_tableView_cell_id";
static NSString *cell_id_fifthStep=@"fifth_modify_tableView_cell_id";
static NSString *cell_id_sixthStep=@"sixth_modify_tableView_cell_id";
static NSString *cell_id_seventhStep=@"seventh_modify_tableView_cell_id";
static NSString *cell_id_eighthStep=@"eighth_modify_tableView_cell_id";

@interface SubjectDeleteViewController ()<UITableViewDelegate,UITableViewDataSource,FUIAlertViewDelegate>
@property(nonatomic,strong)UITableView *first_modify_tableView;
@property(nonatomic,strong)UITableView *second_modify_tableView;
@property(nonatomic,strong)UITableView *third_modify_tableView;
@property(nonatomic,strong)UITableView *fourth_modify_tableView;

@property(nonatomic,strong)UILabel *first_title;
@property(nonatomic,strong)UILabel *second_title;
@property(nonatomic,strong)UILabel *third_title;
@property(nonatomic,strong)UILabel *fourth_title;

@property(nonatomic,strong)TapMusicButton *finishButton;

//图片赋值的array
//1.
@property(nonatomic,strong)NSArray *imageName_array;
@property(nonatomic,strong)NSArray *placeHoder_array;
//3.
@property(nonatomic,strong)NSArray *cell_textFiled_array;
@property(nonatomic,strong)NSArray *cell_textField_placeHolder;

@property(nonatomic,strong) AlertView *alertView;

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
    UIScrollView *scrollView_for_modify=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView_for_modify.backgroundColor=[UIColor clearColor];
    scrollView_for_modify.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.8);
    scrollView_for_modify.showsVerticalScrollIndicator=NO;//不限时垂直的滚动条
    //添加项目修改第一步：tableView（我想要）
    [scrollView_for_modify addSubview:self.first_title];
    [scrollView_for_modify addSubview:self.first_modify_tableView];
    //添加项目修改第二部：tableView（我要做）
    [scrollView_for_modify addSubview:self.second_title];
    [scrollView_for_modify addSubview:self.second_modify_tableView];
    //添加项目修改第三部：tableView（我不要）
    [scrollView_for_modify addSubview:self.third_title];
    [scrollView_for_modify addSubview:self.third_modify_tableView];
    //添加项目修改第四部:奖励
    [scrollView_for_modify addSubview:self.fourth_title];
    [scrollView_for_modify addSubview:self.fourth_modify_tableView];
    //添加完成按钮
    [scrollView_for_modify addSubview:self.finishButton];
    
    [self.view addSubview:scrollView_for_modify];
}

#pragma mark 懒加载部分
#pragma mark 第一个修改部分的
-(UITableView *)first_modify_tableView{
    if (!_first_modify_tableView) {
        _first_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 70, (SCREEN_WIDTH-20), 240)];
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
#pragma mark 第二个修改部分的
-(UITableView *)second_modify_tableView{
    if (!_second_modify_tableView) {
        _second_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 370, (SCREEN_WIDTH-20), 240+[[NotifiModel notifiModel] countForDataIn:(self.delete_index+1)]*60)];
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
#pragma mark 第三个修改部分的
-(UITableView *)third_modify_tableView{
    if (!_third_modify_tableView) {
        _third_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 370+self.second_modify_tableView.frame.size.height+10+40+10, (SCREEN_WIDTH-20), 240)];
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
        _fourth_modify_tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 370+self.second_modify_tableView.frame.size.height+10+40+10+240+10+40+10, (SCREEN_WIDTH-20), 60)];
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
        _finishButton=[[TapMusicButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-374)/2, 370+self.second_modify_tableView.frame.size.height+10+40+10+240+10+40+10+60+26, 374, 58)];
        [_finishButton setImage:[UIImage imageNamed:@"modify_complete_image"] forState:UIControlStateNormal];
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
        [self.navigationController popViewControllerAnimated:true];
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
        return (4+[[NotifiModel notifiModel] countForDataIn:(self.delete_index+1)]);//通过内联计算得出的行数，这样就把model和View层关联太紧密了,希望以后找到好的办法
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
                break;
            case 1:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_get"];
                break;
            case 2:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_love_get"];
                break;
            case 3:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"subject_best_me"];
                break;
            default:
                break;
        }
        
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
            cell.cell_time.text=[NSString stringWithFormat:@"%@天",[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"goal_total"]];
            
            return cell;
        }else if (indexPath.row==1) {
             //第二行是选择起始日期的
            PickerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id_secondStep];
            if (cell==nil) {
                cell=[[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id_secondStep];
            }
            cell.cell_image.image=[UIImage imageNamed:@"start_repeat_image"];
            cell.cell_title.text=@"设置起始日期";
            cell.cell_time.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"start_date"];
            
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
                [tableView reloadData];
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
            //构造显示文字字符串
            NSDictionary *resultDic=[[[NotifiModel notifiModel] selectItemsIn:(self.delete_index+1)] objectAtIndex:indexPath.row-4];
            NSString *dateString=[NSString stringWithFormat:@"%@%@点%@分",[resultDic objectForKey:@"alarm_day"],[resultDic objectForKey:@"alarm_hour"],[resultDic objectForKey:@"alarm_minute"]];
            cell.cell_title.text=dateString;
            
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
                break;
            case 1:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_people"];
                break;
            case 2:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_time"];
                break;
            case 3:
                cell.cellTextField.text=[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.delete_index] objectForKey:@"reject_thought"];
                break;
            default:
                break;
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
       
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

//弹出框的代理方法
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //取消
    }else if(buttonIndex==1){
        //继续删除
        
    }
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
