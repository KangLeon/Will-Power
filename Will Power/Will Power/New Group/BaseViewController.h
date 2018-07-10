//
//  BaseViewController.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(NSString *)stringFrom:(NSDate*)date;
-(NSDate*)dateFrom:(NSString*)dateString;
-(void)startNotifi;
-(void)removePending:(NSString*)identi;
@end
