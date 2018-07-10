//
//  SignView.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/27.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapMusicButton.h"

@interface SignView : UIView

//提醒时间的
@property(nonatomic,strong)UIView *forPicker_view;
@property(nonatomic,strong)UILabel *pickerSignLabel;
@property(nonatomic,strong)TapMusicButton *cancelButton;
@property(nonatomic,strong)TapMusicButton *finishPickerButton;

@property(nonatomic,strong)UIView *pickerHeader_sign;//提醒时间的选取器头

@property(nonatomic,copy)NSString *signString;
@end
