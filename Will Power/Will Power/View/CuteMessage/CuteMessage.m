//
//  CuteMessage.m
//  Will Power
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CuteMessage.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <Masonry.h>
#import <Lottie/Lottie.h>

@interface CuteMessage ()
@property(nonatomic,strong)UIView *message_backView;
//@property(nonatomic,strong)UIImageView *message_imageView;
@property(nonatomic,strong)LOTAnimationView *animation;
@property(nonatomic,strong)UIView *animation_view;
@property(nonatomic,strong)UILabel *message_title;
@property(nonatomic,strong)UILabel *messaage_subTitle;
@end

@implementation CuteMessage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

-(void)loadUI{
    [self addSubview:self.message_backView];
    [self updateConstraintsIfNeeded];
}

- (UIView *)message_backView{
    if (!_message_backView) {
        _message_backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _message_backView.backgroundColor=CUTE_GREEN;
        [_message_backView addSubview:self.animation_view];
        [_message_backView addSubview:self.message_title];
        [_message_backView addSubview:self.messaage_subTitle];
    }
    return _message_backView;
}

-(UIView*)animation_view{
    if (!_animation_view) {
        _animation_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 65)];
        _animation_view.backgroundColor=CUTE_GREEN;
        [_animation_view addSubview:self.animation];
    }
    return _animation_view;
}

-(LOTAnimationView *)animation{
    if (!_animation) {
        _animation=[LOTAnimationView animationNamed:@"laugh"];
        _animation.frame=CGRectMake(0,0, 50, 50);
        _animation.loopAnimation=true;
        _animation.animationSpeed=1.0;
        _animation.center=self.animation_view.center;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}
    
-(UILabel *)message_title{
    if (!_message_title) {
        _message_title=[[UILabel alloc] initWithFrame:CGRectMake(90, 15, SCREEN_WIDTH-90, 20)];
        _message_title.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        _message_title.textColor=[UIColor whiteColor];
        _message_title.textAlignment=NSTextAlignmentLeft;
    }
    return _message_title;
}

- (UILabel *)messaage_subTitle{
    if (!_messaage_subTitle) {
        _messaage_subTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 38, SCREEN_WIDTH-90, 18)];
        _messaage_subTitle.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        _messaage_subTitle.textColor=[UIColor whiteColor];
        _messaage_subTitle.textAlignment=NSTextAlignmentLeft;
    }
    return _messaage_subTitle;
}

//成功提醒框，绿色还需要调，很难看
-(void)showCuteSuccessWithTitle:(NSString *)title subTitle:(NSString *)subtitle{
    self.message_title.text=title;
    self.messaage_subTitle.text=subtitle;
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.message_backView.center=CGPointMake(self.message_backView.center.x, self.message_backView.center.y+self.message_backView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.message_backView.center=CGPointMake(self.message_backView.center.x, self.message_backView.center.y-self.message_backView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}


-(void)updateConstraints{
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;

    [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.animation_view.mas_left).offset(20);
        make.top.equalTo(weakSelf.animation_view.mas_top).offset(15);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [self.animation_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.message_backView.mas_left);
        make.top.equalTo(weakSelf.message_backView.mas_top);
    }];
    
    [self.message_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.animation.mas_right).offset(20);
        make.top.equalTo(weakSelf.message_backView.mas_top).offset(15);
    }];
    
    [self.messaage_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.animation.mas_right).offset(20);
        make.top.equalTo(weakSelf.message_title.mas_bottom).offset(3);
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
