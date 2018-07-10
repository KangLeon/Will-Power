//
//  LaunchViewController.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/25.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "LaunchViewController.h"
#import <Lottie/Lottie.h>
#import "SizeDefine.h"
#import "ColorDefine.h"
#import "HomeViewController.h"

@interface LaunchViewController ()
@property(nonatomic,strong)LOTAnimationView *animation;
@property(nonatomic,strong)UILabel *label_title;
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置willpower的动画
    
    self.view.backgroundColor=LAUNCH_BLACK;
    
    // Do any additional setup after loading the view.
    self.animation=[LOTAnimationView animationNamed:@"cubes"];
    self.animation.frame=CGRectMake((SCREEN_WIDTH-100)/2,150, 100, 200);
    self.animation.loopAnimation=true;
    self.animation.contentMode=UIViewContentModeScaleToFill;
    self.animation.animationSpeed=1.0;
    [self.animation playWithCompletion:^(BOOL animationFinished) {
        
    }];
    
    [self.view addSubview:self.animation];
    
    
    //一秒后显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //添加label 到页面上
        self.label_title=[[UILabel alloc] initWithFrame:CGRectMake(20, 400, SCREEN_WIDTH-40, 50)];
        self.label_title.text=@"Will    Power";
        self.label_title.backgroundColor=[UIColor clearColor];
        self.label_title.font=[UIFont systemFontOfSize:35.0 weight:UIFontWeightThin];
        self.label_title.textColor=[UIColor whiteColor];
        self.label_title.textAlignment=NSTextAlignmentCenter;
        self.label_title.alpha=0.0;
        [self.view addSubview:self.label_title];
        
        
        [UIView animateWithDuration:1.0 animations:^{
            self.label_title.alpha=1.0;
        }];
        //4秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2.0 animations:^{
                self.label_title.alpha=0.0;
            }];
            //一秒后跳转到首页
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:[[HomeViewController alloc] init] animated:true];
            });
        });
    });

    NSLog(@"你好");
}
#pragma mark --生命周期方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果是根视图控制器就把导航栏颜色置为蓝色，其他的页面不影响
    self.navigationController.navigationBar.barTintColor=LAUNCH_BLACK;
    //1.首先把navigationController的Translucent取消勾选，颜色与背景色一致
    //2.然后同多下面一行代码，取消当行懒分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
