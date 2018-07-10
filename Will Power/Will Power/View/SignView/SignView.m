//
//  SignView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/27.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SignView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <Masonry.h>

@interface SignView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView *timeSignPicker;//设置提醒时间的

@property(nonatomic,strong)NSMutableArray *signHours_array;//几点
@property(nonatomic,strong)NSMutableArray *signMinutes_array;//几分的时候

@property(nonatomic,assign)NSInteger selectedRow;

@property(nonatomic,copy)NSString *signHour_str;
@property(nonatomic,copy)NSString *signMinute_str;



@end

@implementation SignView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //选取器底部视图
        [self addSubview:self.forPicker_view];
        
        //签到时间的
        self.timeSignPicker.dataSource=self;
        self.timeSignPicker.delegate=self;
        
        
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

#pragma mark 懒加载部分
#pragma mark --签到提醒时间

-(UIView *)forPicker_view{
    if (!_forPicker_view) {
        _forPicker_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.45)];
        _forPicker_view.backgroundColor=PICKER_BACKGROUND;
        [_forPicker_view addSubview:self.timeSignPicker];
        [_forPicker_view addSubview:self.pickerHeader_sign];
        [_forPicker_view addSubview:self.finishPickerButton];
    }
    return _forPicker_view;
}

-(UIPickerView *)timeSignPicker{
    if (!_timeSignPicker) {
        _timeSignPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 60)];//这里可不可以访问_forPicker_view？
        _timeSignPicker.backgroundColor=PICKER_BACKGROUND;
    }
    return _timeSignPicker;
}


-(UIView *)pickerHeader_sign{
    if (!_pickerHeader_sign) {
        _pickerHeader_sign=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _pickerHeader_sign.backgroundColor=PICKER_VIEW_BACKGROUND;
        [_pickerHeader_sign addSubview:self.pickerSignLabel];
        [_pickerHeader_sign addSubview:self.cancelButton];
    }
    return _pickerHeader_sign;
}

-(TapMusicButton *)finishPickerButton{
    if (!_finishPickerButton) {
        _finishPickerButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(20, _forPicker_view.frame.size.height-130, SCREEN_WIDTH-40, 58)];
        
        [_finishPickerButton setImage:[UIImage imageNamed:@"finish_button_image"] forState:UIControlStateNormal];
    }
    return _finishPickerButton;
}

-(UILabel *)pickerSignLabel{
    if (!_pickerSignLabel) {
        _pickerSignLabel=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 45)];
        _pickerSignLabel.text=@"签到提醒时间";
        _pickerSignLabel.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        _pickerSignLabel.textAlignment=NSTextAlignmentCenter;
        _pickerSignLabel.textColor=[UIColor blackColor];
    }
    return _pickerSignLabel;
}

-(TapMusicButton*)cancelButton{
    if (!_cancelButton) {
        _cancelButton=[[TapMusicButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [_cancelButton setImage:[UIImage imageNamed:@"cancel_picker_image"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}


-(NSMutableArray*)signHours_array{
    if (!_signHours_array) {
        _signHours_array=[[NSMutableArray alloc] init];
        for (int i=0; i<24; i++) {
            NSString *hour_string=[NSString stringWithFormat:@"%d点",i];
            [_signHours_array addObject:hour_string];
        }
    }
    return _signHours_array;
}
-(NSMutableArray*)signMinutes_array{
    if (!_signMinutes_array) {
        _signMinutes_array=[[NSMutableArray alloc] init];
        for (int i=0; i<60; i++) {
            NSString *minute_string=[NSString stringWithFormat:@"%d分",i];
            [_signMinutes_array addObject:minute_string];
        }
    }
    return _signMinutes_array;
}
-(NSString *)signHour_str{
    if (!_signHour_str) {
        _signHour_str=[self.signHours_array objectAtIndex:0];
    }
    return _signHour_str;
}
-(NSString *)signMinute_str{
    if (!_signMinute_str) {
        _signMinute_str=[self.signMinutes_array objectAtIndex:0];
    }
    return _signMinute_str;
}

#pragma mark --datasource PickerView 数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        if (component==0) {
            return 24;
        }else{
            return 60;
        }
    return 0;
  
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //选择签到时间的选取器
        UIView *line;
        
        for(UIView *speartorView in pickerView.subviews)
        {
            if (speartorView.frame.size.height < 1)//取出分割线view
            {
                line=speartorView;
                speartorView.backgroundColor =[UIColor clearColor];
            }
        }
        
        UILabel *reuse_label=(UILabel*)view;
        if (reuse_label==nil) {
            if (component==0) {
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 80, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.signHours_array[row];
                
                if (self.selectedRow==row) {
                    
                    //这一部分是为了给Picker选中行设置背景颜色的
                    NSArray *subviews =pickerView.subviews;
                    if (!(subviews.count > 0)) {
                        
                    }
                    NSArray *coloms = subviews.firstObject;
                    if (coloms) {
                        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
                        if (subviewCache.count > 0) {
                            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                            if (middleContainerView) {
                                middleContainerView.backgroundColor = [UIColor whiteColor];
                            }
                        }
                    }
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                        
                    }];
                }
                
                return reuse_label;
            }else{
                reuse_label=[[UILabel alloc] init];
                reuse_label.frame=CGRectMake(0, 0, 64, 55);
                reuse_label.font=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
                reuse_label.textColor=[UIColor grayColor];
                reuse_label.text=self.signMinutes_array[row];
                if (self.selectedRow==row) {
                    [UIView animateWithDuration:2 animations:^{
                        reuse_label.textColor=PICKER_TITLE;
                        reuse_label.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                    }];
                }
                
                return reuse_label;
            }
        }
    
      return reuse_label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
       //设置签到提醒时间的

        
        //传值给自己的viewcontroller
        if (component==0) {
            self.signHour_str=[self.signHours_array objectAtIndex:row];
        }else{
            self.signMinute_str=[self.signMinutes_array objectAtIndex:row];
        }
        self.signString=[NSString stringWithFormat:@"%@%@",self.signHour_str,self.signMinute_str];
    
    self.selectedRow=row;
    [pickerView reloadComponent:component];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 60;
}


//#pragma mark --Masonry布局约束相关
-(void)updateConstraints{
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    //1.提醒时间的布局约束
    [self.timeSignPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view.mas_left);
        make.top.equalTo(weakSelf.forPicker_view.mas_top).offset(50);
        make.right.equalTo(weakSelf.forPicker_view.mas_right);
        make.bottom.equalTo(weakSelf.forPicker_view.mas_bottom).offset(-130);
    }];
    
    
    [self.finishPickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.forPicker_view.mas_left).offset(20);
        make.right.equalTo(weakSelf.forPicker_view.mas_right).offset(-20);
        make.top.equalTo(weakSelf.forPicker_view.mas_bottom).offset(-130);
    }];
}

@end
