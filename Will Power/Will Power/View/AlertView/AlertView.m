//
//  AlertView.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AlertView.h"
#import <FlatUIKit.h>

@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString*)cancleTitle{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil cancelButtonTitle:cancleTitle
                                                otherButtonTitles:nil, nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message  delegate:(id<FUIAlertViewDelegate>)delegate  cancelButtonTitle:(NSString*)cancleTitle otherButtonTitles:(NSString *)otherTitle{
    self.myAlertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:delegate cancelButtonTitle:cancleTitle
                                                otherButtonTitles:otherTitle, nil];
    self.myAlertView.titleLabel.textColor = [UIColor cloudsColor];
    self.myAlertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    self.myAlertView.messageLabel.textColor = [UIColor cloudsColor];
    self.myAlertView.messageLabel.font = [UIFont flatFontOfSize:14];
    self.myAlertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    self.myAlertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    self.myAlertView.defaultButtonColor = [UIColor cloudsColor];
    
    self.myAlertView.defaultButtonShadowColor = [UIColor asbestosColor];
    self.myAlertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    self.myAlertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [self.myAlertView show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
