//
//  ScoreView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/26.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "ScoreView.h"

@interface ScoreView ()

@property(nonatomic,strong)UILabel *repeat_label;



@property(nonatomic,strong)UILabel *day_label;
@end

@implementation ScoreView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}
-(void)loadUI{
    [self addSubview:self.first_number];
    [self addSubview:self.second_number];
    [self addSubview:self.third_number];
    [self addSubview:self.repeat_label];
    [self addSubview:self.day_label];

}

//懒加载部分
-(UILabel*)repeat_label{
    if (!_repeat_label) {
        _repeat_label=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
        _repeat_label.backgroundColor=[UIColor whiteColor];
        _repeat_label.layer.cornerRadius = 8;
        _repeat_label.clipsToBounds = YES;
        _repeat_label.text=@"坚持天数";
        _repeat_label.textColor=[UIColor blackColor];
        _repeat_label.textAlignment=NSTextAlignmentCenter;
        _repeat_label.font=[UIFont systemFontOfSize:17.0 weight:UIFontWeightLight];
    }
    return _repeat_label;
}

-(UIImageView *)first_number{
    if (!_first_number) {
        _first_number=[[UIImageView alloc] initWithFrame:CGRectMake(80, 50, 48, 60)];
        _first_number.image=[UIImage imageNamed:@"0_number_image"];
    }
    return _first_number;
}
-(UIImageView *)second_number{
    if (!_second_number) {
        _second_number=[[UIImageView alloc] initWithFrame:CGRectMake(129, 50, 48, 60)];
        _second_number.image=[UIImage imageNamed:@"0_number_image"];
    }
    return _second_number;
}
-(UIImageView *)third_number{
    if (!_third_number) {
        _third_number=[[UIImageView alloc] initWithFrame:CGRectMake(178, 50, 48, 60)];
        _third_number.image=[UIImage imageNamed:@"0_number_image"];
    }
    return _third_number;
}

-(UILabel*)day_label{
    if (!_day_label) {
        _day_label=[[UILabel alloc] initWithFrame:CGRectMake(227, 50, 48, 60)];
        _day_label.text=@"Day";
        _day_label.textColor=[UIColor blackColor];
        _day_label.font=[UIFont systemFontOfSize:25.0 weight:UIFontWeightThin];
        _day_label.textAlignment=NSTextAlignmentCenter;
        _day_label.layer.cornerRadius = 8;
        _day_label.clipsToBounds = YES;
        _day_label.backgroundColor=[UIColor whiteColor];
    }
    return _day_label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
