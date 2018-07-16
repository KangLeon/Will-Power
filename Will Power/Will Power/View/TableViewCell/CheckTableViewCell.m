//
//  CheckTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/10.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CheckTableViewCell.h"
#import "ColorDefine.h"
#import "SizeDefine.h"
#import "TapMusic.h"


@interface CheckTableViewCell ()



@end

@implementation CheckTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.subject_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, (55-30)/2, 30, 30)];
        self.subject_imageView.image=[UIImage imageNamed:@"do_now_image"];
        
        self.subject_label=[[UILabel alloc] initWithFrame:CGRectMake(50, (55-30)/2, SCREEN_WIDTH*0.338164, 30)];
        self.subject_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
        self.subject_label.textAlignment=NSTextAlignmentLeft;
        self.subject_label.adjustsFontSizeToFitWidth=YES;
        
        self.subject_date_label=[[UILabel alloc] initWithFrame:CGRectMake(self.subject_label.frame.size.width, (55-28)/2, 150, 28)];
        self.subject_date_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightThin];
        self.subject_date_label.textAlignment=NSTextAlignmentRight;
        self.subject_date_label.adjustsFontSizeToFitWidth=YES;
        
        self.status_check=NO;
        
        [self addSubview:self.subject_label];
        [self addSubview:self.subject_date_label];
        [self addSubview:self.subject_imageView];
        [self addSubview:self.check_backView];
    }
    return self;
}

//打对勾的小正方形
-(UIView *)check_backView{
    if (!_check_backView) {
        _check_backView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50, (55-30)/2, 30, 30)];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
