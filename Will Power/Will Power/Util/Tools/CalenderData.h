//
//  CalenderData.h
//  Will Power
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalenderData : NSObject

//当前时间最高优先级
@property(nonatomic,strong)NSDate *mid_date_last;//传值的中间Date,这个外部没有使用，可以放在m文件，但是为了可读性放在了这里
@property(nonatomic,copy)NSString *current_date;//今天是几号
@property(nonatomic,copy)NSString *current_month;//这个月是几月，用来判断的参考值，万年不变
@property(nonatomic,copy)NSString *current_year;//今年是哪年
//本月
@property(nonatomic,copy)NSString *dateString;//当前月的日期字符串

@property(nonatomic,copy)NSString *year;//下面的字符串是上下页翻页时会改变值的
@property(nonatomic,copy)NSString *month;
@property(nonatomic,copy)NSString *day;
@property(nonatomic,copy)NSString *week;

@property(nonatomic,copy)NSString *thisMonthFirst_dateString;//本月1号的日期字符串
@property(nonatomic,copy)NSString *thisMonthFirst_week;//本月的1号是周几

@property(nonatomic,assign)BOOL isSpecialYear;

//方法
-(BOOL)isSpecial:(int)year;
+(instancetype)sharedCalenderData;
-(void)loadCurrentMonth;
-(void)loadLastMonth;
-(void)loadNextMonth;
@end
