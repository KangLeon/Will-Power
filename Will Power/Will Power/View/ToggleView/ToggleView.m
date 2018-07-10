//
//  ToggleView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "ToggleView.h"
#import "ColorDefine.h"

@interface ToggleView ()

@end

@implementation ToggleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.toggle_view];
    }
    return self;
}
-(TapMusicButton*)toggle_view{
    if (!_toggle_view) {
        _toggle_view=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 92, 37)];
        _toggle_view.backgroundColor=TOGGLE_COLOR;
        _toggle_view.layer.cornerRadius=18.5;
        
        _toggle_imageView=[[UIImageView alloc] init];//写在这里面的话就不需要主动弄约束了
        _toggle_imageView.frame=CGRectMake(37, 4.5, 40, 40);
        
        [_toggle_view addSubview:_toggle_imageView];
    }
    return _toggle_view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
