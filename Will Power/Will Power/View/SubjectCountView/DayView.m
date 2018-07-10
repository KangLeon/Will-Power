//
//  DayView.m
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "DayView.h"

@interface DayView ()
@property(nonatomic,assign)CGRect myFrame;
@end

@implementation DayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.day_view];
        [self addSubview:self.day_label];
    }
    return self;
}
//小label的封装
-(UIView *)day_view{
    if (!_day_view) {
        _day_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 18)];
        _day_view.backgroundColor=[UIColor grayColor];
        _day_view.layer.cornerRadius=5;
        [_day_view addSubview:self.day_label];
    }
    return _day_view;
}
-(UILabel *)day_label{
    if (!_day_label) {
        _day_label=[[UILabel alloc] initWithFrame:CGRectMake(1, 1, 40-2, 18-2)];
      
        _day_label.textColor=[UIColor whiteColor];
        _day_label.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightBlack];
        _day_label.textAlignment=NSTextAlignmentCenter;
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
