//
//  AddRemarkViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/8.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AddRemarkViewController.h"
#import "SizeDefine.h"
#import "TapMusicButton.h"
#import "ColorDefine.h"
#import <ReactiveObjC.h>
#import <JVFloatLabeledTextView.h>
#import "RemarkModel.h"
#import "NSDate+LocalDate.h"
#import "NSString+DateTitle.h"

@interface AddRemarkViewController ()<UITextFieldDelegate>

//用于数据库储存值的四个字符串
@property(nonatomic,strong)JVFloatLabeledTextView *float_TextField_content;
@property(nonatomic,strong)JVFloatLabeledTextView *float_Textfield;
@property(nonatomic,strong)NSString *heart_string;
@property(nonatomic,strong)NSString *remark_dateString;


@property(nonatomic,strong)UILabel *date_label;
@property(nonatomic,strong)TapMusicButton *heart_select_button;
@property(nonatomic,strong)UIImageView *heart_imageView;
@property(nonatomic,strong)UIImageView *arrow_imageView;

//卫星式菜单的三个选项按钮
@property(nonatomic,strong)TapMusicButton *normal_button;
@property(nonatomic,strong)TapMusicButton *sad_button;
@property(nonatomic,strong)TapMusicButton *smile_button;

@property(nonatomic,assign)BOOL isSelect;

@end

@implementation AddRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self loadUI];
}

#pragma mark 懒加载部分
-(UILabel *)date_label{
    if (!_date_label) {
        _date_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+45, 176+26+SCREEN_HEIGHT-300, 150, 50)];
        _date_label.backgroundColor=[UIColor whiteColor];
        _date_label.layer.cornerRadius=12;
        _date_label.clipsToBounds=YES;//iOS 7.0之后设置圆角需要设置该项
        _date_label.textColor=[UIColor grayColor];
        _date_label.textAlignment=NSTextAlignmentCenter;
        _date_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightThin];
    }
    return _date_label;
}

-(TapMusicButton *)heart_select_button{
    if(!_heart_select_button){
        _heart_select_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(10, 176+26+SCREEN_HEIGHT-300, 150, 50)];
        _heart_select_button.backgroundColor=[UIColor whiteColor];
        _heart_select_button.layer.cornerRadius=12;
        [_heart_select_button addSubview:self.heart_imageView];
        [_heart_select_button addSubview:self.arrow_imageView];
    }
    return _heart_select_button;
}
-(UIImageView *)heart_imageView{
    if(!_heart_imageView){
        _heart_imageView=[[UIImageView alloc] initWithFrame:CGRectMake((150-46)/2-15, 2, 46, 46)];
        _heart_imageView.backgroundColor=[UIColor clearColor];
    }
    return _heart_imageView;
}
-(UIImageView *)arrow_imageView{
    if(!_arrow_imageView){
        _arrow_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(150-40, 19, 20, 12)];
        _arrow_imageView.backgroundColor=[UIColor clearColor];
        _arrow_imageView.image=[UIImage imageNamed:@"arrow_heart_select_image"];
    }
    return _arrow_imageView;
}
//卫星式菜单的相关三个button
-(TapMusicButton *)normal_button{
    if(!_normal_button){
        _normal_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(10+(150-46)/2,176+26+SCREEN_HEIGHT-300+(50-46)/2, 46, 46)];
        [_normal_button setImage:[UIImage imageNamed:@"heart_normal_image"] forState:UIControlStateNormal];
        _normal_button.layer.cornerRadius=23;
    }
    return _normal_button;
}
-(TapMusicButton *)sad_button{
    if(!_sad_button){
        _sad_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(10+(150-46)/2,176+26+SCREEN_HEIGHT-300+(50-46)/2, 46, 46)];
        [_sad_button setImage:[UIImage imageNamed:@"heart_sad_image"] forState:UIControlStateNormal];
        _sad_button.layer.cornerRadius=23;
    }
    return _sad_button;
}
-(TapMusicButton *)smile_button{
    if(!_smile_button){
        _smile_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(10+(150-46)/2,176+26+SCREEN_HEIGHT-300+(50-46)/2, 46, 46)];
        [_smile_button setImage:[UIImage imageNamed:@"heart_smile_image"] forState:UIControlStateNormal];
        _smile_button.layer.cornerRadius=23;
    }
    return _smile_button;
}

-(void)loadUI{
    //备注标题部分
    UIView *for_title_view=[[UIView alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH-20, 60)];
    for_title_view.backgroundColor=[UIColor whiteColor];
    for_title_view.layer.cornerRadius=12;
    
    self.float_Textfield=[[JVFloatLabeledTextView alloc] initWithFrame:CGRectMake(20, 5, for_title_view.frame.size.width-40, 50)];
    self.float_Textfield.floatingLabelFont=[UIFont systemFontOfSize:10.0];
    self.float_Textfield.floatingLabelTextColor=BACKGROUND_COLOR;
    
    [self.float_Textfield setPlaceholder:@"请输入备注标题" floatingTitle:@"标题"];
    
    
    [for_title_view addSubview:self.float_Textfield];
    [self.view addSubview:for_title_view];
    
    //备注内容部分
    UIView *for_content_view=[[UIView alloc] initWithFrame:CGRectMake(10, 176, SCREEN_WIDTH-20, SCREEN_HEIGHT-300)];
    for_content_view.backgroundColor=[UIColor whiteColor];
    for_content_view.layer.cornerRadius=12;
    
    self.float_TextField_content=[[JVFloatLabeledTextView alloc] initWithFrame:CGRectMake(20, 5, for_title_view.frame.size.width-40, SCREEN_HEIGHT-310)];
    self.float_TextField_content.floatingLabelFont=[UIFont systemFontOfSize:10.0];
    self.float_TextField_content.floatingLabelTextColor=BACKGROUND_COLOR;
    
    [self.float_TextField_content setPlaceholder:@"请输入备注内容" floatingTitle:@"内容"];
    
    [for_content_view addSubview:self.float_TextField_content];
    [self.view addSubview:for_content_view];
    
    //在备注心情之前首先把要做动画的三个按钮，液体粘连动画需要用到贝塞尔曲线变化知识，后期再来完善这个动画功能。2.或者完整搞一下oc与swift混编下的LiquidFloatingActionButton
    [self.view addSubview:self.normal_button];
    [self.view addSubview:self.sad_button];
    [self.view addSubview:self.smile_button];
    //为三个个按钮添加RAC点击事件,收回所有的卫星按钮，并且将按钮上面的图片内容改变
    [[self.normal_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.heart_imageView.image=[UIImage imageNamed:@"heart_normal_image"];
        self.heart_string=@"一般";
        //收回所有的卫星
        self.normal_button.center=CGPointMake(self.normal_button.center.x, self.normal_button.center.y+58);
        self.sad_button.center=CGPointMake(self.sad_button.center.x, self.sad_button.center.y+58*2);
        self.smile_button.center=CGPointMake(self.smile_button.center.x, self.smile_button.center.y+58*3);
        //改变bool值
        self.isSelect=NO;
    }];
    [[self.sad_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.heart_imageView.image=[UIImage imageNamed:@"heart_sad_image"];
        self.heart_string=@"不开心";
        //收回所有的卫星
        self.normal_button.center=CGPointMake(self.normal_button.center.x, self.normal_button.center.y+58);
        self.sad_button.center=CGPointMake(self.sad_button.center.x, self.sad_button.center.y+58*2);
        self.smile_button.center=CGPointMake(self.smile_button.center.x, self.smile_button.center.y+58*3);
        self.isSelect=NO;
    }];
    [[self.smile_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.heart_imageView.image=[UIImage imageNamed:@"heart_smile_image"];
        self.heart_string=@"开心";
        //收回所有的卫星
        self.normal_button.center=CGPointMake(self.normal_button.center.x, self.normal_button.center.y+58);
        self.sad_button.center=CGPointMake(self.sad_button.center.x, self.sad_button.center.y+58*2);
        self.smile_button.center=CGPointMake(self.smile_button.center.x, self.smile_button.center.y+58*3);
        self.isSelect=NO;
    }];
    
    //备注心情部分
    [self.view addSubview:self.heart_select_button];
    //给按钮添加RAC监听
    [[self.heart_select_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //像卫星式菜单动画弹出三项内容(这里是不做缩小动画的)
        //将bool值置为true
        if(!self.isSelect){
            self.isSelect=YES;
            //normal
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.normal_button.center=CGPointMake(self.normal_button.center.x, self.normal_button.center.y-58);
            } completion:^(BOOL finished) {
                
            }];
            //不开心
            [UIView animateWithDuration:0.5 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.sad_button.center=CGPointMake(self.sad_button.center.x, self.sad_button.center.y-58*2);
            } completion:^(BOOL finished) {
                
            }];
            //开心
            [UIView animateWithDuration:0.5 delay:0.6 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.smile_button.center=CGPointMake(self.smile_button.center.x, self.smile_button.center.y-58*3);
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    
    //备注日期部分
    //拿到当前时间
    NSDate *localDate=[NSDate localdate];
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];//获得当前日期，日期格式为年-月-日-周
    NSString *dateString=[dateFormatter stringFromDate:localDate];
    self.date_label.text=[dateString remarkDateFrom:dateString];
    self.remark_dateString=self.date_label.text;
    
    [self.view addSubview:self.date_label];
}

-(void)loadNav{
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
    
    UILabel *title_label=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 35, 150, 20)];
    title_label.text=@"新建一个备注";
    title_label.textColor=BACKGROUND_COLOR;
    title_label.textAlignment=NSTextAlignmentCenter;
    title_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    
    
    TapMusicButton *right_add_button=[[TapMusicButton alloc] init];
    right_add_button.frame=CGRectMake(SCREEN_WIDTH-80, 22, 70, 41);
    right_add_button.backgroundColor=[UIColor clearColor];
    [right_add_button setImage:[UIImage imageNamed:@"complete_edit_image"] forState:UIControlStateNormal];
    [[right_add_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"右上角的我被惦记了");
        //获得所有需要的界面内容
        //在这里存储构造数据并存储数据,并设置代理更新tableView更新值
        [RemarkModel shareAddMode].remark_id=[[RemarkModel shareAddMode] countForData]+1;
        [RemarkModel shareAddMode].remark_title=self.float_Textfield.text;
        [RemarkModel shareAddMode].remark_content=self.float_TextField_content.text;
        [RemarkModel shareAddMode].remark_date=self.remark_dateString;
        [RemarkModel shareAddMode].remark_heart=self.heart_string;
     
        [[RemarkModel shareAddMode] insertData];
        
        //通知代理已经完成数据存储可以刷新数据了
        [self.delegate refresh];

        [self dismissViewControllerAnimated:true completion:^{
            
        }];
    }];
    
    [nav_view addSubview:right_add_button];
    [nav_view addSubview:title_label];
    [nav_view addSubview:left_back_button];
    [self.view addSubview:nav_view];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
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
