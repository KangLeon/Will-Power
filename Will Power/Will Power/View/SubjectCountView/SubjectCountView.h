//
//  SubjectCountView.h
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayView.h"

@interface SubjectCountView : UIView

@property(nonatomic,strong)UIImageView *titleImageView;//项目主题图片
@property(nonatomic,strong)UILabel *titleLabel;//项目标题

@property(nonatomic,strong)UILabel *repeatDay_label;//项目已经坚持天数
@property(nonatomic,strong)DayView *dayView;
@property(nonatomic,strong)UILabel *goalDay_label;//项目距离目标天数还有多长时间的描述，目标总天数
@property(nonatomic,strong)DayView *dayView_goal;
@property(nonatomic,strong)UILabel *goalDiscription;//项目距离目标还有多时间
@property(nonatomic,strong)UILabel *subject_start_time;//项目开始时间

@property(nonatomic,strong)UISwitch *subject_isOn_switch;//项目是否进行按钮

@property(nonatomic,strong)UILabel *reward_label;//奖励内容
@property(nonatomic,strong)UIImageView *reward_imageView;//奖励图片

@property(nonatomic,strong)UIView *headView;
@end
