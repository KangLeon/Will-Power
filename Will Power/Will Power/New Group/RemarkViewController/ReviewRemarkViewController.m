//
//  ReviewRemarkViewController.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/14.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "ReviewRemarkViewController.h"
#import "AlertView.h"
#import "ColorDefine.h"
#import <FlatUIKit.h>
#import <ReactiveObjC.h>
#import "TapMusicButton.h"
#import "SizeDefine.h"
#import "RemarkModel.h"

@interface ReviewRemarkViewController ()
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *title_label;
@property(nonatomic,strong)UIImageView *heart_image;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *time_label;
@property(nonatomic,strong)UILabel *content_label;
@end

@implementation ReviewRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNav];
    [self loadUI];
}
-(void)loadUI{
    
    [self.backView addSubview:self.title_label];
    [self.backView addSubview:self.heart_image];
    [self.backView addSubview:self.time_label];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-40, 1)];
    line.backgroundColor=[UIColor grayColor];
    
    [self.backView addSubview:line];
    
    [self.backView addSubview:self.textView];
    [self.backView addSubview:self.content_label];
    
    [self.view addSubview:self.backView];
}

#pragma mark 懒加载部分
-(UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH-20, SCREEN_HEIGHT-116)];
        _backView.backgroundColor=[UIColor whiteColor];
        _backView.layer.cornerRadius=12;
    }
    return _backView;
}
-(UILabel*)title_label{
    if (!_title_label) {
        _title_label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 40)];
        _title_label.text=[NSString stringWithFormat:@"标题 : %@",[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:self.select_index] objectForKey:@"remark_title"]];
        _title_label.numberOfLines=0;
        _title_label.textColor=[UIColor grayColor];
        _title_label.textAlignment=NSTextAlignmentLeft;
        _title_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        _title_label.adjustsFontSizeToFitWidth=YES;
    }
    return _title_label;
}
-(UILabel*)time_label{
    if (!_time_label) {
        _time_label=[[UILabel alloc] initWithFrame:CGRectMake(250, 10, SCREEN_WIDTH-20-250, 40)];
        _time_label.text=[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:self.select_index] objectForKey:@"remark_date"];
        _time_label.numberOfLines=0;
        _time_label.textColor=[UIColor grayColor];
        _time_label.textAlignment=NSTextAlignmentCenter;
        _time_label.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightThin];
        _time_label.adjustsFontSizeToFitWidth=YES;
    }
    return _time_label;
}
-(UILabel*)content_label{
    if (!_content_label) {
        _content_label=[[UILabel alloc] initWithFrame:CGRectMake(10, 70, 180, 30)];
        _content_label.text=@"正文 : ";
        _content_label.textColor=[UIColor grayColor];
        _content_label.textAlignment=NSTextAlignmentLeft;
        _content_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        _content_label.adjustsFontSizeToFitWidth=YES;
    }
    return _content_label;
}
-(UIImageView*)heart_image{
    if (!_heart_image) {
        _heart_image=[[UIImageView alloc] initWithFrame:CGRectMake(240, 17.5, 25, 25)];
        NSString *heartString=[NSString stringWithFormat:@"%@",[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:self.select_index] objectForKey:@"remark_heart"]];
        if ([heartString isEqualToString:@"一般"]) {
            _heart_image.image=[UIImage imageNamed:@"heart_normal_image"];
        }else if ([heartString isEqualToString:@"不开心"]){
            _heart_image.image=[UIImage imageNamed:@"heart_sad_image"];
        }else if ([heartString isEqualToString:@"开心"]){
            _heart_image.image=[UIImage imageNamed:@"heart_smile_image"];
        }
        
    }
    return _heart_image;
}
-(UITextView*)textView{
    if (!_textView) {
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 110, SCREEN_WIDTH-40, SCREEN_HEIGHT-116-110 )];
        _textView.text=[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:self.select_index] objectForKey:@"remark_content"];
        _textView.textColor=[UIColor grayColor];
        _textView.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightThin];
    }
    return _textView;
}

//配置导航栏相关
-(void)loadNav{
    if (kDevice_Is_iPhoneX) {
        UIView *nav_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
        nav_view.backgroundColor=NAV_BACKGROUND;
        
        TapMusicButton *left_back_button=[[TapMusicButton alloc] init];
        left_back_button.frame=CGRectMake(22, 42, 52, 41);
        left_back_button.backgroundColor=[UIColor clearColor];
        [left_back_button setImage:[UIImage imageNamed:@"back_image"] forState:UIControlStateNormal];
        [[left_back_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"左上角的我被惦记了");
            [self dismissViewControllerAnimated:true completion:^{
                
            }];
        }];
        
        UILabel *title_label=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 55, 150, 20)];
        title_label.text=[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:self.select_index] objectForKey:@"remark_title"];
        title_label.textColor=BACKGROUND_COLOR;
        title_label.textAlignment=NSTextAlignmentCenter;
        title_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
        
        
        [nav_view addSubview:title_label];
        [nav_view addSubview:left_back_button];
        [self.view addSubview:nav_view];
    }else{
        UIView *nav_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        nav_view.backgroundColor=NAV_BACKGROUND;
        
        TapMusicButton *left_back_button=[[TapMusicButton alloc] init];
        left_back_button.frame=CGRectMake(22, 22, 52, 41);
        left_back_button.backgroundColor=[UIColor clearColor];
        [left_back_button setImage:[UIImage imageNamed:@"back_image"] forState:UIControlStateNormal];
        [[left_back_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"左上角的我被惦记了");
            [self dismissViewControllerAnimated:true completion:^{
                
            }];
        }];
        
        UILabel *title_label=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 35, 150, 20)];
        title_label.text=[[[[RemarkModel shareAddMode] selectEveryThing] objectAtIndex:self.select_index] objectForKey:@"remark_title"];
        title_label.textColor=BACKGROUND_COLOR;
        title_label.textAlignment=NSTextAlignmentCenter;
        title_label.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
        
        
        [nav_view addSubview:title_label];
        [nav_view addSubview:left_back_button];
        [self.view addSubview:nav_view];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
