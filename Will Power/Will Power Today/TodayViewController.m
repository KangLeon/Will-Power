//
//  TodayViewController.m
//  Will Power Today
//
//  Created by 吉腾蛟 on 2018/8/7.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "SizeDefine.h"
#import "ColorDefine.h"

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *sencondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property(nonatomic,strong) UIButton *button_first;
@property(nonatomic,strong) UIButton *button_second;
@property(nonatomic,strong) UIButton *button_third;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    self.preferredContentSize=CGSizeMake(SCREEN_WIDTH-14, 100);
}

-(UIButton *)button_first{
    if (!_button_first) {
        _button_first=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.firstView.frame.size.width, self.firstView.frame.size.height)];
        _button_first.layer.cornerRadius=5;
    }
    return _button_first;
}

-(UIButton *)button_second{
    if (!_button_second) {
        _button_second=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.sencondView.frame.size.width, self.sencondView.frame.size.height)];
        _button_second.layer.cornerRadius=5;
    }
    return _button_second;
}

-(UIButton *)button_third{
    if (!_button_third) {
        _button_third=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.thirdView.frame.size.width, self.thirdView.frame.size.height)];
        _button_third.layer.cornerRadius=5;
    }
    return _button_third;
}

-(void)loadUI{
    self.firstView.frame=CGRectMake(8, 8, (SCREEN_WIDTH-14-8*4)/3, 100);
    self.sencondView.frame=CGRectMake(8+(SCREEN_WIDTH-14-8*4)/3+8, 8, (SCREEN_WIDTH-14-8*4)/3, 100);
    self.thirdView.frame=CGRectMake(8+((SCREEN_WIDTH-14-8*4)/3+8)*2, 8, (SCREEN_WIDTH-14-8*4)/3, 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
