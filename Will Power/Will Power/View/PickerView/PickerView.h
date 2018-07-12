//
//  PickerView.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapMusicButton.h"

@interface PickerView : UIScrollView
//三个pickerView
@property(nonatomic,strong)UIPickerView *dateRepeatPicker;//设置坚持时间
@property(nonatomic,strong)UIPickerView *dateStartPicker;//设置起始时间的
@property(nonatomic,strong)UIPickerView *timeAlarmPicker;//设置提醒时间的
//存放选取器滑轮值的array
@property(nonatomic,copy)NSArray *repeatDay_array;//每天，每周一，，，，
@property(nonatomic,strong)NSMutableArray *repeatHours_array;//每天几点
@property(nonatomic,strong)NSMutableArray *repeatMinutes_array;//每天几分的时候
////存放选取器滑轮值的string
@property(nonatomic,strong)NSString *repeat_day_str;
@property(nonatomic,strong)NSString *repeat_hour_str;
@property(nonatomic,strong)NSString *repeat_minute_str;
//重复周期的
@property(nonatomic,strong)UIView *forPicker_view_repeat;
@property(nonatomic,strong)UILabel *pickerStartLabel_repeat;
@property(nonatomic,strong)TapMusicButton *cancelButton_repeat;
@property(nonatomic,strong)TapMusicButton *finishPickerButton_repeat;

//起始日期的
@property(nonatomic,strong)UIView *forPicker_view_start;
@property(nonatomic,strong)UILabel *pickerStartLabel_start;
@property(nonatomic,strong)TapMusicButton *cancelButton_start;
@property(nonatomic,strong)TapMusicButton *finishPickerButton_start;

//提醒时间的
@property(nonatomic,strong)UIView *forPicker_view;
@property(nonatomic,strong)UILabel *pickerStartLabel;
@property(nonatomic,strong)TapMusicButton *cancelButton;
@property(nonatomic,strong)TapMusicButton *finishPickerButton;

//为了自己的控制器可以拿到这里的选择器选好的值，这里声明4个字符串,或者可以用通知来做，RAC好像也可以
@property(nonatomic,strong)NSString *repeat_str;
@property(nonatomic,strong)NSString *start_str;
@property(nonatomic,strong)NSString *alarm_str;

@end
