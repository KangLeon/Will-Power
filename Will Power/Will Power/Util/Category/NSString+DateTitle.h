//
//  NSString+DateTitle.h
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateTitle)
-(NSString *)monthForDateString:(NSString *)dateString;
- (NSString *)monthSimpleForDateString:(NSString *)dateString;
-(NSInteger)gotalStringToInteger:(NSString*)goalString;
- (NSString *)remarkDateFrom:(NSString *)dateString;
-(NSString *)startDateForm:(NSString *)dateString;
-(NSDate*)dateFrom:(NSString*)dateString;
+(NSString *)stringFrom:(NSDate*)date;
-(NSString *)simpleDayFrom:(NSString*)daystring;
-(NSString *)simpleDayStringFrom:(NSString*)string;
-(NSString *)monthfirstString:(NSString*)dateString;
@end
