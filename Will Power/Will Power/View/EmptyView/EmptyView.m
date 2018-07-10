//
//  EmptyView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/13.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView ()

@end

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}
-(void)loadUI{
    [self addSubview:self.imageView];
}

//懒加载
-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _imageView;
}


@end
