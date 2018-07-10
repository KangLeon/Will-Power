//
//  HelpView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "HelpView.h"
#import "ColorDefine.h"

@interface HelpView ()

@end

@implementation HelpView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
        [self addSubview:self.help_view];
    }
    return self;
}
-(TapMusicButton*)help_view{
    if (!_help_view) {
        _help_view=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 92, 37)];
        _help_view.backgroundColor=TOGGLE_COLOR;
        _help_view.layer.cornerRadius=18.5;
        
        _help_imageView=[[UIImageView alloc] init];
        _help_imageView.frame=CGRectMake(10, -2, 37, 37);
        
        [_help_view addSubview:_help_imageView];
    }
    return _help_view;
}

@end
