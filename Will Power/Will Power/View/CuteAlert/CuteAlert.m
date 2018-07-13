//
//  CuteAlert.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/5/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CuteAlert.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <Lottie/Lottie.h>

@interface CuteAlert ()

@property(nonatomic,strong)UILabel *content_label;
@property(nonatomic,strong)LOTAnimationView *animation;
@end

@implementation CuteAlert
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}
-(void)loadUI{
    self.backgroundColor=[UIColor colorWithRed:38 green:228 blue:164 alpha:1.0];
    [self addSubview:self.content_label];
    [self addSubview:self.animation];
}
-(UILabel*)content_label{
    if (!_content_label) {
        _content_label=[[UILabel alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT*0.15, SCREEN_WIDTH-80, SCREEN_HEIGHT*0.2)];
        _content_label.numberOfLines=0;
        _content_label.text=@"成功确立计划，您已经迈出了走向胜利的第一步也是最重要的一步，请在接下来的日子里，认真对待自己，鼓励自己，不要责怪自己，祝你顺利完成计划！";
        _content_label.textColor=BACKGROUND_COLOR;
        _content_label.font=[UIFont systemFontOfSize:25.0 weight:UIFontWeightThin];
        _content_label.textAlignment=NSTextAlignmentCenter;
    }
    return _content_label;
}

-(LOTAnimationView *)animation{
    if (!_animation) {
        _animation=[LOTAnimationView animationNamed:@"done"];
        _animation.frame=CGRectMake(70, SCREEN_HEIGHT*0.4, SCREEN_WIDTH-140, SCREEN_WIDTH-140);
        _animation.loopAnimation=true;
        _animation.animationSpeed=1.0;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
