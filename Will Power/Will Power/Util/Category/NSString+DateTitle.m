//
//  NSString+DateTitle.m
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "NSString+DateTitle.h"

@implementation NSString (DateTitle)

//当前的数字月换算成英文和汉字显示
- (NSString *)monthForDateString:(NSString *)dateString{
//    NSString *year_string=[dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month_string=[dateString substringWithRange:NSMakeRange(5, 2)];
//    NSString *day_string=[dateString substringWithRange:NSMakeRange(8, 2)];
    
    if ([month_string isEqualToString:@"01"]) {
        return [NSString stringWithFormat:@"Jan 一月"];
    } else if([month_string isEqualToString:@"02"]){
        return [NSString stringWithFormat:@"Feb 二月"];
    }else if([month_string isEqualToString:@"03"]){
        return [NSString stringWithFormat:@"Mar 三月"];
    }else if([month_string isEqualToString:@"04"]){
        return [NSString stringWithFormat:@"Apr 四月"];
    }else if([month_string isEqualToString:@"05"]){
        return [NSString stringWithFormat:@"May 五月"];
    }else if([month_string isEqualToString:@"06"]){
        return [NSString stringWithFormat:@"Jun 六月"];
    }else if([month_string isEqualToString:@"07"]){
        return [NSString stringWithFormat:@"Jul 七月"];
    }else if([month_string isEqualToString:@"08"]){
        return [NSString stringWithFormat:@"Aug 八月"];
    }else if([month_string isEqualToString:@"09"]){
        return [NSString stringWithFormat:@"Sep 九月"];
    }else if([month_string isEqualToString:@"10"]){
        return [NSString stringWithFormat:@"Oct 十月"];
    }else if([month_string isEqualToString:@"11"]){
        return [NSString stringWithFormat:@"Nov 十一月"];
    }else if([month_string isEqualToString:@"12"]){
        return [NSString stringWithFormat:@"Dec 十二月"];
    }
    return nil;
}
//将月初转化为普通数字
-(NSString *)monthfirstString:(NSString*)dateString{
    if ([dateString isEqualToString:@"Jan 一月"]) {
        return [NSString stringWithFormat:@"1"];
    } else if([dateString isEqualToString:@"Feb 二月"]){
        return [NSString stringWithFormat:@"02"];
    }else if([dateString isEqualToString:@"Mar 三月"]){
        return [NSString stringWithFormat:@"03"];
    }else if([dateString isEqualToString:@"Apr 四月"]){
        return [NSString stringWithFormat:@"04"];
    }else if([dateString isEqualToString:@"May 五月"]){
        return [NSString stringWithFormat:@"05"];
    }else if([dateString isEqualToString:@"Jun 六月"]){
        return [NSString stringWithFormat:@"06"];
    }else if([dateString isEqualToString:@"Jul 七月"]){
        return [NSString stringWithFormat:@"07"];
    }else if([dateString isEqualToString:@"Aug 八月"]){
        return [NSString stringWithFormat:@"08"];
    }else if([dateString isEqualToString:@"Sep 九月"]){
        return [NSString stringWithFormat:@"09"];
    }else if([dateString isEqualToString:@"Oct 十月"]){
        return [NSString stringWithFormat:@"10"];
    }else if([dateString isEqualToString:@"Nov 十一月"]){
        return [NSString stringWithFormat:@"11"];
    }else if([dateString isEqualToString:@"Dec 十二月"]){
        return [NSString stringWithFormat:@"12"];
    }
    return dateString;
}

//当前的数字转换成数字加汉字
- (NSString *)monthSimpleForDateString:(NSString *)dateString{
    //    NSString *year_string=[dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month_string=[dateString substringWithRange:NSMakeRange(5, 2)];
    //    NSString *day_string=[dateString substringWithRange:NSMakeRange(8, 2)];
    
    if ([month_string isEqualToString:@"01"]) {
        return [NSString stringWithFormat:@"1月"];
    } else if([month_string isEqualToString:@"02"]){
        return [NSString stringWithFormat:@"2月"];
    }else if([month_string isEqualToString:@"03"]){
        return [NSString stringWithFormat:@"3月"];
    }else if([month_string isEqualToString:@"04"]){
        return [NSString stringWithFormat:@"4月"];
    }else if([month_string isEqualToString:@"05"]){
        return [NSString stringWithFormat:@"5月"];
    }else if([month_string isEqualToString:@"06"]){
        return [NSString stringWithFormat:@"6月"];
    }else if([month_string isEqualToString:@"07"]){
        return [NSString stringWithFormat:@"7月"];
    }else if([month_string isEqualToString:@"08"]){
        return [NSString stringWithFormat:@"8月"];
    }else if([month_string isEqualToString:@"09"]){
        return [NSString stringWithFormat:@"9月"];
    }else if([month_string isEqualToString:@"10"]){
        return [NSString stringWithFormat:@"10月"];
    }else if([month_string isEqualToString:@"11"]){
        return [NSString stringWithFormat:@"11月"];
    }else if([month_string isEqualToString:@"12"]){
        return [NSString stringWithFormat:@"12月"];
    }
    return nil;
}

//当前的汉字转换成数字
-(NSInteger)gotalStringToInteger:(NSString*)goalString{
    if ([goalString isEqualToString:@"永远"]) {
        return 5*365;
    }else if ([goalString isEqualToString:@"一个月"]){
        return 30;
    }else if ([goalString isEqualToString:@"2个月"]){
        return 61;
    }else if ([goalString isEqualToString:@"3个月"]){
        return 90;
    }else if ([goalString isEqualToString:@"6个月"]){
        return 180;
    }else if ([goalString isEqualToString:@"一年"]){
        return 365;
    }
    return 0;
}

//该方法是在备注里面获得时间字符串的
//将当前字符串格式化成想要的样子
- (NSString *) remarkDateFrom:(NSString *)dateString{
    NSString *year_string=[dateString substringWithRange:NSMakeRange(0, 4)];//拿到年
    NSString *month_string=[dateString substringWithRange:NSMakeRange(5, 2)];//拿到月
    NSString *day_string=[dateString substringWithRange:NSMakeRange(8, 2)];//拿到日
    NSString *week_string=[dateString substringWithRange:NSMakeRange(11, 3)];//拿到当前周
    
    //对当前月进行处理
    if ([month_string isEqualToString:@"01"]) {
        month_string=@"Jan";
    } else if([month_string isEqualToString:@"02"]){
        month_string=@"Feb";
    }else if([month_string isEqualToString:@"03"]){
        month_string=@"Mar";
    }else if([month_string isEqualToString:@"04"]){
        month_string=@"Apr";
    }else if([month_string isEqualToString:@"05"]){
        month_string=@"May";
    }else if([month_string isEqualToString:@"06"]){
        month_string=@"Jun";
    }else if([month_string isEqualToString:@"07"]){
        month_string=@"Jul";
    }else if([month_string isEqualToString:@"08"]){
        month_string=@"Aug";
    }else if([month_string isEqualToString:@"09"]){
        month_string=@"Sep";
    }else if([month_string isEqualToString:@"10"]){
        month_string=@"Oct";
    }else if([month_string isEqualToString:@"11"]){
        month_string=@"Nov";
    }else if([month_string isEqualToString:@"12"]){
        month_string=@"Dec";
    }
    
    //对当前日进行处理
    if ([day_string isEqualToString:@"01"]) {
        day_string=@"1";
    } else if([day_string isEqualToString:@"02"]){
        day_string=@"2";
    }else if([day_string isEqualToString:@"03"]){
        day_string=@"3";
    }else if([day_string isEqualToString:@"04"]){
        day_string=@"4";
    }else if([day_string isEqualToString:@"05"]){
        day_string=@"5";
    }else if([day_string isEqualToString:@"06"]){
        day_string=@"6";
    }else if([day_string isEqualToString:@"07"]){
        day_string=@"7";
    }else if([day_string isEqualToString:@"08"]){
        day_string=@"8";
    }else if([day_string isEqualToString:@"09"]){
        day_string=@"9";
    }
    
    //对字符串进行合成
    return [NSString stringWithFormat:@"%@ %@,%@ %@",month_string,day_string,year_string,week_string];
}

//该方法是用来得到项目详情中项目开始日期字符串的格式化方法
-(NSString *)startDateForm:(NSString *)dateString{
    NSString *year_string=[dateString substringWithRange:NSMakeRange(0, 4)];//拿到年
    NSString *month_string=[dateString substringWithRange:NSMakeRange(5, 1)];//拿到月
    NSString *day_string=[dateString substringWithRange:NSMakeRange(7, 2)];//拿到日
    
    //对当前月进行处理
    if ([month_string isEqualToString:@"1"]) {
        month_string=@"Jan";
    } else if([month_string isEqualToString:@"2"]){
        month_string=@"Feb";
    }else if([month_string isEqualToString:@"3"]){
        month_string=@"Mar";
    }else if([month_string isEqualToString:@"4"]){
        month_string=@"Apr";
    }else if([month_string isEqualToString:@"5"]){
        month_string=@"May";
    }else if([month_string isEqualToString:@"6"]){
        month_string=@"Jun";
    }else if([month_string isEqualToString:@"7"]){
        month_string=@"Jul";
    }else if([month_string isEqualToString:@"8"]){
        month_string=@"Aug";
    }else if([month_string isEqualToString:@"9"]){
        month_string=@"Sep";
    }else if([month_string isEqualToString:@"10"]){
        month_string=@"Oct";
    }else if([month_string isEqualToString:@"11"]){
        month_string=@"Nov";
    }else if([month_string isEqualToString:@"12"]){
        month_string=@"Dec";
    }
//    NSString *result=[NSString stringWithFormat:@"%@ %@,%@",month_string,day_string,year_string];
    
    return [NSString stringWithFormat:@"%@ %@,%@",month_string,day_string,year_string];
}

//NSDate->NSString (延后到当前时间)
+(NSString *)stringFrom:(NSDate*)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString=[dateFormatter stringFromDate:date];//转化后自动得到本地时区的时间字符串，但是如果NSDate时区从格林尼治转化到本地时区，这里得到的字符串是延后8小时的，所以NSDate不进行时区变化
    return dateString;
}

//该方法是用来把2018年1月1日的格式转化为NSDate时间
//NSString->NSdate
-(NSDate*)dateFrom:(NSString*)dateString{
    //对数据库中的字符串进行处理，得到可以被转化的格式字符串
    NSString *yearString=[dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *monthString=[dateString substringWithRange:NSMakeRange(5, 1)];
    NSString *dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
    
    //对月份进行处理
    if ([monthString isEqualToString:@"1"]) {
        if ([[dateString substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"月"]) {
            monthString=@"01";
            //对当前日进行处理
            if ([dayString isEqualToString:@"1"]) {
                if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
                    dayString=@"01";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            } else if([dayString isEqualToString:@"2"]){
                if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
                    dayString=@"02";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            }else if([dayString isEqualToString:@"3"]){
                if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
                    dayString=@"03";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(8, 2)];
                }
            }else if([dayString isEqualToString:@"4"]){
                dayString=@"04";
            }else if([dayString isEqualToString:@"5"]){
                dayString=@"05";
            }else if([dayString isEqualToString:@"6"]){
                dayString=@"06";
            }else if([dayString isEqualToString:@"7"]){
                dayString=@"07";
            }else if([dayString isEqualToString:@"8"]){
                dayString=@"08";
            }else if([dayString isEqualToString:@"9"]){
                dayString=@"09";
            }
        }else{
            monthString=[dateString substringWithRange:NSMakeRange(5, 2)];
            //在这里处理该情况下的日情况
            //对当前日进行处理
            if ([dayString isEqualToString:@"1"]) {
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"01";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(9, 2)];
                }
            } else if([dayString isEqualToString:@"2"]){
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"02";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(9, 2)];
                }
            }else if([dayString isEqualToString:@"3"]){
                if ([[dateString substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"日"]) {
                    dayString=@"03";
                }else{
                    dayString=[dateString substringWithRange:NSMakeRange(9, 2)];
                }
            }else if([dayString isEqualToString:@"4"]){
                dayString=@"04";
            }else if([dayString isEqualToString:@"5"]){
                dayString=@"05";
            }else if([dayString isEqualToString:@"6"]){
                dayString=@"06";
            }else if([dayString isEqualToString:@"7"]){
                dayString=@"07";
            }else if([dayString isEqualToString:@"8"]){
                dayString=@"08";
            }else if([dayString isEqualToString:@"9"]){
                dayString=@"09";
            }
        }
        
    }else if([monthString isEqualToString:@"2"]){
        monthString=@"02";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"3"]){
        monthString=@"03";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"4"]){
        monthString=@"04";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"5"]){
        monthString=@"05";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"6"]){
        monthString=@"06";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"7"]){
        monthString=@"07";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"8"]){
        monthString=@"08";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }else if([monthString isEqualToString:@"9"]){
        monthString=@"09";
        if ([[dateString substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"日"]) {
            dayString=[dateString substringWithRange:NSMakeRange(7, 1)];
        }else{
            dayString=[dateString substringWithRange:NSMakeRange(7, 2)];
        }
    }
    
    ///拼接新的字符串
    dateString=[NSString stringWithFormat:@"%@-%@-%@",yearString,monthString,dayString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:dateString];//得到的是格林尼治时间,需要转化到北京时区的时间
    
    //将格林尼治时间转化为北京时间
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:date];
    
    NSDate *BEIJING_date=[date dateByAddingTimeInterval:interval];//拿到在北京时区下的时间格式
    
    //需要将时间从00:00延后到用户操作时间
    //思路：
    
    return BEIJING_date;
}


//简单把01日期改变成1
-(NSString *)simpleDayFrom:(NSString*)daystring{
    if ([daystring isEqualToString:@"01"]) {
        return @"1";
    }else if ([daystring isEqualToString:@"02"]){
        return @"2";
    }else if ([daystring isEqualToString:@"03"]){
        return @"3";
    }else if ([daystring isEqualToString:@"04"]){
        return @"4";
    }else if ([daystring isEqualToString:@"05"]){
        return @"5";
    }else if ([daystring isEqualToString:@"06"]){
        return @"6";
    }else if ([daystring isEqualToString:@"07"]){
        return @"7";
    }else if ([daystring isEqualToString:@"08"]){
        return @"8";
    }else if ([daystring isEqualToString:@"09"]){
        return @"9";
    }
    return daystring;
}

//简单吧1日期改成01
-(NSString *)simpleDayStringFrom:(NSString*)string{
    if ([string isEqualToString:@"1"]) {
        return @"01";
    }else if ([string isEqualToString:@"2"]){
        return @"02";
    }else if ([string isEqualToString:@"3"]){
        return @"03";
    }else if ([string isEqualToString:@"4"]){
        return @"04";
    }else if ([string isEqualToString:@"5"]){
        return @"05";
    }else if ([string isEqualToString:@"6"]){
        return @"06";
    }else if ([string isEqualToString:@"7"]){
        return @"07";
    }else if ([string isEqualToString:@"8"]){
        return @"08";
    }else if ([string isEqualToString:@"9"]){
        return @"09";
    }
    return string;
}



@end
