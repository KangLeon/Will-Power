//
//  PickerView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "PickerView.h"
#import <Masonry.h>
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <ReactiveObjC.h>
#import "CalenderData.h"
#import "NSString+DateTitle.h"
#import "NSDate+LocalDate.h"


@interface PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>



//数据array
@property(nonatomic,strong)NSArray *repeatArray;//坚持周期



@property(nonatomic,strong)NSMutableArray *start_year_array;//起始的年
@property(nonatomic,strong)NSMutableArray *start_month_array;//起始的月
@property(nonatomic,copy)NSArray *start_day_array;//起始的日
@property(nonatomic,copy)NSDictionary *start_day_dicitionary_normal;//起始的日 平年
@property(nonatomic,copy)NSDictionary *start_day_dicitionary_special;//起始的日 闰年

//选取器头
@property(nonatomic,strong)UIView *pickerHeader_repeat;//坚持目标的选取器头
@property(nonatomic,strong)UIView *pickerHeader_start;//开始日期的选取器头
@property(nonatomic,strong)UIView *pickerHeader;//提醒时间的选取器头

@property(nonatomic,assign)NSInteger selectedRow;

@property(nonatomic,copy)NSString *selectedYear;

//用于传值拼接的字符串
@property(nonatomic,strong)NSString *year_str;
@property(nonatomic,strong)NSString *month_str;
@property(nonatomic,strong)NSString *day_str;

@property(nonatomic,strong)NSString *repeat_day_str;
@property(nonatomic,strong)NSString *repeat_hour_str;
@property(nonatomic,strong)NSString *repeat_minute_str;
@end

@implementation PickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.forPicker_view_repeat];
        [self addSubview:self.forPicker_view_start];
        [self addSubview:self.forPicker_view];
        
        //重复周期的
        self.dateRepeatPicker.dataSource=self;
        self.dateRepeatPicker.delegate=self;
        
        //起始日期的
        self.dateStartPicker.dataSource=self;
        self.dateStartPicker.delegate=self;
        
        //提醒时间的
        self.timeAlarmPicker.delegate=self;
        self.timeAlarmPicker.dataSource=self;
        
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

//懒加载
#pragma mark --起始时间
-(UIView *)forPicker_view_start{
    if (!_forPicker_view_start) {
        _forPicker_view_start=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2.0, SCREEN_WIDTH, SCREEN_HEIGHT*0.45)];
        _forPicker_view_start.backgroundColor=PICKER_BACKGROUND;
        [_forPicker_view_start addSubview:self.dateStartPicker];
        [_forPicker_view_start addSubview:self.pickerHeader_start];
        [_forPicker_view_start addSubview:self.finishPickerButton_start];
    }
    return _forPicker_view_start;
}

- (UIPickerView *)dateStartPicker{
    if (!_dateStartPicker) {
        _dateStartPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 60)];//这里可不可以访问_forPicker_view？
        _dateStartPicker.backgroundColor=PICKER_BACKGROUND;
    }
    return _dateStartPicker;
}
-(UIView *)pickerHeader_start{
    if (!_pickerHeader_start) {
        _pickerHeader_start=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _pickerHeader_start.backgroundColor=PICKER_VIEW_BACKGROUND;
        [_pickerHeader_start addSubview:self.pickerStartLabel_start];
        [_pickerHeader_start addSubview:self.cancelButton_start];
    }
    return _pickerHeader_start;
}
-(TapMusicButton *)finishPickerButton_start{
    if (!_finishPickerButton_start) {
        _finishPickerButton_start=[[TapMusicButton alloc] initWithFrame:CGRectMake(20, _forPicker_view_start.frame.size.height-130, SCREEN_WIDTH-40, 58)];
        
        [_finishPickerButton_start setImage:[UIImage imageNamed:@"finish_button_image"] forState:UIControlStateNormal];
    }
    return _finishPickerButton_start;
}
-(UILabel *)pickerStartLabel_start{
    if (!_pickerStartLabel_start) {
        _pickerStartLabel_start=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 45)];
        _pickerStartLabel_start.text=@"选择起始日期";
        _pickerStartLabel_start.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        _pickerStartLabel_start.textAlignment=NSTextAlignmentCenter;
        _pickerStartLabel_start.textColor=[UIColor blackColor];
    }
    return _pickerStartLabel_start;
}
-(TapMusicButton*)cancelButton_start{
    if (!_cancelButton_start) {
        _cancelButton_start=[[TapMusicButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [_cancelButton_start setImage:[UIImage imageNamed:@"cancel_picker_image"] forState:UIControlStateNormal];
    }
    return _cancelButton_start;
}
- (NSMutableArray *)start_year_array{
    if (!_start_year_array) {
        _start_year_array=[[NSMutableArray alloc] init];
        for (int i=2018; i<2050; i++) {
            NSString *string=[NSString stringWithFormat:@"%d年",i];
            [_start_year_array addObject:string];
        }
    }
    return _start_year_array;
}
-(NSMutableArray *)start_month_array{
    if (!_start_month_array) {
        _start_month_array=[[NSMutableArray alloc] init];
        for (int i=1; i<13; i++) {
            NSString *string=[NSString stringWithFormat:@"%d月",i];
            [_start_month_array addObject:string];
        }
    }
    return _start_month_array;
}
-(NSDictionary *)start_day_dicitionary_normal{
    if (!_start_day_dicitionary_normal) {
        _start_day_dicitionary_normal=@{@"1月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                        @"2月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日"],
                                        @"3月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30",@"31"],
                                        @"4月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30"],
                                        @"5月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                        @"6月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"],
                                        @"7月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                        @"8月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                        @"9月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"],
                                        @"10月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                        @"11月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"],
                                        @"12月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"]
                                        };
    }
    return _start_day_dicitionary_normal;
}
-(NSDictionary *)start_day_dicitionary_special{
    if (!_start_day_dicitionary_special) {
        _start_day_dicitionary_special=@{@"1月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                         @"2月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日"],
                                         @"3月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30",@"31"],
                                         @"4月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30"],
                                         @"5月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                         @"6月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"],
                                         @"7月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                         @"8月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                         @"9月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"],
                                         @"10月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"],
                                         @"11月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日"],
                                         @"12月":@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"]
                                         };
    }
    return _start_day_dicitionary_special;
}
-(NSArray *)start_day_array{
    if (!_start_day_array) {
        _start_day_array=@[@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"];
    }
    return _start_day_array;
}

//用于拼接字符串的的子字符串的懒加载
- (NSString *)year_str{
    if (!_year_str) {
        _year_str=[self.start_year_array objectAtIndex:0];
    }
    return _year_str;
}
- (NSString *)month_str{
    if (!_month_str) {
        _month_str=[self.start_month_array objectAtIndex:0];
    }
    return _month_str;
}
- (NSString *)day_str{
    if (!_day_str) {
        _day_str=[self.start_day_array objectAtIndex:0];
    }
    return _day_str;
}
- (NSString *)repeat_day_str{
    if (!_repeat_day_str) {
        _repeat_day_str=[self.repeatDay_array objectAtIndex:0];
    }
    return _repeat_day_str;
}
- (NSString *)repeat_hour_str{
    if (!_repeat_hour_str) {
        _repeat_hour_str=[self.repeatHours_array objectAtIndex:0];
    }
    return _repeat_hour_str;
}
- (NSString *)repeat_minute_str{
    if (!_repeat_minute_str) {
        _repeat_minute_str=[self.repeatMinutes_array objectAtIndex:0];
    }
    return _repeat_minute_str;
}

//拼接后的字符串
//这个可以直接复制没有拼接的必要,
-(NSString *)repeat_str{
    if (!_repeat_str) {
        _repeat_str=[self.repeatArray objectAtIndex:0];
    }
    return _repeat_str;
}

-(NSString *)start_str{
    if (!_start_str) {
        _start_str=[NSString stringWithFormat:@"%@%@%@",self.year_str,self.month_str,self.day_str];
    }
    return _start_str;
}
-(NSString *)alarm_str{
    if (!_alarm_str) {
        _alarm_str=[NSString stringWithFormat:@"%@%@%@",self.repeat_day_str,self.repeat_hour_str,self.repeat_minute_str];
    }
    return _alarm_str;
}

#pragma mark --选择坚持目标
-(UIView *)forPicker_view_repeat{
    if (!_forPicker_view_repeat) {
        _forPicker_view_repeat=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2.0, SCREEN_WIDTH, SCREEN_HEIGHT*0.45)];
        _forPicker_view_repeat.backgroundColor=PICKER_BACKGROUND;
        [_forPicker_view_repeat addSubview:self.dateRepeatPicker];
        [_forPicker_view_repeat addSubview:self.pickerHeader_repeat];
        [_forPicker_view_repeat addSubview:self.finishPickerButton_repeat];
    }
    return _forPicker_view_repeat;
}
-(UIPickerView *)dateRepeatPicker{
    if (!_dateRepeatPicker) {
        _dateRepeatPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 60)];//这里可不可以访问_forPicker_view？
        _dateRepeatPicker.backgroundColor=PICKER_BACKGROUND;
    }
    return _dateRepeatPicker;
}
-(UIView *)pickerHeader_repeat{
    if (!_pickerHeader_repeat) {
        _pickerHeader_repeat=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _pickerHeader_repeat.backgroundColor=PICKER_VIEW_BACKGROUND;
        [_pickerHeader_repeat addSubview:self.pickerStartLabel_repeat];
        [_pickerHeader_repeat addSubview:self.cancelButton_repeat];
    }
    return _pickerHeader_repeat;
}
-(TapMusicButton *)finishPickerButton_repeat{
    if (!_finishPickerButton_repeat) {
        _finishPickerButton_repeat=[[TapMusicButton alloc] initWithFrame:CGRectMake(20, _forPicker_view_repeat.frame.size.height-130, SCREEN_WIDTH-40, 58)];
        
        [_finishPickerButton_repeat setImage:[UIImage imageNamed:@"finish_button_image"] forState:UIControlStateNormal];
    }
    return _finishPickerButton_repeat;
}
-(UILabel *)pickerStartLabel_repeat{
    if (!_pickerStartLabel_repeat) {
        _pickerStartLabel_repeat=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 45)];
        _pickerStartLabel_repeat.text=@"选择坚持目标";
        _pickerStartLabel_repeat.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        _pickerStartLabel_repeat.textAlignment=NSTextAlignmentCenter;
        _pickerStartLabel_repeat.textColor=[UIColor blackColor];
    }
    return _pickerStartLabel_repeat;
}

-(TapMusicButton*)cancelButton_repeat{
    if (!_cancelButton_repeat) {
        _cancelButton_repeat=[[TapMusicButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [_cancelButton_repeat setImage:[UIImage imageNamed:@"cancel_picker_image"] forState:UIControlStateNormal];
    }
    return _cancelButton_repeat;
}


-(NSArray*)repeatArray{
    if (!_repeatArray) {
        _repeatArray=@[@"永远",@"一个月",@"2个月",@"3个月",@"6个月",@"一年"];
    }
    return _repeatArray;
}

#pragma mark --选择提醒时间

-(UIView *)forPicker_view{
    if (!_forPicker_view) {
        _forPicker_view=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2.0, SCREEN_WIDTH, SCREEN_HEIGHT*0.45)];
        _forPicker_view.backgroundColor=PICKER_BACKGROUND;
        [_forPicker_view addSubview:self.timeAlarmPicker];
        [_forPicker_view addSubview:self.pickerHeader];
        [_forPicker_view addSubview:self.finishPickerButton];
    }
    return _forPicker_view;
}

-(UIPickerView *)timeAlarmPicker{
    if (!_timeAlarmPicker) {
        _timeAlarmPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 60)];//这里可不可以访问_forPicker_view？
        _timeAlarmPicker.backgroundColor=PICKER_BACKGROUND;
    }
    return _timeAlarmPicker;
}


-(UIView *)pickerHeader{
    if (!_pickerHeader) {
        _pickerHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _pickerHeader.backgroundColor=PICKER_VIEW_BACKGROUND;
        [_pickerHeader addSubview:self.pickerStartLabel];
        [_pickerHeader addSubview:self.cancelButton];
    }
    return _pickerHeader;
}

-(TapMusicButton *)finishPickerButton{
    if (!_finishPickerButton) {
        _finishPickerButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(20, _forPicker_view.frame.size.height-130, SCREEN_WIDTH-40, 58)];
        
        [_finishPickerButton setImage:[UIImage imageNamed:@"finish_button_image"] forState:UIControlStateNormal];
    }
    return _finishPickerButton;
}

-(UILabel *)pickerStartLabel{
    if (!_pickerStartLabel) {
        _pickerStartLabel=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 45)];
        _pickerStartLabel.text=@"选择提醒时间";
        _pickerStartLabel.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        _pickerStartLabel.textAlignment=NSTextAlignmentCenter;
        _pickerStartLabel.textColor=[UIColor blackColor];
    }
    return _pickerStartLabel;
}

-(TapMusicButton*)cancelButton{
    if (!_cancelButton) {
        _cancelButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [_cancelButton setImage:[UIImage imageNamed:@"cancel_picker_image"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

-(NSArray*)repeatDay_array{
    if (!_repeatDay_array) {
        _repeatDay_array=@[@"每天",@"工作日",@"每周日",@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六"];
    }
    return _repeatDay_array;
}

-(NSMutableArray*)repeatHours_array{
    if (!_repeatHours_array) {
        _repeatHours_array=[[NSMutableArray alloc] init];
        for (int i=0; i<24; i++) {
            NSString *hour_string=[NSString stringWithFormat:@"%d点",i];
            [_repeatHours_array addObject:hour_string];
        }
    }
    return _repeatHours_array;
}
-(NSMutableArray*)repeatMinutes_array{
    if (!_repeatMinutes_array) {
        _repeatMinutes_array=[[NSMutableArray alloc] init];
        for (int i=0; i<60; i++) {
            NSString *minute_string=[NSString stringWithFormat:@"%d分",i];
            [_repeatMinutes_array addObject:minute_string];
        }
    }
    return _repeatMinutes_array;
}




#pragma mark --datasource PickerView 数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([pickerView isEqual:self.timeAlarmPicker]) {
        return 3;
    }else if([pickerView isEqual:self.dateStartPicker]){
        return 3;
    }else if([pickerView isEqual:self.dateRepeatPicker]){
        return 1;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([pickerView isEqual:self.timeAlarmPicker]) {
        if (component==0) {
            return 9;
        }else if (component==1){
            return 24;
        }else {
            return 60;
        }
    }else if([pickerView isEqual:self.dateStartPicker]){
        if (component==0) {
            return self.start_year_array.count;
        }else if (component==1){
            return self.start_month_array.count;
        }else {
            return self.start_day_array.count;
        }
    }else if ([pickerView isEqual:self.dateRepeatPicker]){
        return 6;
    }
    return 0;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //选择起始日期的选取器
    if ([pickerView isEqual:self.dateStartPicker]) {
        
        UIView *line;
        
        for(UIView *speartorView in pickerView.subviews)
        {
            if (speartorView.frame.size.height < 1)//取出分割线view
            {
                line=speartorView;
                speartorView.backgroundColor =[UIColor clearColor];
            }
        }
        
        UILabel *reuse_label=(UILabel*)view;
        if (reuse_label==nil) {
            if (component==0) {
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 80, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.start_year_array[row];
                
                if (self.selectedRow==row) {
                    
                    //这一部分是为了给Picker选中行设置背景颜色的
                    NSArray *subviews =pickerView.subviews;
                    if (!(subviews.count > 0)) {
                        
                    }
                    NSArray *coloms = subviews.firstObject;
                    if (coloms) {
                        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
                        if (subviewCache.count > 0) {
                            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                            if (middleContainerView) {
                                middleContainerView.backgroundColor = [UIColor whiteColor];
                            }
                        }
                    }
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                        
                    }];
                }
                
                return reuse_label;
            }else if (component==1){
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 64, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.start_month_array[row];
                if (self.selectedRow==row) {
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                    }];
                }
                
                return reuse_label;
            }
            else{
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 64, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.start_day_array[row];
                if (self.selectedRow==row) {
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                    }];
                }
                
                return reuse_label;
            }
        }
        
        
        return reuse_label;
        
    }
    
    //选择提醒时间的选取器
    if ([pickerView isEqual:self.timeAlarmPicker]) {
        
        UIView *line;
        
        for(UIView *speartorView in pickerView.subviews)
        {
            if (speartorView.frame.size.height < 1)//取出分割线view
            {
                line=speartorView;
                speartorView.backgroundColor =[UIColor clearColor];
            }
        }
        
        UILabel *reuse_label=(UILabel*)view;
        if (reuse_label==nil) {
            if (component==0) {
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 64, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.repeatDay_array[row];
                
                if (self.selectedRow==row) {
                    
                    //这一部分是为了给Picker选中行设置背景颜色的
                    NSArray *subviews =pickerView.subviews;
                    if (!(subviews.count > 0)) {
                        
                    }
                    NSArray *coloms = subviews.firstObject;
                    if (coloms) {
                        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
                        if (subviewCache.count > 0) {
                            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                            if (middleContainerView) {
                                middleContainerView.backgroundColor = [UIColor whiteColor];
                            }
                        }
                    }
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                        
                    }];
                }
                
                return reuse_label;
            }else if (component==1){
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 64, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.repeatHours_array[row];
                if (self.selectedRow==row) {
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                    }];
                }
                
                return reuse_label;
            }
            else{
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 64, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.repeatMinutes_array[row];
                if (self.selectedRow==row) {
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                    }];
                }
                
                return reuse_label;
            }
        }
        
        
        return reuse_label;
    }
    
    //选择坚持目标的选取器
    UIView *line;
    
    for(UIView *speartorView in pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            line=speartorView;
            speartorView.backgroundColor =[UIColor clearColor];
        }
    }
    
    UILabel *reuse_label=(UILabel*)view;
    if (reuse_label==nil) {
        reuse_label=[[UILabel alloc] init];
        reuse_label.frame=CGRectMake(0, 0, 64, 55);
        reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        reuse_label.textColor=[UIColor grayColor];
        reuse_label.text=self.repeatArray[row];
        
        if (self.selectedRow==row) {
            
            //这一部分是为了给Picker选中行设置背景颜色的
            NSArray *subviews =pickerView.subviews;
            if (!(subviews.count > 0)) {
                
            }
            NSArray *coloms = subviews.firstObject;
            if (coloms) {
                NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
                if (subviewCache.count > 0) {
                    UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                    if (middleContainerView) {
                        middleContainerView.backgroundColor = [UIColor whiteColor];
                    }
                }
            }
            //选中行放大
            [UIView animateWithDuration:2 animations:^{
                reuse_label.textColor=PICKER_TITLE;
                reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                
            }];
        }
        return reuse_label;
    }
    return reuse_label;
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //1.如果是设置坚持目标的选择器的话
    if ([pickerView isEqual:self.dateRepeatPicker]) {
        self.repeat_str=[self.repeatArray objectAtIndex:row];
    }
    
    //2.如果是起始日期的选择器的话
    if ([pickerView isEqual:self.dateStartPicker]) {
        
        //级联，闰年和平年的2月时间不一样
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.selectedYear=self.start_year_array[0];
        });
        
        if (component==0) {
            self.selectedYear=self.start_year_array[row];
        }
        
        //判断是平年还是闰年
        if ([[CalenderData sharedCalenderData] isSpecial:[self.selectedYear intValue]]) {
            //闰年
            NSString *selectedMonth;
            if (component==1) {
                selectedMonth=self.start_month_array[row];
                self.start_day_array=[self.start_day_dicitionary_special objectForKey:selectedMonth];
                [self.dateStartPicker reloadComponent:2];
                [self.dateStartPicker selectRow:0 inComponent:2 animated:YES];
            }
        }else{
            //平年
            NSString *selectedMonth;
            if (component==1) {
                selectedMonth=self.start_month_array[row];
                self.start_day_array=[self.start_day_dicitionary_normal objectForKey:selectedMonth];
                [self.dateStartPicker reloadComponent:2];
                [self.dateStartPicker selectRow:0 inComponent:2 animated:YES];
            }
        }
        
        //传值给自己的viewcontroller
        if (component==0) {
            self.year_str=[self.start_year_array objectAtIndex:row];
        }else if(component==1){
            self.month_str=[self.start_month_array objectAtIndex:row];
        }else if(component==2){
            self.day_str=[self.start_day_array objectAtIndex:row];
        }
        
        //在这里判断选择的值是否比当前日期要靠前，靠前的话是不可以选择的，
        NSString *dateString=[NSString stringWithFormat:@"%@%@%@",self.year_str,self.month_str,self.day_str];
        NSDate *selectDate=[dateString dateFrom:dateString];//拿到当前日期的00:00,
        NSDate *current=[NSDate localdate_4real];//拿到当前日期下的北京时间
        
        //判断选择日期与当前日期
        if([selectDate compare:current]==NSOrderedDescending){
            self.start_str=dateString;
        }else{
            self.start_str=@"不正确的日期";
        }
        
        
        
    }
    
    //3.如果是设置提醒时间的选择器的话
    if ([pickerView isEqual:self.timeAlarmPicker]) {
        
        //传值给自己的viewcontroller
        if (component==0) {
            self.repeat_day_str=[self.repeatDay_array objectAtIndex:row];
        }else if (component==1){
            self.repeat_hour_str=[self.repeatHours_array objectAtIndex:row];
        }else if (component==2){
            self.repeat_minute_str=[self.repeatMinutes_array objectAtIndex:row];
        }
        self.alarm_str=[NSString stringWithFormat:@"%@%@%@",self.repeat_day_str,self.repeat_hour_str,self.repeat_minute_str];
    }
    
    self.selectedRow=row;
    [pickerView reloadComponent:component];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if ([pickerView isEqual:self.timeAlarmPicker]) {
        if (component==1) {
            return 50;
        }
        else{
            return 60;
        }
    }else if ([pickerView isEqual:self.dateRepeatPicker]){
        return 60;
    }else if ([pickerView isEqual:self.dateStartPicker]){
        if (component==0) {
            return 80;
        }else{
            return 50;
        }
    }
    return 0;
}


//#pragma mark --Masonry布局约束相关
-(void)updateConstraints{
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    //1.提醒时间的布局约束
    [self.timeAlarmPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view.mas_left);
        make.top.equalTo(weakSelf.forPicker_view.mas_top).offset(50);
        make.right.equalTo(weakSelf.forPicker_view.mas_right);
        make.bottom.equalTo(weakSelf.forPicker_view.mas_bottom).offset(-130);
    }];
    
    //加了这个约束就会错误，但是不加的话，约束也不会错，
    //    [self.pickerHeader mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(weakSelf.forPicker_view.mas_left);
    //         make.top.equalTo(weakSelf.forPicker_view.mas_top);
    //        make.right.equalTo(weakSelf.forPicker_view.mas_right);
    //    }];
    
    [self.finishPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view.mas_left).offset(20);
        make.right.equalTo(weakSelf.forPicker_view.mas_right).offset(-20);
        make.top.equalTo(weakSelf.forPicker_view.mas_bottom).offset(-130);
    }];
    
    //2.坚持目标的布局约束
    [self.dateRepeatPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view_repeat.mas_left);
        make.top.equalTo(weakSelf.forPicker_view_repeat.mas_top).offset(50);
        make.right.equalTo(weakSelf.forPicker_view_repeat.mas_right);
        make.bottom.equalTo(weakSelf.forPicker_view_repeat.mas_bottom).offset(-130);
    }];
    [self.finishPickerButton_repeat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view_repeat.mas_left).offset(20);
        make.right.equalTo(weakSelf.forPicker_view_repeat.mas_right).offset(-20);
        make.top.equalTo(weakSelf.forPicker_view_repeat.mas_bottom).offset(-130);
    }];
    
    //3.起始时间的布局约束
    [self.dateStartPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view_start.mas_left);
        make.top.equalTo(weakSelf.forPicker_view_start.mas_top).offset(50);
        make.right.equalTo(weakSelf.forPicker_view_start.mas_right);
        make.bottom.equalTo(weakSelf.forPicker_view_start.mas_bottom).offset(-130);
    }];
    [self.finishPickerButton_start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view_start.mas_left).offset(20);
        make.right.equalTo(weakSelf.forPicker_view_start.mas_right).offset(-20);
        make.top.equalTo(weakSelf.forPicker_view_start.mas_bottom).offset(-130);
    }];
    
}

@end
