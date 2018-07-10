//
//  TapMusicButton.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "TapMusicButton.h"
#import "TapMusic.h"
#import <ReactiveObjC.h>

@implementation TapMusicButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           TapMusic *tapMusic=[TapMusic shareTapMusic];
            [tapMusic playSoundEffect];
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform=CGAffineTransformMakeScale(1*0.6, 1*0.6);
                self.transform=CGAffineTransformMakeScale(1*1, 1*1);
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
