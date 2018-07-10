//
//  AddSecondView.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapMusicButton.h"

@interface AddSecondView : UIScrollView

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
