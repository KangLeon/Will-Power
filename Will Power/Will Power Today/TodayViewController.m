//
//  TodayViewController.m
//  Will Power Today
//
//  Created by 吉腾蛟 on 2018/8/7.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "SizeDefine.h"
#import "ColorDefine.h"
#import "GetColor.h"

@interface TodayViewController () <NCWidgetProviding>{
     CAShapeLayer *layer_first;
     CAShapeLayer *layer_second;
     CAShapeLayer *layer_third;
}

@property (weak, nonatomic) IBOutlet UIButton *button_first;
@property (weak, nonatomic) IBOutlet UIButton *button_second;
@property (weak, nonatomic) IBOutlet UIButton *button_third;

@property(nonatomic,strong)UIImageView *imageView_first;
@property(nonatomic,strong)UIImageView *imageView_second;
@property(nonatomic,strong)UIImageView *imageView_third;

@property(nonatomic,strong)UILabel *title_first;
@property(nonatomic,strong)UILabel *title_second;
@property(nonatomic,strong)UILabel *title_third;

//任务完成状态的部分
//1.背景view
@property(nonatomic,strong)UIView *backView_first;
@property(nonatomic,strong)UIView *backView_second;
@property(nonatomic,strong)UIView *backView_third;
//2.内心圆部分


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    self.preferredContentSize=CGSizeMake(SCREEN_WIDTH-14, 100);
}

#pragma mark UI初始化

-(void)loadUI{
//    [self.button_first removeFromSuperview];
//    [self.button_second removeFromSuperview];
//    [self.button_third removeFromSuperview];
    //读取数据
    NSArray *subject_array=[self readDataFromNSUserDefaults];
    
    for (int i=1; i<subject_array.count+1; i++) {
        if (i==1) {
            NSDictionary *dic=subject_array[0];
            NSString *subject_title=[dic objectForKey:@"subject_title"];
            NSString *back_image=[dic objectForKey:@"back_image"];
            NSString *back_color=[dic objectForKey:@"back_color"];
            BOOL isFinish=[dic objectForKey:@"isFinish"];
            BOOL isEnd=[dic objectForKey:@"isEnd"];
            
            self.button_first.backgroundColor=[[GetColor shareGetColor] getMyColorWith:back_color];
            self.title_first.text=subject_title;
            self.imageView_first.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-%@",back_image,back_image]];
            self.backView_first.backgroundColor=[UIColor whiteColor];
            if (isFinish) {
                [self loadCheck:self.backView_first layer:layer_first];
            }else{
                [self removeCheck:layer_first];
            }
            
            if (isEnd) {
                [self removeCheck:layer_first];
                self.button_first.enabled=false;
            }
            
        }else if (i==2){
            NSDictionary *dic=subject_array[1];
            NSString *subject_title=[dic objectForKey:@"subject_title"];
            NSString *back_image=[dic objectForKey:@"back_image"];
            NSString *back_color=[dic objectForKey:@"back_color"];
            BOOL isFinish=[dic objectForKey:@"isFinish"];
            BOOL isEnd=[dic objectForKey:@"isEnd"];
            
            self.button_second.backgroundColor=[[GetColor shareGetColor] getMyColorWith:back_color];
            self.title_second.text=subject_title;
            self.imageView_second.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-%@",back_image,back_image]];
            self.backView_second.backgroundColor=[UIColor whiteColor];
            
            if (isFinish) {
                [self loadCheck:self.backView_second layer:layer_second];
            }else{
                [self removeCheck:layer_second];
            }
            
            if (isEnd) {
                [self removeCheck:layer_second];
                self.button_second.enabled=false;
            }
        }else if (i==3){
            NSDictionary *dic=subject_array[2];
            NSString *subject_title=[dic objectForKey:@"subject_title"];
            NSString *back_image=[dic objectForKey:@"back_image"];
            NSString *back_color=[dic objectForKey:@"back_color"];
            BOOL isFinish=[dic objectForKey:@"isFinish"];
            BOOL isEnd=[dic objectForKey:@"isEnd"];
            
            self.button_third.backgroundColor=[[GetColor shareGetColor] getMyColorWith:back_color];
            self.title_third.text=subject_title;
            self.imageView_third.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-%@",back_image,back_image]];
            self.backView_third.backgroundColor=[UIColor whiteColor];
            
            if (isFinish) {
                [self loadCheck:self.backView_third layer:layer_third];
            }else{
                [self removeCheck:layer_third];
            }
            
            if (isEnd) {
                [self removeCheck:layer_third];
                self.button_third.enabled=false;
            }
        }
    }
    
    //判断任务有几个然后添加UI
    self.button_first.frame=CGRectMake(8, 8, (SCREEN_WIDTH-14-8*4)/3, 100);
    self.button_second.frame=CGRectMake(8+(SCREEN_WIDTH-14-8*4)/3+8, 8, (SCREEN_WIDTH-14-8*4)/3, 100);
    self.button_third.frame=CGRectMake(8+((SCREEN_WIDTH-14-8*4)/3+8)*2, 8, (SCREEN_WIDTH-14-8*4)/3, 100);
    
    self.button_first.layer.cornerRadius=12.0;
    self.button_second.layer.cornerRadius=12.0;
    self.button_third.layer.cornerRadius=12.0;
    
    [self.button_first addSubview:self.imageView_first];
    [self.button_second addSubview:self.imageView_second];
    [self.button_third addSubview:self.imageView_third];
    
    [self.button_first addSubview:self.title_first];
    [self.button_second addSubview:self.title_second];
    [self.button_third addSubview:self.title_third];
    
    [self.button_first addSubview:self.backView_first];
    [self.button_second addSubview:self.backView_second];
    [self.button_third addSubview:self.backView_third];
    
//    [self loadCheck:self.backView_first layer:layer_first];
//    [self loadCheck:self.backView_second layer:layer_second];
//    [self loadCheck:self.backView_third layer:layer_third];
    
    
}

#pragma mark 懒加载部分
//imageView
-(UIImageView*)imageView_first{
    if (!_imageView_first) {
        _imageView_first=[[UIImageView alloc] initWithFrame:CGRectMake(5, 45, 40, 40)];
        _imageView_first.image=[UIImage imageNamed:@"1-1"];
    }
    return _imageView_first;
}
-(UIImageView*)imageView_second{
    if (!_imageView_second) {
        _imageView_second=[[UIImageView alloc] initWithFrame:CGRectMake(5, 45, 40, 40)];
        _imageView_second.image=[UIImage imageNamed:@"1-1"];
    }
    return _imageView_second;
}
-(UIImageView*)imageView_third{
    if (!_imageView_third) {
        _imageView_third=[[UIImageView alloc] initWithFrame:CGRectMake(5, 45, 40, 40)];
        _imageView_third.image=[UIImage imageNamed:@"1-1"];
    }
    return _imageView_third;
}
//label
-(UILabel*)title_first{
    if (!_title_first) {
        _title_first=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, (SCREEN_WIDTH-14-8*4)/3-20, 20)];
        _title_first.textColor=[UIColor whiteColor];
        _title_first.font=[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _title_first.textAlignment=NSTextAlignmentLeft;
        _title_first.text=@"你好";
        _title_first.adjustsFontSizeToFitWidth=YES;
    }
    return _title_first;
}
-(UILabel*)title_second{
    if (!_title_second) {
        _title_second=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, (SCREEN_WIDTH-14-8*4)/3-20, 20)];
        _title_second.textColor=[UIColor whiteColor];
        _title_second.font=[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _title_second.textAlignment=NSTextAlignmentLeft;
        _title_second.text=@"你好";
        _title_first.adjustsFontSizeToFitWidth=YES;
    }
    return _title_second;
}
-(UILabel*)title_third{
    if (!_title_third) {
        _title_third=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, (SCREEN_WIDTH-14-8*4)/3-20, 20)];
        _title_third.textColor=[UIColor whiteColor];
        _title_third.font=[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _title_third.textAlignment=NSTextAlignmentLeft;
        _title_third.text=@"你好";
        _title_first.adjustsFontSizeToFitWidth=YES;
    }
    return _title_third;
}

//backView
-(UIView*)backView_first{
    if (!_backView_first) {
        _backView_first=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-14-8*4)/3-40, 50, 30, 30)];
        _backView_first.backgroundColor=[UIColor whiteColor];
        _backView_first.layer.cornerRadius=8.0;
    }
    return _backView_first;
}
-(UIView*)backView_second{
    if (!_backView_second) {
        _backView_second=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-14-8*4)/3-40, 50, 30, 30)];
        _backView_second.backgroundColor=[UIColor whiteColor];
        _backView_second.layer.cornerRadius=8.0;
    }
    return _backView_second;
}
-(UIView*)backView_third{
    if (!_backView_third) {
        _backView_third=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-14-8*4)/3-40, 50, 30, 30)];
        _backView_third.backgroundColor=[UIColor whiteColor];
        _backView_third.layer.cornerRadius=8.0;
    }
    return _backView_third;
}

-(void)removeCheck:(CAShapeLayer*)layer{
    [layer removeFromSuperlayer];
}

//点击事件并存数据
- (IBAction)loadFirstMission:(id)sender {
}

- (IBAction)loadSecondMission:(id)sender {
}

- (IBAction)loadThirdMission:(id)sender {
}

#pragma mark 功能函数

//保存数据
- (void)saveDataByNSUserDefaults{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.WillPower"];
    [shared setObject:@"asdfasdf" forKey:@"allSubject"];
    [shared synchronize];
}
//读取数据
- (NSArray *)readDataFromNSUserDefaults{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.WillPower"];
    NSArray *allArray = [shared objectForKey:@"allSubject"];
    return allArray;
}

//打对勾动画
-(void)loadCheck:(UIView*)view layer:(CAShapeLayer*)layer{
    CGPoint pathCenter = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 - 50);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter radius:0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    
    CGFloat x = view.frame.size.width*0.2;
    CGFloat y = view.frame.size.height*0.6;
    //勾的起点
    [path moveToPoint:CGPointMake(x, y)];
    //勾的最底端
    CGPoint p1 = CGPointMake(x+10, y+8);
    [path addLineToPoint:p1];
    //勾的最上端
    CGPoint p2 = CGPointMake(x+20,y-14);
    [path addLineToPoint:p2];
    //新建图层——绘制上面的圆圈和勾
    layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 3;
    layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.2;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [view.layer addSublayer:layer];
}

// //抖动并且播放音乐
//-(void)shakeAndSound:(id)sender{
//    //播放音乐
//    [[TapMusic shareTapMusic] playSoundEffect];
//    //抖动效果
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
