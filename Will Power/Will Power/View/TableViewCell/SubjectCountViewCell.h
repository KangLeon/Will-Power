//
//  SubjectCountViewCell.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/5/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayView.h"

@interface SubjectCountViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *titleImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)DayView *dayView_goal;

@property(nonatomic,strong)UILabel *repeatDay_label;
@property(nonatomic,strong)UILabel *goalDay_label;
@property(nonatomic,strong)DayView *dayView_repeat;
@property(nonatomic,strong)UILabel *goalDiscription;
@property(nonatomic,strong)UILabel *subject_start_time;

@property(nonatomic,strong)UISwitch *subject_isOn_switch;

@property(nonatomic,strong)UILabel *reward_label;

@property(nonatomic,strong)UIView *headView;
@end
