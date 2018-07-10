//
//  CalenderData.m
//  Will Power
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CalenderData.h"
#import "NSDate+LocalDate.h"

@interface CalenderData ()
{
    NSDateFormatter *formatter;
}

@end

@implementation CalenderData

+(instancetype)sharedCalenderData{
    static CalenderData *calenderData=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calenderData=[[CalenderData alloc] init];
    });
    return calenderData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)loadCurrentMonth{
    
    //--------------------本月的处理
    //得到当前年月日
    NSDate *date=[NSDate localdate];
    self.mid_date_last=date;
    formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd EEEE"];
    self.dateString=[formatter stringFromDate:date];//得到当前日期的合法字符串
    
    //给各个字符串赋值
    self.year=[self yearStringFormString:self.dateString];//1.该字符串内容和下面字符串内容是一样的，但是用处是不同的
    self.current_year=[self yearStringFormString:self.dateString];//2.该字符串和上面的字符串内容是一样的，但是用处是不同的
    self.month=[self monthStringFormString:self.dateString];
    self.current_month=[self monthStringFormString:self.dateString];
    self.day=[self dayStringFormString:self.dateString];
    self.current_date=[self dayStringFormString:self.dateString];
    self.week=[self weekStringFormString:self.dateString];
    
    
    //通过当前年推算各月的时间
    //1.判断当前年是不是润年
    self.isSpecialYear=[self isSpecial:[self.year intValue]];
    
    //2.判断当前的日期到本月的1日有多少天
    NSInteger minus=[self.day integerValue]-1;
    NSDate *first_date=[[NSDate alloc] initWithTimeInterval:(-60*60*24*minus) sinceDate:date];
    self.thisMonthFirst_dateString=[formatter stringFromDate:first_date];
    self.thisMonthFirst_week=[self weekStringFormString:self.thisMonthFirst_dateString];
    
}

#pragma mark 将字符串解析出年，月，日部分

//通过当前日期字符串计算出当前年
-(NSString *)yearStringFormString:(NSString *)dateStr{
    return [dateStr substringWithRange:NSMakeRange(0, 4)];
}
//通过当前日期字符串计算出月
-(NSString *)monthStringFormString:(NSString *)dateStr{
    return [dateStr substringWithRange:NSMakeRange(5, 2)];
}
//通过当前日期字符串计算出日
-(NSString *)dayStringFormString:(NSString *)dateStr{
    return [dateStr substringWithRange:NSMakeRange(8, 2)];
}

//通过当前日期字符串计算出周几
-(NSString *)weekStringFormString:(NSString *)dateStr{
    return [dateStr substringFromIndex:11];
}

#pragma mark 判断当前年，月，日部分

//判断当前年是否为闰年
-(BOOL)isSpecial:(int)year{
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}

//加载上月日历
-(void)loadLastMonth{
    
    NSDate *lastMonth_date=[[NSDate alloc] initWithTimeInterval:(-60*60*24*30) sinceDate:self.mid_date_last];
    self.mid_date_last=lastMonth_date;
    self.dateString=[formatter stringFromDate:lastMonth_date];
    
    self.year=[self yearStringFormString:self.dateString];
    self.month=[self monthStringFormString:self.dateString];
    self.day=[self dayStringFormString:self.dateString];
    self.week=[self weekStringFormString:self.dateString];
    
    NSDate *first_date=[[NSDate alloc] initWithTimeInterval:(-60*60*24*([self.day integerValue]-1)) sinceDate:lastMonth_date];
    
    self.thisMonthFirst_dateString=[formatter stringFromDate:first_date];
    self.thisMonthFirst_week=[self weekStringFormString:self.thisMonthFirst_dateString];
}

//加载下月日历
-(void)loadNextMonth{
    
    NSDate *nextMonth_date=[[NSDate alloc] initWithTimeInterval:(60*60*24*30) sinceDate:self.mid_date_last];
    self.mid_date_last=nextMonth_date;
    self.dateString=[formatter stringFromDate:nextMonth_date];
    
    self.year=[self yearStringFormString:self.dateString];
    self.month=[self monthStringFormString:self.dateString];
    self.day=[self dayStringFormString:self.dateString];
    self.week=[self weekStringFormString:self.dateString];
    
    NSDate *first_date=[[NSDate alloc] initWithTimeInterval:(-60*60*24*([self.day integerValue]-1)) sinceDate:nextMonth_date];
    
    self.thisMonthFirst_dateString=[formatter stringFromDate:first_date];
    self.thisMonthFirst_week=[self weekStringFormString:self.thisMonthFirst_dateString];
}


@end
