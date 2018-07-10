//
//  AboutViewController.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/26.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AboutViewController.h"
#import "ColorDefine.h"
#import "TapMusicButton.h"
#import <ReactiveObjC.h>
#import "SizeDefine.h"
#import "UIImage+Round.h"

@interface AboutViewController ()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *back_image;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navItem];
    [self navTitle];
    [self loadUI];
}

#pragma mark 懒加载
-(UIImageView*)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH, SCREEN_WIDTH)];
        _iconImageView.image=[[UIImage imageNamed:@"414"] hyb_imageWithCornerRadius:8.0];
    }
    return _iconImageView;
}
-(UILabel*)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 414, 200, 70)];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];// app名称
        if (app_Name) {
            
        }else{
            app_Name=@"Will Power";
        }
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// app版本
        _contentLabel.text=[NSString stringWithFormat:@"%@ v%@",app_Name,app_Version];
        _contentLabel.font=[UIFont systemFontOfSize:29.0 weight:UIFontWeightThin];
        _contentLabel.textColor=[UIColor whiteColor];
        _contentLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _contentLabel;
}
-(UIImageView *)back_image{
    if (!_back_image) {
        _back_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _back_image.image=[UIImage imageNamed:@"coffee_image"];
    }
    return _back_image;
}

//配置UI
-(void)loadUI{
    [self.view addSubview:self.back_image];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.contentLabel];
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"关于Will Power";
    titleLabel.textColor=BACKGROUND_COLOR;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBar.layer.cornerRadius=17;
}

//导航栏按钮
-(void)navItem{
    //左上角按钮
    TapMusicButton *barButton_left=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, 52, 41)];
    barButton_left.backgroundColor=[UIColor clearColor];
    [barButton_left setImage:[UIImage imageNamed:@"back_image"] forState:UIControlStateNormal];
    [[barButton_left rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"左上角的我被惦记了");
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    UIBarButtonItem *barButtonItem_left=[[UIBarButtonItem alloc] initWithCustomView:barButton_left];
    self.navigationItem.leftBarButtonItem=barButtonItem_left;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
