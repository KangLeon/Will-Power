//
//  CountViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/10.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CountViewController.h"
#import "AddSecondViewController.h"
#import "AlertView.h"
#import "ColorDefine.h"
#import <FlatUIKit.h>
#import <ReactiveObjC.h>
#import "TapMusicButton.h"
#import "SizeDefine.h"
#import <Lottie/Lottie.h>

@interface CountViewController ()
@property(nonatomic,strong)AlertView *alertView;
@property(nonatomic,strong)LOTAnimationView *animation;
@property(nonatomic,strong)UIImageView *contact_image;
@end

@implementation CountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navItem];
    [self navTitle];
    [self loadUI];
    
}
-(void)loadUI{
    self.contact_image=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-344)/2, (SCREEN_HEIGHT-407)/2, 344, 407)];
    self.contact_image.image=[UIImage imageNamed:@"contact_image"];
    [self.contact_image addSubview:self.animation];
    [self.view addSubview:self.contact_image];
}

-(LOTAnimationView *)animation{
    if (!_animation) {
        _animation=[LOTAnimationView animationNamed:@"little_girl_jumping_-_loader."];
        _animation.frame=CGRectMake((self.contact_image.frame.size.width-250)/2,0, 250, 250);
        _animation.loopAnimation=true;
        _animation.animationSpeed=1.0;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}
//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
//    titleLabel.text=@"统计";
    titleLabel.textColor=BACKGROUND_COLOR;
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
        self.navigationController.navigationBar.barTintColor=BACKGROUND_COLOR;
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
