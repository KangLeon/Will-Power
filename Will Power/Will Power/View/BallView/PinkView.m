//
//  PinkView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "PinkView.h"
#import "ColorDefine.h"


@interface PinkView ()

@property(assign,nonatomic)CGRect pink_frame;
@end
@implementation PinkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pink_frame=frame;
        [self addSubview:self.pinkButton];
    }
    return self;
}
-(UIButton*)pinkButton{
    if (!_pinkButton) {
        _pinkButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, _pink_frame.size.width, _pink_frame.size.width)];
        _pinkButton.backgroundColor=PINK_COLOR;
        _pinkButton.layer.cornerRadius=_pink_frame.size.width/2;
    }
    return _pinkButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
