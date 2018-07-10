//
//  SizeDefine.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#ifndef SizeDefine_h
#define SizeDefine_h

//屏幕宽
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width

//屏幕高
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

//判断版本是否为大于IOS 10.0
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)
#define IS_IOS10_OR_ABOVE SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")


#endif /* SizeDefine_h */
