//
//  AddFirstViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AddFirstViewController.h"
#import <ReactiveObjC.h>
#import "ColorDefine.h"
#import <FlatUIKit.h>
#import "SizeDefine.h"
#import "AlertView.h"
#import "TextFieldTableViewCell.h"
#import "AddSecondViewController.h"
#import "TapMusicButton.h"
#import "AddModel.h"
#import <SCLAlertView.h>
#import "WrongMusic.h"

static NSString *cell_ID=@"my_cell";

@interface AddFirstViewController ()<FUIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) UIView *forTableView;//放置TableView的view


@property(nonatomic,strong) UIView *forTextFiled;//放置想坚持的事情的view

@property(nonatomic,strong) UITextField *cellTextFiled;//请输入想坚持的事情的textfield

@property(nonatomic,strong) UITableView *editTableView;

@property(nonatomic,strong)RACSignal *enableSignal;
@property(nonatomic,strong)RACSignal *first_cell;
@property(nonatomic,strong)RACSignal *second_cell;
@property(nonatomic,strong)RACSignal *third_cell;
@property(nonatomic,strong)RACSignal *fourth_cell;
@property(nonatomic,assign)BOOL isFinish;
@property(nonatomic,copy)NSString *subject_title;
@property(nonatomic,copy)NSString *subject_get;
@property(nonatomic,copy)NSString *subject_love_get;
@property(nonatomic,copy)NSString *subject_best_me;

@property(nonatomic,strong) AlertView *alertView;

//图片和占位文字的array
@property(nonatomic,strong)NSArray *imageName_array;
@property(nonatomic,strong)NSArray *placeHoder_array;

@end

@implementation AddFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navItem];
    [self navTitle];
    [self loadUI];
    [self.editTableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:cell_ID];
}

-(void)loadUI{

    //添加控件
    [self.forTextFiled addSubview:self.cellTextFiled];
    [self.view addSubview:self.forTextFiled];
    [self.forTableView addSubview:self.editTableView];
    [self.view addSubview:self.forTableView];
    
    //array的赋值
    self.imageName_array=@[@"get_image",@"love_image",@"self_image"];
    self.placeHoder_array=@[@"我会从挑战成功直接得到什么？",@"爱我和我爱的人会得到什么？",@"那个美好的自己是怎样的？"];
    
    
    //提示框只第一次显示，其他情况不提示
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"开始之前" message:@"意志力挑战总共分为3个阶段，\n1.构建并修缮计划\n2.实施并记录\n3.巩固与总结" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"明白了开始做计划"];
    });
    
}

#pragma mark 懒加载部分
- (UIView *)forTableView{
    if (!_forTableView) {
        self.forTableView=[[UIView alloc] initWithFrame:CGRectMake(10, 106, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.26)];
    }
    return _forTableView;
}
- (UIView *)forTextFiled{
    if (!_forTextFiled) {
        self.forTextFiled=[[UIView alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH-20, 60)];
        self.forTextFiled.layer.cornerRadius=12;
        self.forTextFiled.backgroundColor=[UIColor whiteColor];
    }
    return _forTextFiled;
}
-(UITextField *)cellTextFiled{
    if (!_cellTextFiled) {
        
        //这里没法使用悬浮框，因为悬浮框无法添加左边的图片
        self.cellTextFiled=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.forTextFiled.frame.size.width, self.forTextFiled.frame.size.height)];
        self.cellTextFiled.layer.cornerRadius=12;
        self.cellTextFiled.placeholder=@"请输入想坚持的事情";
        
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        UIImageView *title_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 30, 30)];
        [title_imageView setImage:[UIImage imageNamed:@"title_image"]];
        [titleView addSubview:title_imageView];
        
        self.cellTextFiled.leftView=titleView;
        self.cellTextFiled.leftViewMode=UITextFieldViewModeAlways;
        
        self.first_cell=_cellTextFiled.rac_textSignal;
    }
    return _cellTextFiled;
}
-(UITableView *)editTableView{
    if (!_editTableView) {
        self.editTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.forTableView.frame.size.width, self.forTableView.frame.size.height)];
        self.editTableView.delegate=self;
        self.editTableView.dataSource=self;
        self.editTableView.scrollEnabled=NO;
        self.editTableView.layer.cornerRadius=12;
    }
    return _editTableView;
}


#pragma mark 配置导航栏相关的

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"我想要";
    titleLabel.textColor=BACKGROUND_COLOR;
    titleLabel.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBar.layer.cornerRadius=17;
}

//弹出框的代理方法
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.alertView=[[AlertView alloc] init];
            [self.alertView showAlertWithTitle:@"提示" message:@"如果您需要帮助的话，您还可以在右上角帮助按钮找到我" cancelButtonTitle:@"好的"];
        });
    }else if(buttonIndex==1){
            self.alertView=[[AlertView alloc] init];
            [self.alertView showAlertWithTitle:@"我想要" message:@"要想培养一个好习惯或者是克服一个坏习惯，动机是最重要的，仔细想想你的出发点是什么？\n 比如：1.如果自控成功，我会直接收获什么？\n2.如果自控成功,我的家人，我的朋友，我喜欢的人会收获什么？\n3.最终那么美好的自己的是什么样子的？" cancelButtonTitle:@"明白了，开始做计划"];
    }
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
    
    //右上帮助按钮
    TapMusicButton *barButton_right_help=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_help.backgroundColor=[UIColor clearColor];
    [barButton_right_help setImage:[UIImage imageNamed:@"need_help_image"] forState:UIControlStateNormal];
    [[barButton_right_help rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        self.alertView=[[AlertView alloc] init];
        [self.alertView showAlertWithTitle:@"我想要" message:@"要想培养一个好习惯或者是克服一个坏习惯，动机是最重要的，仔细想想你的出发点是什么？\n 比如：1.如果自控成功，我会直接收获什么？\n2.如果自控成功,我的家人，我的朋友，我喜欢的人会收获什么？\n3.最终那么美好的自己的是什么样子的？" cancelButtonTitle:@"明白了，开始做计划"];
    }];
    
    UIBarButtonItem *barButtonItem_right_help=[[UIBarButtonItem alloc] initWithCustomView:barButton_right_help];
    
    //右上下一步按钮
    TapMusicButton *barButton_right_next=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_right_next.backgroundColor=[UIColor clearColor];
    [barButton_right_next setImage:[UIImage imageNamed:@"next_image"] forState:UIControlStateNormal];
    
    [[barButton_right_next rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        //在这里判断，如果没有每一项都有内容的话提示用户继续完成输入
        if (self.isFinish) {
            
            //设置model
            
            //设置id
            //对id值进行判断然后进行加值
            //这里的思路是查询有几条数据
            [AddModel shareAddMode].subject_id=1;
            if ([[AddModel shareAddMode] countForData]>0) {
                //如果有数据就在条数后面+1
                [AddModel shareAddMode].subject_id=[[AddModel shareAddMode] countForData]+1;
            }
            
            [AddModel shareAddMode].subject_title=self.subject_title;
            [AddModel shareAddMode].subject_get=self.subject_get;
            [AddModel shareAddMode].subject_love_get=self.subject_love_get;
            [AddModel shareAddMode].subject_best_me=self.subject_best_me;
            
//            NSLog(@"%@,%@,%@,%@",self.addModel.subject_title,self.addModel.subject_get,self.addModel.subject_love_get,self.addModel.subject_best_me);
            
            AddSecondViewController *addsecond_VC=[[AddSecondViewController alloc] init];
            [self.navigationController pushViewController:addsecond_VC animated:true];
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

#pragma mark --editTableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (cell==nil) {
        cell=[[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID];
    }
    
    NSString *imageNAme=self.imageName_array[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:imageNAme];
    cell.cellTextField.placeholder=self.placeHoder_array[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//取消选中状态
    
    //如果是第三个输入框的话，键盘的返回按钮样式是完成样式
    if (indexPath.row==2) {
        cell.cellTextField.delegate=self;
        cell.cellTextField.returnKeyType=UIReturnKeyDone;
        [[cell.cellTextField rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [cell.cellTextField resignFirstResponder];
            NSLog(@"输入完了");
        }];
    }
    
    switch (indexPath.row) {
        case 0:
            self.second_cell=cell.cellTextField.rac_textSignal;
            break;
            
        case 1:
            self.third_cell=cell.cellTextField.rac_textSignal;
            break;
        
        case 2:
            self.fourth_cell=cell.cellTextField.rac_textSignal;
            break;
        default:
            break;
    }
    if (!(self.second_cell&&self.third_cell&&self.fourth_cell)) {
        NSLog(@"未初始化完成");
    }else{
        self.enableSignal=[[RACSignal combineLatest:@[self.first_cell,self.second_cell,self.third_cell,self.fourth_cell]] map:^id _Nullable(RACTuple * _Nullable value) {
            self.subject_title=value[0];
            self.subject_get=value[1];
            self.subject_love_get=value[2];
            self.subject_best_me=value[3];
            return @([value[0] length]>0&&[value[1] length]>0&&[value[2] length]>0&&[value[3] length]>0);
        }];
        [self.enableSignal subscribeNext:^(id  _Nullable x) {
            self.isFinish=[x boolValue];
        }];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
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
