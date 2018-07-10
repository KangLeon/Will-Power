//
//  CuteAlert.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/5/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CuteAlert.h"
#import "SizeDefine.h"
#import "ColorDefine.h"

@interface CuteAlert ()

@property(nonatomic,strong)UIView *backView;
@end

@implementation CuteAlert
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}
-(void)loadUI{
    [self.backView addSubview:self.alertImageView];
    [self addSubview:self.backView];
}
-(UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    }
    return _backView;
}
-(UIImageView*)alertImageView{
    if (!_alertImageView) {
        _alertImageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-319)/2, (SCREEN_HEIGHT-374-26)/2, 319, 374)];
        _alertImageView.image=[UIImage imageNamed:@"good_start"];
    }
    return _alertImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
