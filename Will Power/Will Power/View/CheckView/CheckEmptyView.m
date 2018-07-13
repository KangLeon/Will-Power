//
//  CheckEmptyView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CheckEmptyView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <Masonry.h>
#import "CheckMusic.h"


@implementation CheckEmptyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.check_button];
        [self addSubview:self.check_title];
        [self addSubview:self.animation_view];
        [self addSubview:self.check_description];
        [self addSubview:self.subject_backview];
        [self updateConstraintsIfNeeded];
    }
    return self;
}
- (UIButton *)check_button{
    if (!_check_button) {
        _check_button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 70)];
        _check_button.backgroundColor=[UIColor whiteColor];
        _check_button.layer.cornerRadius=12;
    }
    return _check_button;
}
//当前需要完成任务的标题
- (UILabel *)check_title{
    if (!_check_title) {
        _check_title=[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-150)/2, 10, 150, 20)];
        _check_title.textColor=BACKGROUND_COLOR;
        _check_title.text=@"您今天没有任务";
        _check_title.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        _check_title.textAlignment=NSTextAlignmentLeft;
    }
    return _check_title;
}
//当前需要完成任务的子标题
- (UILabel *)check_description{
    if (!_check_description) {
        _check_description=[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-150)/2, 40, 200, 20)];
        _check_description.textColor=BACKGROUND_COLOR;
        _check_description.text=@"好好放松一下吧";
        _check_description.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    }
    return _check_description;
}
-(UIView*)animation_view{
    if (!_animation_view) {
        _animation_view=[[UIView alloc] initWithFrame:CGRectMake(-30, -40, 150, 150)];
        _animation_view.backgroundColor=[UIColor whiteColor];
        [_animation_view addSubview:self.animation];
    }
    return _animation_view;
}
-(LOTAnimationView *)animation{
    if (!_animation) {
        _animation=[LOTAnimationView animationNamed:@"emoji"];
        _animation.frame=CGRectMake(0,0, 70, 70);
        _animation.loopAnimation=YES;
        _animation.animationSpeed=1.0;
        _animation.center=self.animation_view.center;
    }
    return _animation;
}
-(UIView*)subject_backview{
    if (!_subject_backview) {
        _subject_backview=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-150, 5, 145, 60)];
        _subject_backview.backgroundColor=[UIColor clearColor];
        _subject_backview.layer.cornerRadius=8;
        _subject_backview.layer.borderColor=[UIColor grayColor].CGColor;
        _subject_backview.layer.borderWidth=1;
        [_subject_backview addSubview:self.subject_backView_body];
        [_subject_backview addSubview:self.subject_current_label_description];
    }
    return _subject_backview;
}
-(UIView*)subject_backView_body{
    if (!_subject_backView_body) {
        _subject_backView_body=[[UIView alloc] initWithFrame:CGRectMake(0, 20, 145, 40)];
        _subject_backView_body.backgroundColor=[UIColor clearColor];
        _subject_backView_body.layer.cornerRadius=8;
        _subject_backView_body.layer.borderColor=[UIColor grayColor].CGColor;
        _subject_backView_body.layer.borderWidth=1;
        [_subject_backView_body addSubview:self.subject_current_label];
        
    }
    return _subject_backView_body;
}
-(UILabel *)subject_current_label_description{
    if (!_subject_current_label_description) {
        _subject_current_label_description=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 20)];
        _subject_current_label_description.text=@"PROJECT";
        _subject_current_label_description.textColor=[UIColor grayColor];
        _subject_current_label_description.textAlignment=NSTextAlignmentCenter;
        _subject_current_label_description.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightThin];
    }
    return _subject_current_label_description;
}
-(UILabel *)subject_current_label{
    if (!_subject_current_label) {
        _subject_current_label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 40)];
        _subject_current_label.textColor=[UIColor grayColor];
        _subject_current_label.textAlignment=NSTextAlignmentCenter;
        _subject_current_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightThin];//有内容自适应
    }
    return _subject_current_label;
}


-(void)loadEmptyCheck{
    [[[CheckMusic alloc] init] playSoundEffect_check];
    //2.播放动画
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform=CGAffineTransformMakeScale(1*0.6, 1*0.6);
        self.transform=CGAffineTransformMakeScale(1*1, 1*1);
    } completion:^(BOOL finished) {
        //播放一次动画
        [self.animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.animation stop];
        });
    }];
}
-(void)updateConstraints{
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    
    [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.animation_view.mas_left).offset(-30);
        make.top.equalTo(weakSelf.animation_view.mas_top).offset(-40);
        make.width.equalTo(@(150));
        make.height.equalTo(@(150));
    }];
    
    [self.animation_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.check_button.mas_left);
        make.top.equalTo(weakSelf.check_button.mas_top);
    }];
    
    [self.check_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.animation.mas_right).offset(-30);
        make.top.equalTo(weakSelf.check_button.mas_top).offset(10);
    }];
    [self.check_description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.animation.mas_right).offset(-30);
        make.top.equalTo(weakSelf.check_title.mas_bottom).offset(10);
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
