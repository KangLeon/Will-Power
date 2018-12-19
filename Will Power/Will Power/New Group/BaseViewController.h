//
//  BaseViewController.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

//左右导航按钮回调
typedef void(^PassAction)(UIButton *button);
//刷新按钮回调
typedef void(^RefreshAction)(void);
//传值回调
typedef void(^PassStr)(NSString *);

@interface BaseViewController : UIViewController

@property (copy, nonatomic) PassAction leftItemAction;
@property (copy, nonatomic) PassAction rightItemAction;
@property (copy, nonatomic) RefreshAction refreshAction;
@property (copy, nonatomic) PassStr passStr;

//日期字符串的转换
-(NSString *)stringFrom:(NSDate*)date;
-(NSDate*)dateFrom:(NSString*)dateString;
//确立和移除通知
-(void)startNotifi;
-(void)removePending:(NSString*)identi;

@end
