//
//  SubjectCountView.m
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubjectCountView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import "UILabel+SizeToFit.h"
#import "DayView.h"

@interface SubjectCountView ()
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIView *bodyView;

@property(nonatomic,strong)UIView *repeatView;
@property(nonatomic,strong)UILabel *repeatDiscription;
@property(nonatomic,assign)CGSize label_size;

@property(nonatomic,strong)UIView *goalView;
@property(nonatomic,assign)CGSize label_size_2;

@property(nonatomic,strong)UIView *subject_isOn_view;
@property(nonatomic,strong)UILabel *subject_isOn_label;

@property(nonatomic,strong)UILabel *reward_discription;


@end

@implementation SubjectCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.headView];
        [self.backView addSubview:self.footerView];
        [self.backView addSubview:self.bodyView];
    }
    return self;
}

#pragma mark 配置背景View和底图View

-(UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35)];
        _backView.backgroundColor=[UIColor whiteColor];
        _backView.layer.cornerRadius=12;
    }
    return _backView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35-25)];
        _headView.backgroundColor=PURPLE_COLOR;
        _headView.layer.cornerRadius=12;
        [_headView addSubview:self.titleImageView];
        [_headView addSubview:self.titleLabel];
    }
    return _headView;
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.35*0.5, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35*0.5)];
        _footerView.backgroundColor=[UIColor whiteColor];
        _footerView.layer.cornerRadius=12;
    }
    return _footerView;
}

-(UIView *)bodyView{
    if (!_bodyView) {
        _bodyView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.35*0.35-25, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.35*0.6)];
        _bodyView.backgroundColor=[UIColor whiteColor];
        [_bodyView addSubview:self.repeatView];
        [_bodyView addSubview:self.goalView];
        //加一个横线更美观
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(10, 75, SCREEN_WIDTH-40, 2)];
        line.backgroundColor=PICKER_BACKGROUND;
        [_bodyView addSubview:line];
        
        [_bodyView addSubview:self.subject_isOn_view];
        [_bodyView addSubview:self.subject_isOn_switch];
        
        [_bodyView addSubview:self.reward_discription];
        [_bodyView addSubview:self.reward_label];
        [_bodyView addSubview:self.reward_imageView];
    }
    return _bodyView;
}

#pragma mark 标题部分
-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        _titleImageView.image=[UIImage imageNamed:@"lose-weight_image"];
    }
    return _titleImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, (SCREEN_HEIGHT*0.35*0.35-25-40)/2, SCREEN_WIDTH-90, 40)];
        _titleLabel.text=@"在一个月里减10斤";
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.font=[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _titleLabel;
}
#pragma mark 已经坚持天数的封装
-(UIView *)repeatView{
    if (!_repeatView) {
        _repeatView=[[UIView alloc] initWithFrame:CGRectMake(10, 15, 100, 70)];
        _repeatView.backgroundColor=[UIColor whiteColor];
        [_repeatView addSubview:self.repeatDiscription];
        [_repeatView addSubview:self.repeatDay_label];
        
        [_repeatView addSubview:self.dayView];
    }
    return _repeatView;
}

-(DayView *)dayView{
    if (!_dayView) {
        _dayView=[[DayView alloc] initWithFrame:CGRectMake(self.repeatDay_label.frame.size.width+5, (50-18)/2+9, 40, 18)];
        if ([self.repeatDay_label.text isEqualToString:@"0"]) {
            _dayView.day_label.text=@"Day";
        }else{
            _dayView.day_label.text=@"Days";
        }
    }
    return _dayView;
}

-(UILabel *)repeatDiscription{
    if (!_repeatDiscription) {
        _repeatDiscription=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        _repeatDiscription.text=@"已经坚持天数";
        _repeatDiscription.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        _repeatDiscription.textColor=[UIColor grayColor];
        _repeatDiscription.textAlignment=NSTextAlignmentLeft;
    }
    return _repeatDiscription;
}
-(UILabel*)repeatDay_label{
    if (!_repeatDay_label) {
        _repeatDay_label=[[UILabel alloc] init];
        _repeatDay_label.text=@"2999";
        _repeatDay_label.font=[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
        _repeatDay_label.textColor=[UIColor darkGrayColor];
        _repeatDay_label.textAlignment=NSTextAlignmentCenter;
        
        //下面是设置尺寸随内容的变化而变化
        _repeatDay_label.numberOfLines = 0; // 需要把显示行数设置成无限制
        self.label_size=[_repeatDay_label sizeWithSt:_repeatDay_label.text font:_repeatDay_label.font];
        _repeatDay_label.frame = CGRectMake(0, 20, self.label_size.width, self.label_size.height);
    }
    return _repeatDay_label;
}

#pragma mark 保留控件，是否添加连续天数
//

#pragma mark 坚持目标的封装
-(UIView *)goalView{
    if (!_goalView) {
        _goalView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 15, 100, 70)];
        _goalView.backgroundColor=[UIColor whiteColor];
        [_goalView addSubview:self.goalDiscription];
        [_goalView addSubview:self.goalDay_label];
        
        [_goalView addSubview:self.dayView_goal];
    }
    return _goalView;
}

-(DayView *)dayView_goal{
    if (!_dayView_goal) {
        _dayView_goal=[[DayView alloc] initWithFrame:CGRectMake(self.goalDay_label.frame.size.width+5, (50-18)/2+9, 40, 18)];
        if ([self.goalDay_label.text isEqualToString:@"0"]) {
            _dayView_goal.day_label.text=@"Day";
        }else{
            _dayView_goal.day_label.text=@"Days";
        }
    }
    return _dayView_goal;
}

-(UILabel *)goalDiscription{
    if (!_goalDiscription) {
        _goalDiscription=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 15)];
        //需要判断一下显示
        //1.距离习惯养成还有？天
        //2.坚持目标
        _goalDiscription.text=[NSString stringWithFormat:@"距200天目标还有"];
        _goalDiscription.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        _goalDiscription.textColor=[UIColor grayColor];
        _goalDiscription.textAlignment=NSTextAlignmentLeft;
    }
    return _goalDiscription;
}
-(UILabel*)goalDay_label{
    if (!_goalDay_label) {
        _goalDay_label=[[UILabel alloc] init];
        _goalDay_label.text=@"2999";
        _goalDay_label.font=[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
        _goalDay_label.textColor=[UIColor darkGrayColor];
        _goalDay_label.textAlignment=NSTextAlignmentCenter;
        
        //下面是设置尺寸随内容的变化而变化
        _goalDay_label.numberOfLines = 0; // 需要把显示行数设置成无限制
        self.label_size_2=[_goalDay_label sizeWithSt:_goalDay_label.text font:_goalDay_label.font];
        _goalDay_label.frame = CGRectMake(0, 20, self.label_size_2.width, self.label_size_2.height);
    }
    return _goalDay_label;
}

#pragma mark 项目正在进行中label
-(UIView *)subject_isOn_view{
    if (!_subject_isOn_view) {
        _subject_isOn_view=[[UIView alloc] initWithFrame:CGRectMake(10, 90, 150, 58)];
        _subject_isOn_view.backgroundColor=[UIColor whiteColor];
        [_subject_isOn_view addSubview:self.subject_isOn_label];
        [_subject_isOn_view addSubview:self.subject_start_time];
    }
    return _subject_isOn_view;
}

-(UILabel *)subject_isOn_label{
    if (!_subject_isOn_label) {
        _subject_isOn_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 16)];
        //根据switch判断然后改变这里的值
        _subject_isOn_label.text=@"项目进行中";
        _subject_isOn_label.textColor=[UIColor darkGrayColor];
        _subject_isOn_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        _subject_isOn_label.textAlignment=NSTextAlignmentLeft;
    }
    return _subject_isOn_label;
}

-(UILabel *)subject_start_time{
    if (!_subject_start_time) {
        _subject_start_time=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 16)];

        _subject_start_time.textColor=[UIColor grayColor];
        _subject_start_time.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightThin];
        _subject_start_time.textAlignment=NSTextAlignmentLeft;
    }
    return _subject_start_time;
}

#pragma mark --项目开关
-(UISwitch*)subject_isOn_switch{
    if (!_subject_isOn_switch) {
        _subject_isOn_switch=[[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 95, 20, 20)];
        _subject_isOn_switch.on=false;
    }
    return _subject_isOn_switch;
}

#pragma mark --奖励
-(UILabel *)reward_discription{
    if (!_reward_discription) {
        _reward_discription=[[UILabel alloc] initWithFrame:CGRectMake(10, 150, 150, 16)];
        _reward_discription.text=@"目标完成奖励:";
        _reward_discription.textColor=[UIColor grayColor];
        _reward_discription.textAlignment=NSTextAlignmentLeft;
        _reward_discription.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    return _reward_discription;
}
-(UILabel *)reward_label{
    if (!_reward_label) {
        _reward_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-280, 150, 150, 16)];
        _reward_label.text=@"一台新的iPad！";
        _reward_label.textColor=[UIColor darkGrayColor];
        _reward_label.textAlignment=NSTextAlignmentLeft;
        _reward_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    return _reward_label;
}
-(UIImageView *)reward_imageView{
    if (!_reward_imageView) {
        _reward_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 144, 30, 30)];
        _reward_imageView.image=[UIImage imageNamed:@"ipad_image"];
        _reward_imageView.adjustsImageSizeForAccessibilityContentSizeCategory=YES;
        [self shake];
    }
    return _reward_imageView;
}

//摇晃动画
-(void)shake{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.reward_imageView.transform=CGAffineTransformRotate(self.reward_imageView.transform, M_PI_2*0.2);
        self.reward_imageView.transform=CGAffineTransformRotate(self.reward_imageView.transform, -(M_PI_2*0.4));
        self.reward_imageView.transform=CGAffineTransformRotate(self.reward_imageView.transform, M_PI_2*0.4);
        self.reward_imageView.transform=CGAffineTransformRotate(self.reward_imageView.transform, -M_PI_2*0.2);
    } completion:^(BOOL finished) {
        [self shake];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
