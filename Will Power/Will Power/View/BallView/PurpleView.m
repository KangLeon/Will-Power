//
//  PurpleView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "PurpleView.h"
#import "ColorDefine.h"


@interface PurpleView ()

@property(assign,nonatomic)CGRect purple_frame;
@end
@implementation PurpleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         _purple_frame=frame;
        [self addSubview:self.purpleButton];
    }
    return self;
}
-(UIButton*)purpleButton{
    if (!_purpleButton) {
        _purpleButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, _purple_frame.size.width, _purple_frame.size.width)];
        _purpleButton.backgroundColor=PURPLE_COLOR;
        _purpleButton.layer.cornerRadius=_purple_frame.size.width/2;
    }
    return _purpleButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
