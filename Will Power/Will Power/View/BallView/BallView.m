//
//  BallView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BallView.h"
#import "ColorDefine.h"
#import "SizeDefine.h"


@interface BallView ()

@end

@implementation BallView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.ball_button];
    }
    return self;
}

- (TapMusicButton *)ball_button{
    if (!_ball_button) {
        _ball_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _ball_button.layer.cornerRadius=self.frame.size.width/2;
        [_ball_button addSubview:self.ball_titleLabel];
    }
    return _ball_button;
}

-(UILabel *)ball_titleLabel{
    if (!_ball_titleLabel) {
        _ball_titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-130)/2, (self.frame.size.height-130)/2, 130, 130)];
        _ball_titleLabel.textColor=[UIColor whiteColor];
        _ball_titleLabel.font=[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        //在这里进行判断如果文字太多的话就把文字显示的小一些
        _ball_titleLabel.adjustsFontSizeToFitWidth=YES;
        _ball_titleLabel.minimumScaleFactor=0.5;
       
        //在这里设置可以自动换行
        _ball_titleLabel.numberOfLines=0;//可以自动换行
        _ball_titleLabel.textAlignment=NSTextAlignmentCenter;
        _ball_titleLabel.layer.cornerRadius=self.frame.size.width/2;
    }
    return _ball_titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
