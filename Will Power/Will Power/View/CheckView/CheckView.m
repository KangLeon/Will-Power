//
//  CheckView.m
//  Will Power
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CheckView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"

@interface CheckView ()

@end

@implementation CheckView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.check_button];
        [self addSubview:self.check_imageView];
        [self addSubview:self.check_title];
        [self addSubview:self.check_description];
        [self addSubview:self.check_backView];
    }
    return self;
}
- (UIButton *)check_button{
    if (!_check_button) {
        _check_button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 65)];
        _check_button.backgroundColor=[UIColor whiteColor];
        _check_button.layer.cornerRadius=12;
    }
    return _check_button;
}

//完成任务的项的图片
- (UIImageView *)check_imageView{
    if (!_check_imageView) {
        _check_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, (65-40)/2, 40, 40)];
    }
    return _check_imageView;
}
//当前需要完成任务的标题
- (UILabel *)check_title{
    if (!_check_title) {
       _check_title=[[UILabel alloc] initWithFrame:CGRectMake(80, 13, 100, 20)];
        _check_title.textColor=BACKGROUND_COLOR;
        _check_title.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    return _check_title;
}
//当前需要完成任务的子标题
- (UILabel *)check_description{
    if (!_check_description) {
        _check_description=[[UILabel alloc] initWithFrame:CGRectMake(80, 35, (SCREEN_WIDTH-40-80-80), 15)];
        _check_description.textColor=BACKGROUND_COLOR;
        _check_description.font=[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }
    return _check_description;
}

//打对勾的小正方形
-(UIView *)check_backView{
    if (!_check_backView) {
        _check_backView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35-40-20, (65-35)/2, 35, 35)];
        _check_backView.backgroundColor=CALENDER_GRAY;
        _check_backView.layer.cornerRadius=5;
    }
    return _check_backView;
}

//打对勾动画
-(void)loadCheck{
    CGPoint pathCenter = CGPointMake(self.check_backView.frame.size.width/2, self.check_backView.frame.size.height/2 - 50);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter radius:0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    
    CGFloat x = self.check_backView.frame.size.width*0.2;
    CGFloat y = self.check_backView.frame.size.height*0.6;
    //勾的起点
    [path moveToPoint:CGPointMake(x, y)];
    //勾的最底端
    CGPoint p1 = CGPointMake(x+10, y+ 10);
    [path addLineToPoint:p1];
    //勾的最上端
    CGPoint p2 = CGPointMake(x+24,y-14);
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
    animation.duration = 0.3;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self.check_backView.layer addSublayer:layer];
}

-(void)removeCheck{
    [layer removeFromSuperlayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
