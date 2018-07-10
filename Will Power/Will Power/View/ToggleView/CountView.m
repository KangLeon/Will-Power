//
//  CountView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CountView.h"
#import "ColorDefine.h"

@interface CountView ()

@end

@implementation CountView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self addSubview:self.count_view];
    }
    return self;
}
-(TapMusicButton*)count_view{
    if (!_count_view) {
        _count_view=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 92, 37)];
        _count_view.backgroundColor=TOGGLE_COLOR;
        _count_view.layer.cornerRadius=18.5;
        
        _count_imageView=[[UIImageView alloc] init];
        _count_imageView.frame=CGRectMake(10, -2, 37, 37);
        
        [_count_view addSubview:_count_imageView];
        
    }
    return _count_view;
}

@end
