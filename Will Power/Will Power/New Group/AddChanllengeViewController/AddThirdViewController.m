//
//  AddThirdViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/5.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AddThirdViewController.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import <FlatUIKit.h>
#import "AlertView.h"
#import "TapMusicButton.h"
#import "TapMusic.h"
#import <ReactiveObjC.h>
#import "TextFieldTableViewCell.h"
#import "LabelTableViewCell.h"
#import "AddFourthViewController.h"
#import "AddModel.h"
#import "WrongMusic.h"
#import <SCLAlertView.h>

static NSString *cell_textFiled_id=@"cell_textfiled";
static NSString *cell_label_id=@"cell_label";

@interface AddThirdViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) AlertView *alertView;

@property(nonatomic,strong)UITableView *discovery_tableView;
@property(nonatomic,strong)UITableView *delete_tableView;

@property(nonatomic,strong)UIView *for_discovery;
@property(nonatomic,strong)UIView *for_delete;

@property(nonatomic,strong)NSArray *cell_textFiled_array;
@property(nonatomic,strong)NSArray *cell_textField_placeHolder;
@property(nonatomic,strong)NSArray *cell_titleLabel_array;

//用于判断用户是否输入完毕
@property(nonatomic,strong)RACSignal *firstSignal;
@property(nonatomic,strong)RACSignal *secondSignal;
@property(nonatomic,strong)RACSignal *thirdSignal;
@property(nonatomic,strong)RACSignal *fourthSignal;
@property(nonatomic,strong)RACSignal *enableSignal;
@property(nonatomic,assign)BOOL isFinish;
@property(nonatomic,copy)NSString *things_text;
@property(nonatomic,copy)NSString *people_text;
@property(nonatomic,copy)NSString *time_text;
@property(nonatomic,copy)NSString *thought_text;

@end

@implementation AddThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navTitle];
    [self navItem];
    [self loadUI];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.alertView=[[AlertView alloc] init];
          [self.alertView showAlertWithTitle:@"我不要" message:@"回想一下，曾经的自控尝试过程中有没有让我失控的环境或东西，包括让我失控的人或时间点？\n比如，我刚想好好的去图书馆学习，但是朋友正好约我一起玩游戏，我很难拒绝，于是我的计划又泡汤了。\n根据提示，请识别的这些让你自控力失控的陷阱" cancelButtonTitle:@"明白了"];
    });
}

-(void)loadUI{
    
    //第一个tableView
    UILabel *titleLabel_discovery=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 30)];
    titleLabel_discovery.text=@"发现";
    titleLabel_discovery.textColor=[UIColor darkGrayColor];
    titleLabel_discovery.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    titleLabel_discovery.backgroundColor=[UIColor whiteColor];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(25, 35, 50, 2)];
    line.backgroundColor=[UIColor darkGrayColor];
    
    self.for_discovery=[[UIView alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, 270+10)];
    self.for_discovery.backgroundColor=[UIColor whiteColor];
    self.for_discovery.layer.cornerRadius=12;
    
    self.discovery_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH-20, 240)];
    self.discovery_tableView.layer.cornerRadius=12;
    self.discovery_tableView.scrollEnabled=NO;
    self.discovery_tableView.dataSource=self;
    self.discovery_tableView.delegate=self;
    [self.discovery_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:cell_textFiled_id];
    
    [self.for_discovery addSubview:titleLabel_discovery];
    [self.for_discovery addSubview:line];
    [self.for_discovery addSubview: self.discovery_tableView];
    [self.view addSubview:self.for_discovery];
    
    self.cell_textFiled_array=@[@"bad_thing_image",@"bad_people_image",@"bad_time_image",@"bad_will_image"];
    self.cell_textField_placeHolder=@[@"可能让我失控的事情或东西",@"可能让我失控的人",@"可能让我失控的时间",@"可能让我失控的心理"];
    
    //第二个tableView
    
    UILabel *titleLabel_delete=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 30)];
    titleLabel_delete.text=@"远离";
    titleLabel_delete.textColor=[UIColor darkGrayColor];
    titleLabel_delete.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    titleLabel_delete.backgroundColor=[UIColor whiteColor];
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(25, 35, 50, 2)];
    line2.backgroundColor=[UIColor darkGrayColor];
    
    self.cell_titleLabel_array=@[@"软件游戏，请删除",@"如果是人，在完成这件事时，请慎重交往",@"时间点，在最精神饱满的时候开始干",@"类似这样的做法，您有想法了吗?开始吧!"];
    
    self.for_delete=[[UIView alloc] initWithFrame:CGRectMake(10, 332, SCREEN_WIDTH-20, 240)];
    self.for_delete.layer.cornerRadius=12;
    self.for_delete.backgroundColor=[UIColor whiteColor];
    
    self.delete_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH-20, 190)];
    self.delete_tableView.layer.cornerRadius=12;
    self.delete_tableView.scrollEnabled=NO;
    self.delete_tableView.dataSource=self;
    self.delete_tableView.delegate=self;
    
    [self.for_delete addSubview:titleLabel_delete];
    [self.for_delete addSubview:line2];
    [self.for_delete addSubview:self.delete_tableView];
    [self.view addSubview:self.for_delete];
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"我不要";
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
        [self.alertView showAlertWithTitle:@"我不要" message:@"回想一下，曾经的自控尝试过程中有没有让我失控的环境或东西，包括让我失控的人或时间点？\n比如，我刚想好好的去图书馆学习，但是朋友正好约我一起玩游戏，我很难拒绝，于是我的计划又泡汤了。\n根据提示，请识别的这些让你自控力失控的陷阱" cancelButtonTitle:@"明白了"];
    }];
    
    UIBarButtonItem *barButtonItem_right_help=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_help];
    
    //右上完成按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 70, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"next_image"] forState:UIControlStateNormal];
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的完成我被惦记了");
        
        //验证用户是否输入完毕
        if (self.isFinish) {
            
            //设置model
            [AddModel shareAddMode].reject_things=self.things_text;
            [AddModel shareAddMode].reject_people=self.people_text;
            [AddModel shareAddMode].reject_time=self.time_text;
            [AddModel shareAddMode].reject_thought=self.thought_text;

            AddFourthViewController *addFourth_VC=[[AddFourthViewController alloc] init];
            [self.navigationController pushViewController:addFourth_VC animated:true];
        }else{
            WrongMusic *wrongMusic=[[WrongMusic alloc] init];
            [wrongMusic playSoundEffect_wrong];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"仍有未输入的内容" subTitle:@"请完成本页的所有输入内容后再跳转到下一页面" closeButtonTitle:@"好的" duration:0.0f];
        }
        
    }];
    
    UIBarButtonItem *barButtonItem_right_next=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_next];
    self.navigationItem.rightBarButtonItems=@[barButtonItem_right_next,barButtonItem_right_help];
}

#pragma mark --tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.discovery_tableView]) {
        return 1;
    }else if ([tableView isEqual:self.delete_tableView]){
        return 1;
    }
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.discovery_tableView]) {
        return 4;
    }else if ([tableView isEqual:self.delete_tableView]){
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.discovery_tableView]) {
        TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_textFiled_id];
        if (cell==nil) {
            cell=[[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_textFiled_id];
        }
        
        cell.imageView.image=[UIImage imageNamed:self.cell_textFiled_array[indexPath.row]];
        cell.cellTextField.placeholder=self.cell_textField_placeHolder[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
        //信号初始化
        switch (indexPath.row) {
            case 0:
                self.firstSignal=cell.cellTextField.rac_textSignal;
                break;
            case 1:
                self.secondSignal=cell.cellTextField.rac_textSignal;
                break;
            case 2:
                self.thirdSignal=cell.cellTextField.rac_textSignal;
                break;
            case 3:
                self.fourthSignal=cell.cellTextField.rac_textSignal;
                break;
                
            default:
                break;
        }
        //合并信号量用于页面跳转判断
        if (!(self.firstSignal&&self.secondSignal&&self.thirdSignal&&self.fourthSignal)) {
            NSLog(@"未初始化完成");
        }else{
            self.enableSignal=[[RACSignal combineLatest:@[self.firstSignal,self.secondSignal,self.thirdSignal,self.fourthSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
                self.things_text=value[0];
                self.people_text=value[1];
                self.time_text=value[2];
                self.thought_text=value[3];
                return @([value[0] length]>0&&[value[1] length]>0&&[value[2] length]>0&&[value[3] length]>0);
            }];
            [self.enableSignal subscribeNext:^(id  _Nullable x) {
                self.isFinish=[x boolValue];
            }];
        }
        
        return cell;
    }else if ([tableView isEqual:self.delete_tableView]){
        LabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_label_id];
        if (cell==nil) {
            cell=[[LabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_label_id];
        }
        
        cell.cell_label.text=self.cell_titleLabel_array[indexPath.row];
        cell.left_ImageView.image=[UIImage imageNamed:@"do_now_image"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
      
        return cell;
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.discovery_tableView]) {
        return 59;
    }else if ([tableView isEqual:self.delete_tableView]){
        return 49;
    }
    return 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
