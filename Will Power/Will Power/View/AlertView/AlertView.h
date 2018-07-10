//
//  AlertView.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString*)cancleTitle;
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message  delegate:delegate  cancelButtonTitle:(NSString*)cancleTitle otherButtonTitles:(NSString *)otherTitle;
@end
