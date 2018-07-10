//
//  NSDate+LocalDate.m
//  Will Power
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "NSDate+LocalDate.h"

@implementation NSDate (LocalDate)

//好像会发生问题，发生在时间的比较上面
+(instancetype)localdate{
    NSDate *date=[NSDate date];
//    NSTimeZone *zone=[NSTimeZone systemTimeZone];
//    NSInteger interval=[zone secondsFromGMTForDate:date];
    //    NSDate *localDate=[date dateByAddingTimeInterval:interval];
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    NSString* dateString=[dateFormatter stringFromDate:date];//转化后自动得到本地时区的时间字符串，但是如果NSDate时区从格林尼治转化到本地时区，这里得到的字符串是延后8小时的，所以NSDate不进行时区变化
    return date;
}

//这是原先的方法，会发生时间比较错误的问题，
+(instancetype)localdate_4real{
    NSDate *date=[NSDate date];
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:date];
    NSDate *localDate=[date dateByAddingTimeInterval:interval];
    return localDate;//如果比较日期的话，这就是当地时间
}

@end
