//
//  MusicSelect.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "MusicSelect.h"
#import "ColorDefine.h"


static NSString *cell_id=@"music_Cell";

@interface MusicSelect ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)NSArray *musicArray;
@property(nonatomic,copy)NSArray *singerArray;

@property(nonatomic,strong)UIView *fringe_view;


@end

@implementation MusicSelect

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

-(void)loadUI{
    [self addSubview:self.backView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.fringe_view];
    [self addSubview:self.close_button];
}
#pragma mark 懒加载部分
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-150)/2, 5, 150, 50)];
        _titleLabel.text=@"音乐列表";
        _titleLabel.textColor=[UIColor grayColor];
        _titleLabel.font=[UIFont systemFontOfSize:22.0 weight:UIFontWeightThin];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIView*)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backView.backgroundColor=[UIColor whiteColor];
        _backView.layer.cornerRadius=12.0;
        _backView.layer.borderColor=[UIColor darkGrayColor].CGColor;
        _backView.layer.borderWidth=2;
        [_backView addSubview:self.musicTableView];
    }
    return _backView;
}
-(TapMusicButton *)close_button{
    if (!_close_button) {
        _close_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [_close_button setImage:[UIImage imageNamed:@"close_music_image"] forState:UIControlStateNormal];
    }
    return _close_button;
}
-(UIView *)fringe_view{
    if (!_fringe_view) {
        _fringe_view=[[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-90)/2, 0, 90, 4)];
        _fringe_view.backgroundColor=[UIColor darkGrayColor];
    }
    return _fringe_view;
}
-(UITableView*)musicTableView{
    if (!_musicTableView) {
        _musicTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-70)];
        _musicTableView.backgroundColor=[UIColor clearColor];
        _musicTableView.layer.cornerRadius=12.0;
        _musicTableView.dataSource=self;
    }
    return _musicTableView;
}
-(NSArray*)musicArray{
    if (!_musicArray) {
        _musicArray=@[@"Intro XX"];
    }
    return _musicArray;
}
-(NSArray*)singerArray{
    if (!_singerArray) {
        _singerArray=@[@"The XX"];
    }
    return _singerArray;
}

#pragma  mark --datasource delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=self.musicArray[indexPath.row];
    cell.detailTextLabel.text=self.singerArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
