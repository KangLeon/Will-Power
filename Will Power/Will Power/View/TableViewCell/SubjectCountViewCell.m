//
//  SubjectCountViewCell.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/5/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubjectCountViewCell.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import "UILabel+SizeToFit.h"
#import "DayView.h"
#import "GetColor.h"
#import <Lottie/Lottie.h>
#import <Masonry.h>

@interface SubjectCountViewCell ()
@property(nonatomic,strong)UIView *backView;

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

@property(nonatomic,strong)LOTAnimationView *animation;

@end

@implementation SubjectCountViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加视图
        [self addSubview:self.backView];
        [self.backView addSubview:self.headView];
        [self.backView addSubview:self.footerView];
        [self.backView addSubview:self.bodyView];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}

#pragma mark 配置背景View和底图View

-(UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-SCREEN_WIDTH*0.0484, SCREEN_HEIGHT*0.35)];
        _backView.backgroundColor=[UIColor whiteColor];
        _backView.layer.cornerRadius=12;
    }
    return _backView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-SCREEN_WIDTH*0.0484, SCREEN_HEIGHT*0.35-SCREEN_HEIGHT*0.03396)];
        _headView.backgroundColor=PURPLE_COLOR;
        _headView.layer.cornerRadius=12;
        [_headView addSubview:self.titleImageView];
        [_headView addSubview:self.titleLabel];
    }
    return _headView;
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.35*0.5, SCREEN_WIDTH-SCREEN_WIDTH*0.0484, SCREEN_HEIGHT*0.35*0.5)];
        _footerView.backgroundColor=[UIColor whiteColor];
        _footerView.layer.cornerRadius=12;
    }
    return _footerView;
}

-(UIView *)bodyView{
    if (!_bodyView) {
        _bodyView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.35*0.35-SCREEN_HEIGHT*0.03396, SCREEN_WIDTH-SCREEN_WIDTH*0.0484, SCREEN_HEIGHT*0.35*0.6)];
        _bodyView.backgroundColor=[UIColor whiteColor];
        [_bodyView addSubview:self.repeatView];
        [_bodyView addSubview:self.goalView];
        //加一个横线更美观
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.024154, SCREEN_HEIGHT*0.101902, SCREEN_WIDTH-SCREEN_WIDTH*0.096618, 2)];
        line.backgroundColor=PICKER_BACKGROUND;
        [_bodyView addSubview:line];
        
        [_bodyView addSubview:self.subject_isOn_view];
        [_bodyView addSubview:self.subject_isOn_switch];
        
        [_bodyView addSubview:self.reward_discription];
        [_bodyView addSubview:self.reward_label];
        
        [_bodyView addSubview:self.animation];
    }
    return _bodyView;
}

#pragma mark 标题部分
-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT*0.024154, SCREEN_HEIGHT*0.0067934, SCREEN_WIDTH*0.1207077294, SCREEN_WIDTH*0.1207077294)];
        _titleImageView.image=[UIImage imageNamed:@"lose-weight_image"];//默认是加载这张图片，如果用户忘记选择
    }
    return _titleImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.21739, SCREEN_HEIGHT*0.0135869, SCREEN_WIDTH-SCREEN_WIDTH*0.21739, SCREEN_HEIGHT*0.05434)];
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
        _repeatView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.024154, SCREEN_HEIGHT*0.02038, SCREEN_WIDTH*0.24154, SCREEN_HEIGHT*0.095108)];
        _repeatView.backgroundColor=[UIColor whiteColor];
        [_repeatView addSubview:self.repeatDiscription];
        [_repeatView addSubview:self.repeatDay_label];
        
        [_repeatView addSubview:self.dayView_repeat];
    }
    return _repeatView;
}
-(DayView*)dayView_repeat{
    if (!_dayView_repeat) {
        _dayView_repeat=[[DayView alloc] initWithFrame:CGRectMake(self.repeatDay_label.frame.size.width+SCREEN_WIDTH*0.012077, SCREEN_HEIGHT*0.03396, SCREEN_WIDTH*0.096618, SCREEN_HEIGHT*0.02445)];
        //这个判断逻辑希望在代码执行的时候还可以监听到，目前用的方法是通知，-------------？可以使用其他方法吗？RAC？
                if ([self.repeatDay_label.text isEqualToString:@"0"]) {
                    _dayView_repeat.day_label.text=@"Day";
                }else{
                    _dayView_repeat.day_label.text=@"Days";
                }
    }
    return _dayView_repeat;
}

-(UILabel *)repeatDiscription{
    if (!_repeatDiscription) {
        _repeatDiscription=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.241545, SCREEN_HEIGHT*0.02038)];
        _repeatDiscription.text=@"已经坚持天数";
        _repeatDiscription.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        _repeatDiscription.textColor=[UIColor grayColor];
        _repeatDiscription.textAlignment=NSTextAlignmentLeft;
        _repeatDiscription.adjustsFontSizeToFitWidth=YES;
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
        _repeatDay_label.frame = CGRectMake(0, SCREEN_HEIGHT*0.0271739, self.label_size.width, self.label_size.height);
    }
    return _repeatDay_label;
}

#pragma mark 保留控件，是否添加连续天数
//

#pragma mark 坚持目标的封装
-(UIView *)goalView{
    if (!_goalView) {
        _goalView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.3864*1.2, SCREEN_HEIGHT*0.0203804, SCREEN_WIDTH*0.362318, SCREEN_HEIGHT*0.09510)];
        _goalView.backgroundColor=[UIColor whiteColor];
        [_goalView addSubview:self.goalDiscription];//添加描述
        [_goalView addSubview:self.goalDay_label];//添加Day小Label
        
        [_goalView addSubview:self.dayView_goal];
    }
    return _goalView;
}

-(DayView*)dayView_goal{
    if (!_dayView_goal) {
        _dayView_goal=[[DayView alloc] initWithFrame:CGRectMake(self.goalDay_label.frame.size.width+SCREEN_WIDTH*0.012077, SCREEN_HEIGHT*0.03396, SCREEN_WIDTH*0.0966183, SCREEN_HEIGHT*0.024456)];
        //这个判断逻辑希望在代码执行的时候还可以监听到，目前用的方法是通知，-------------？可以使用其他方法吗？RAC？
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
        _goalDiscription=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.3623188, SCREEN_HEIGHT*0.0203)];
        //需要判断一下显示
        //1.距离习惯养成还有？天
        //2.坚持目标
        _goalDiscription.text=[NSString stringWithFormat:@"距200天目标还有"];
        _goalDiscription.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        _goalDiscription.textColor=[UIColor grayColor];
        _goalDiscription.textAlignment=NSTextAlignmentLeft;
        _goalDiscription.adjustsFontSizeToFitWidth=YES;
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
        _goalDay_label.frame = CGRectMake(0, SCREEN_HEIGHT*0.027173, self.label_size_2.width, self.label_size_2.height);
    }
    return _goalDay_label;
}

#pragma mark 项目正在进行中label
-(UIView *)subject_isOn_view{
    if (!_subject_isOn_view) {
        _subject_isOn_view=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.024154, SCREEN_HEIGHT*0.12282, SCREEN_WIDTH*0.36231884, SCREEN_HEIGHT*0.078804)];
        _subject_isOn_view.backgroundColor=[UIColor whiteColor];
        [_subject_isOn_view addSubview:self.subject_isOn_label];
        [_subject_isOn_view addSubview:self.subject_start_time];
    }
    return _subject_isOn_view;
}

-(UILabel *)subject_isOn_label{
    if (!_subject_isOn_label) {
        _subject_isOn_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.36231884, SCREEN_HEIGHT*0.02173)];
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
        _subject_start_time=[[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.027173, SCREEN_WIDTH*0.36231, SCREEN_HEIGHT*0.02173)];
        _subject_start_time.textColor=[UIColor grayColor];
        _subject_start_time.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightThin];
        _subject_start_time.textAlignment=NSTextAlignmentLeft;
    }
    return _subject_start_time;
}

#pragma mark --项目开关
-(UISwitch*)subject_isOn_switch{
    if (!_subject_isOn_switch) {
        _subject_isOn_switch=[[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.2173913*1.1, SCREEN_HEIGHT*0.12907, SCREEN_WIDTH*0.0483, SCREEN_HEIGHT*0.02717)];
        _subject_isOn_switch.on=false;
    }
    return _subject_isOn_switch;
}

#pragma mark --奖励
-(UILabel *)reward_discription{
    if (!_reward_discription) {
        _reward_discription=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.024154, SCREEN_HEIGHT*0.203804, SCREEN_WIDTH*0.3623188, SCREEN_HEIGHT*0.021739)];
        _reward_discription.text=@"目标完成奖励:";
        _reward_discription.textColor=[UIColor grayColor];
        _reward_discription.textAlignment=NSTextAlignmentLeft;
        _reward_discription.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    return _reward_discription;
}
-(UILabel *)reward_label{
    if (!_reward_label) {
        _reward_label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.4347826, SCREEN_HEIGHT*0.203804, SCREEN_WIDTH*0.3623188, SCREEN_HEIGHT*0.021739)];
        _reward_label.text=@"一台新的iPad！";
        _reward_label.textColor=[UIColor darkGrayColor];
        _reward_label.textAlignment=NSTextAlignmentLeft;
        _reward_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    return _reward_label;
}

-(LOTAnimationView *)animation{
    if (!_animation) {
        _animation=[LOTAnimationView animationNamed:@"newAnimation"];
        _animation.frame=CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.21739, SCREEN_HEIGHT*0.18206, SCREEN_WIDTH*0.12077, SCREEN_WIDTH*0.12077);
        _animation.loopAnimation=true;
        _animation.animationSpeed=1.0;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}


//#pragma mark --Masonry布局约束相关
-(void)updateConstraints{
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    //1.提醒时间的布局约束
    //2.都是相对于
//    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.backView.mas_left);
//        make.top.equalTo(weakSelf.backView.mas_top);
//        make.right.equalTo(weakSelf.backView.mas_right);
//        make.bottom.equalTo(weakSelf.backView.mas_bottom).offset(-SCREEN_HEIGHT*0.03396);
//    }];
//    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.backView.mas_left).offset(10);
//        make.top.equalTo(weakSelf.backView.mas_top).offset(5);
//        make.width.equalTo(@(SCREEN_WIDTH*0.1207));
//        make.height.equalTo(@(SCREEN_WIDTH*0.1207));
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.titleImageView.mas_right).offset(30);
//        make.top.equalTo(weakSelf.backView.mas_top).offset((SCREEN_HEIGHT*0.35*0.35-SCREEN_HEIGHT*0.03396-40)/2);
//        make.width.equalTo(@(SCREEN_WIDTH-90));
//        make.height.equalTo(@(40));
//    }];
//    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.backView.mas_left);
//        make.top.equalTo(weakSelf.backView.mas_top).offset(SCREEN_HEIGHT*0.35*0.5);
//        make.right.equalTo(weakSelf.backView.mas_right);
//        make.bottom.equalTo(weakSelf.backView.mas_bottom);
//    }];
//    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.backView.mas_left);
//        make.top.equalTo(weakSelf.titleImageView.mas_bottom).offset(5+10+SCREEN_WIDTH*0.1207);
//        make.right.equalTo(weakSelf.backView.mas_right);
//        make.bottom.equalTo(weakSelf.backView.mas_bottom).offset(15);
//    }];
//    [self.repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bodyView.mas_left).offset(10);
//        make.top.equalTo(weakSelf.bodyView.mas_top).offset(15+5+10+SCREEN_WIDTH*0.1207);
//        make.width.equalTo(@(SCREEN_WIDTH*0.2415));
//        make.height.equalTo(@(SCREEN_HEIGHT*0.0951));
//    }];
//    [self.goalView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bodyView.mas_left).offset(SCREEN_WIDTH-SCREEN_WIDTH*0.3864);
//        make.top.equalTo(weakSelf.bodyView.mas_top).offset(15+5+10+SCREEN_WIDTH*0.1207);
//        make.width.equalTo(@(SCREEN_WIDTH*0.2415));
//        make.height.equalTo(@(SCREEN_HEIGHT*0.0951));
//    }];
//    [self.subject_isOn_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bodyView.mas_left).offset(10);
//        make.top.equalTo(weakSelf.repeatView.mas_bottom).offset(21);
//    }];
//    [self.subject_isOn_switch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bodyView.mas_right).offset(-90);
//        make.top.equalTo(weakSelf.repeatView.mas_bottom).offset(15);
//    }];
//    [self.reward_discription mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bodyView.mas_left).offset(10);
//        make.top.equalTo(weakSelf.subject_isOn_view.mas_bottom).offset(5);
//    }];
//    [self.reward_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.reward_discription.mas_right).offset(15);
//        make.top.equalTo(weakSelf.subject_isOn_view.mas_bottom).offset(5);
//    }];
//    [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bodyView.mas_right).offset(-90);
//        make.top.equalTo(weakSelf.subject_isOn_switch.mas_bottom).offset(15);
//    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
