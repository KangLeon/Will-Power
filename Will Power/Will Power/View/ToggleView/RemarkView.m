//
//  RemarkView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "RemarkView.h"
#import "ColorDefine.h"

@interface RemarkView ()

@end

@implementation RemarkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self addSubview:self.remark_view];
    }
    return self;
}
-(TapMusicButton *)remark_view{
    if (!_remark_view) {
        _remark_view=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 92, 37)];
        _remark_view.backgroundColor=TOGGLE_COLOR;
        _remark_view.layer.cornerRadius=18.5;
        
        _remark_imageView=[[UIImageView alloc] init];
        _remark_imageView.frame=CGRectMake(10, 0, 38, 38);
        
        [_remark_view addSubview:_remark_imageView];
        
    }
    return _remark_view;
}

@end
