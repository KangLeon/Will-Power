//
//  GetColor.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/13.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "GetColor.h"

#define one_BACKGROUND_COLOR [UIColor colorWithRed:62/255.0 green:81/255.0 blue:181/255.0 alpha:1.0]
#define two_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]
#define three_BACKGROUND_COLOR [UIColor colorWithRed:253/255.0 green:112/255.0 blue:137/255.0 alpha:1.0]
#define four_BACKGROUND_COLOR [UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1.0]
#define five_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define sixth_BACKGROUND_COLOR [UIColor colorWithRed:144/255.0 green:162/255.0 blue:255/255.0 alpha:1.0]
#define seven_BACKGROUND_COLOR [UIColor colorWithRed:118/255.0 green:90/255.0 blue:178/255.0 alpha:1.0]
#define eight_BACKGROUND_COLOR [UIColor colorWithRed:118/255.0 green:90/255.0 blue:178/255.0 alpha:1.0]
#define nine_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:84/255.0 blue:65/255.0 alpha:1.0]
#define ten_BACKGROUND_COLOR [UIColor colorWithRed:63/255.0 green:81/255.0 blue:181/255.0 alpha:1.0]


#define eleven_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]
#define twelve_BACKGROUND_COLOR [UIColor colorWithRed:118/255.0 green:90/255.0 blue:178/255.0 alpha:1.0]
#define thirteen_BACKGROUND_COLOR [UIColor colorWithRed:65/255.0 green:195/255.0 blue:87/255.0 alpha:1.0]
#define fourteen_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:143/255.0 alpha:1.0]
#define fifteen_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:179/255.0 blue:42/255.0 alpha:1.0]
#define sixteen_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define seventeen_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:115/255.0 blue:50/255.0 alpha:1.0]
#define eighteen_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:84/255.0 blue:65/255.0 alpha:1.0]
#define nineteen_BACKGROUND_COLOR [UIColor colorWithRed:65/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define twenty_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]


#define twenty_one_BACKGROUND_COLOR [UIColor colorWithRed:142/255.0 green:161/255.0 blue:255/255.0 alpha:1.0]
#define twenty_two_BACKGROUND_COLOR [UIColor colorWithRed:65/255.0 green:195/255.0 blue:86/255.0 alpha:1.0]
#define twenty_three_BACKGROUND_COLOR [UIColor colorWithRed:64/255.0 green:195/255.0 blue:86/255.0 alpha:1.0]
#define twenty_four_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define twenty_five_BACKGROUND_COLOR [UIColor colorWithRed:63/255.0 green:81/255.0 blue:181/255.0 alpha:1.0]
#define twenty_six_BACKGROUND_COLOR [UIColor colorWithRed:0/255.0 green:192/255.0 blue:167/255.0 alpha:1.0]
#define twenty_seven_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define twenty_eight_BACKGROUND_COLOR [UIColor colorWithRed:0/255.0 green:192/255.0 blue:167/255.0 alpha:1.0]
#define twenty_nine_BACKGROUND_COLOR [UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1.0]
#define thirty_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]


#define thirty_one_BACKGROUND_COLOR [UIColor colorWithRed:142/255.0 green:161/255.0 blue:255/255.0 alpha:1.0]
#define thirty_two_BACKGROUND_COLOR [UIColor colorWithRed:253/255.0 green:112/255.0 blue:137/255.0 alpha:1.0]
#define thirty_three_BACKGROUND_COLOR [UIColor colorWithRed:64/255.0 green:195/255.0 blue:86/255.0 alpha:1.0]
#define thirty_four_BACKGROUND_COLOR [UIColor colorWithRed:142/255.0 green:161/255.0 blue:255/255.0 alpha:1.0]
#define thirty_five_BACKGROUND_COLOR [UIColor colorWithRed:253/255.0 green:112/255.0 blue:137/255.0 alpha:1.0]
#define thirty_six_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:115/255.0 blue:50/255.0 alpha:1.0]
#define thirty_seven_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:115/255.0 blue:50/255.0 alpha:1.0]
#define thirty_eight_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:115/255.0 blue:50/255.0 alpha:1.0]
#define thirty_nine_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define forty_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]


#define forty_one_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define forty_two_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:179/255.0 blue:41/255.0 alpha:1.0]
#define forty_three_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:166/255.0 blue:42/255.0 alpha:1.0]
#define forty_four_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]
#define forty_five_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:84/255.0 blue:65/255.0 alpha:1.0]
#define forty_six_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define forty_seven_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define forty_eight_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define forty_nine_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define fifty_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]


#define fifty_one_BACKGROUND_COLOR [UIColor colorWithRed:142/255.0 green:161/255.0 blue:255/255.0 alpha:1.0]
#define fifty_two_BACKGROUND_COLOR [UIColor colorWithRed:118/255.0 green:90/255.0 blue:178/255.0 alpha:1.0]
#define fifty_three_BACKGROUND_COLOR [UIColor colorWithRed:142/255.0 green:161/255.0 blue:255/255.0 alpha:1.0]
#define fifty_four_BACKGROUND_COLOR [UIColor colorWithRed:63/255.0 green:81/255.0 blue:181/255.0 alpha:1.0]
#define fifty_five_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:167/255.0 blue:42/255.0 alpha:1.0]
#define fifty_six_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define fifty_seven_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:83/255.0 blue:65/255.0 alpha:1.0]
#define fifty_eight_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:84/255.0 blue:65/255.0 alpha:1.0]
#define fifty_nine_BACKGROUND_COLOR [UIColor colorWithRed:64/255.0 green:195/255.0 blue:86/255.0 alpha:1.0]
#define sixty_BACKGROUND_COLOR [UIColor colorWithRed:69/255.0 green:157/255.0 blue:243/255.0 alpha:1.0]
#define sixty_one_BACKGROUND_COLOR [UIColor colorWithRed:63/255.0 green:81/255.0 blue:181/255.0 alpha:1.0]
#define sixty_two_BACKGROUND_COLOR [UIColor colorWithRed:253/255.0 green:112/255.0 blue:136/255.0 alpha:1.0]

@implementation GetColor

+(instancetype)shareGetColor{
    static GetColor *getColor=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getColor=[[GetColor alloc] init];
    });
    return getColor;
}

-(UIColor*)getMyColorWith:(NSString *)imageIndex{
    switch ([imageIndex integerValue]) {
        case 1:
            return one_BACKGROUND_COLOR;
            break;
        case 2:
            return two_BACKGROUND_COLOR;
            break;
        case 3:
            return three_BACKGROUND_COLOR;
            break;
        case 4:
            return four_BACKGROUND_COLOR;
            break;
        case 5:
            return five_BACKGROUND_COLOR;
            break;
        case 6:
             return sixth_BACKGROUND_COLOR;
            break;
        case 7:
             return seven_BACKGROUND_COLOR;
            break;
        case 8:
             return eight_BACKGROUND_COLOR;
            break;
        case 9:
             return nine_BACKGROUND_COLOR;
            break;
        case 10:
             return ten_BACKGROUND_COLOR;
            break;
        case 11:
             return eleven_BACKGROUND_COLOR;
            break;
        case 12:
            return twelve_BACKGROUND_COLOR;
            break;
        case 13:
            return thirteen_BACKGROUND_COLOR;
            break;
        case 14:
            return fourteen_BACKGROUND_COLOR;
            break;
        case 15:
            return fifteen_BACKGROUND_COLOR;
            break;
        case 16:
            return sixteen_BACKGROUND_COLOR;
            break;
        case 17:
            return seventeen_BACKGROUND_COLOR;
            break;
        case 18:
            return eighteen_BACKGROUND_COLOR;
            break;
        case 19:
            return nineteen_BACKGROUND_COLOR;
            break;
        case 20:
            return twenty_BACKGROUND_COLOR;
            break;
        case 21:
            return twenty_one_BACKGROUND_COLOR;
            break;
        case 22:
            return twenty_two_BACKGROUND_COLOR;
            break;
        case 23:
            return twenty_three_BACKGROUND_COLOR;
            break;
        case 24:
            return twenty_four_BACKGROUND_COLOR;
            break;
        case 25:
            return twenty_five_BACKGROUND_COLOR;
            break;
        case 26:
            return twenty_six_BACKGROUND_COLOR;
            break;
        case 27:
            return twenty_seven_BACKGROUND_COLOR;
            break;
        case 28:
            return twenty_eight_BACKGROUND_COLOR;
            break;
        case 29:
            return twenty_nine_BACKGROUND_COLOR;
            break;
        case 30:
            return thirty_BACKGROUND_COLOR;
            break;
        case 31:
            return thirty_one_BACKGROUND_COLOR;
            break;
        case 32:
            return thirty_two_BACKGROUND_COLOR;
            break;
        case 33:
            return thirty_three_BACKGROUND_COLOR;
            break;
        case 34:
            return thirty_four_BACKGROUND_COLOR;
            break;
        case 35:
            return thirty_five_BACKGROUND_COLOR;
            break;
        case 36:
            return thirty_six_BACKGROUND_COLOR;
            break;
        case 37:
            return thirty_seven_BACKGROUND_COLOR;
            break;
        case 38:
            return thirty_eight_BACKGROUND_COLOR;
            break;
        case 39:
            return thirty_nine_BACKGROUND_COLOR;
            break;
        case 40:
            return forty_BACKGROUND_COLOR;
            break;
        case 41:
            return forty_one_BACKGROUND_COLOR;
            break;
        case 42:
            return forty_two_BACKGROUND_COLOR;
            break;
        case 43:
            return forty_three_BACKGROUND_COLOR;
            break;
        case 44:
            return forty_four_BACKGROUND_COLOR;
            break;
        case 45:
            return forty_five_BACKGROUND_COLOR;
            break;
        case 46:
            return forty_six_BACKGROUND_COLOR;
            break;
        case 47:
            return forty_seven_BACKGROUND_COLOR;
            break;
        case 48:
            return forty_eight_BACKGROUND_COLOR;
            break;
        case 49:
            return forty_nine_BACKGROUND_COLOR;
            break;
        case 50:
            return fifty_BACKGROUND_COLOR;
            break;
        case 51:
            return fifty_one_BACKGROUND_COLOR;
            break;
        case 52:
            return fifty_two_BACKGROUND_COLOR;
            break;
        case 53:
            return fifty_three_BACKGROUND_COLOR;
            break;
        case 54:
            return fifty_four_BACKGROUND_COLOR;
            break;
        case 55:
            return fifty_five_BACKGROUND_COLOR;
            break;
        case 56:
            return fifty_six_BACKGROUND_COLOR;
            break;
        case 57:
            return fifty_seven_BACKGROUND_COLOR;
            break;
        case 58:
            return fifty_eight_BACKGROUND_COLOR;
            break;
        case 59:
            return fifty_nine_BACKGROUND_COLOR;
            break;
        case 60:
            return sixty_BACKGROUND_COLOR;
            break;
        case 61:
            return sixty_one_BACKGROUND_COLOR;
            break;
        case 62:
            return sixty_two_BACKGROUND_COLOR;
            break;
        default:
            break;
    }
    return nil;
}

@end
