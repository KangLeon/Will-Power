//
//  DonateViewController.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/14.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "DonateViewController.h"
#import "ColorDefine.h"
#import "TapMusicButton.h"
#import <ReactiveObjC.h>
#import "SizeDefine.h"
#import "DonateTableViewCell.h"

static NSString *cell_id=@"donate_cell";

@interface DonateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *array;
@property(nonatomic,copy)NSArray *image_array;
@end

@implementation DonateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navItem];
    [self navTitle];
    [self loadUI];
}

#pragma mark 懒加载
-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-359)/2, (SCREEN_HEIGHT-64-542)/2, 359, 542)];
        _imageView.image=[UIImage imageNamed:@"donate_imageView"];
    }
    return _imageView;
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.imageView.frame.size.width, 320)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.backgroundColor=[UIColor clearColor];
        [_tableView registerClass:[DonateTableViewCell class] forCellReuseIdentifier:cell_id];
        _tableView.scrollEnabled=false;
    }
    return _tableView;
}

//配置UI
-(void)loadUI{
    [self.imageView addSubview:self.tableView];
    [self.view addSubview:self.imageView];
    
    self.array=@[@"这个App对我的作用有点小",@"这个App帮助到了我！",@"这个App真的很棒！",@"这个App帮助我完美自控！"];
    self.image_array=@[@"6_yuan_image",@"36_yuan_image",@"96_yuan_image",@"186_yuan_image"];
}

//配置导航栏标题
-(void)navTitle{
    self.navigationController.navigationBar.barTintColor=NAV_BACKGROUND;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    titleLabel.text=@"捐赠";
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
#pragma mark --tableView 数据源与代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DonateTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil) {
        cell=[[DonateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.left_imageView.image=[UIImage imageNamed:@"donate_image"];
    cell.title_label.text=self.array[indexPath.row];
    cell.money_imageView.image=[UIImage imageNamed:self.image_array[indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
