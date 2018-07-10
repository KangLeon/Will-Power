//
//  CheckEmptyView.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

@interface CheckEmptyView : UIView
@property(nonatomic,strong)UIButton *check_button;
@property(nonatomic,strong)UILabel *check_title;
@property(nonatomic,strong)UILabel *check_description;
@property(nonatomic,strong)UIView *animation_view;
@property(nonatomic,strong)LOTAnimationView *animation;

-(void)loadEmptyCheck;
@end
