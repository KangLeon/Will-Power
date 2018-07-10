//
//  RewardView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "RewardView.h"
#import "ColorDefine.h"

@interface RewardView ()

@end

@implementation RewardView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.reward_view];
    }
    return self;
}
-(TapMusicButton *)reward_view{
    if (!_reward_view) {
        _reward_view=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 92, 37)];
        _reward_view.backgroundColor=TOGGLE_COLOR;
        _reward_view.layer.cornerRadius=18.5;
        
        _reward_imageView=[[UIImageView alloc] init];
        _reward_imageView.frame=CGRectMake(43, 0, 38, 38);
        
        [_reward_view addSubview:_reward_imageView];
    }
    return _reward_view;
}

@end
