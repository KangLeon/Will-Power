//
//  GetColor.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/13.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetColor : NSObject
+(instancetype)shareGetColor;
-(UIColor*)getMyColorWith:(NSString *)imageIndex;
@end
