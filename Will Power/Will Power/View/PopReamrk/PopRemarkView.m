//
//  PopRemarkView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/10.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "PopRemarkView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"

@interface PopRemarkView ()

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UIView *gray_view;
@property(nonatomic,strong)UIView *content_view;

@property(nonatomic,strong)UILabel *title_label;

@property(nonatomic,strong)UILabel *subject_label;

@property(nonatomic,strong)UIButton *add_remark;
@property(nonatomic,strong)UIButton *complete_remark;
@property(nonatomic,strong)UIButton *delete_complete_remark;

@end

@implementation PopRemarkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}
-(void)loadUI{
    [self.content_view addSubview:self.title_label];
    [self.content_view addSubview:self.subject_label];
    
    [self.backView addSubview:self.gray_view];
    [self.backView addSubview:self.content_view];
  
    [self addSubview:self.backView];
}

//懒加载
-(UIView *)backView{
    if (!_backView) {
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15];
    }
    return _backView;
}
-(UIView*)gray_view{
    if (!_gray_view) {
        _gray_view=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-self.content_view.frame.size.width)/2, (SCREEN_HEIGHT-self.content_view.frame.size.height-3)/2+SCREEN_HEIGHT, self.content_view.frame.size.width, self.content_view.frame.size.height+3)];
        _gray_view.backgroundColor=[UIColor grayColor];
        _gray_view.layer.cornerRadius=9;
    }
    return _gray_view;
}
-(UIView*)content_view{
    if (!_content_view) {
        _content_view=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2, (SCREEN_HEIGHT-400)/2+SCREEN_HEIGHT, 300, 400)];
        _content_view.backgroundColor=[UIColor whiteColor];
        _content_view.layer.cornerRadius=9;
    }
    return _content_view;
}
-(UILabel*)title_label{
    if (!_title_label) {
        _title_label=[[UILabel alloc] initWithFrame:CGRectMake((300-10)/2, 20, 300-10, 40)];
        _title_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightBlack];
        _title_label.textColor=[UIColor grayColor];
        _title_label.text=@"项目记录";
        _title_label.textAlignment=NSTextAlignmentCenter;
    }
    return _title_label;
}
-(UILabel *)subject_label{
    if (!_subject_label) {
        _subject_label=[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 180, 38)];
        //  text 又通知传送的来值设置
        _subject_label.textAlignment=NSTextAlignmentCenter;
        _subject_label.textColor=[UIColor blackColor];
        _subject_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
    }
    return _subject_label;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
