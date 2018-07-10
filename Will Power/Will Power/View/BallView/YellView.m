//
//  YellView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "YellView.h"
#import "ColorDefine.h"


@interface YellView ()

@property(assign,nonatomic)CGRect yellow_frame;
@end
@implementation YellView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _yellow_frame=frame;
        [self addSubview:self.yellowButton];
    }
    return self;
}
-(UIButton *)yellowButton{
    if (!_yellowButton) {
        _yellowButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, _yellow_frame.size.width, _yellow_frame.size.width)];
        _yellowButton.backgroundColor=YELLOW_COLOR;
        _yellowButton.layer.cornerRadius=_yellow_frame.size.width/2;
    }
    return _yellowButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
