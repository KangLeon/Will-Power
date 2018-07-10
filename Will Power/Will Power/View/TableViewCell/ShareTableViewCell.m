//
//  ShareTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "ColorDefine.h"
#import "SizeDefine.h"

@interface ShareTableViewCell ()
@property(nonatomic,strong)UIView *content_view;
@property(nonatomic,strong)UIImageView *weChat_imageView;
@property(nonatomic,strong)UIImageView *weibo_imageView;
@property(nonatomic,strong)UIImageView *QQ_imageView;
@end

@implementation ShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.title_label];
        [self addSubview:self.content_view];
    }
    return self;
}

//懒加载
-(UILabel *)title_label{
    if (!_title_label) {
        _title_label=[[UILabel alloc] initWithFrame:CGRectMake(10, (55-40)/2, (SCREEN_WIDTH-20)/2, 40)];
        _title_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
        _title_label.textColor=[UIColor grayColor];
    }
    return _title_label;
}

-(UIView*)content_view{
    if (!_content_view) {
        _content_view=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 0, (SCREEN_WIDTH-20)/2-30, 55)];
        [_content_view addSubview:self.weChat_imageView];
        [_content_view addSubview:self.QQ_imageView];
        [_content_view addSubview:self.weibo_imageView];
    }
    return _content_view;
}

-(UIImageView*)weChat_imageView{
    if (!_weChat_imageView) {
        _weChat_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, (55-30)/2, 30, 30)];
        _weChat_imageView.image=[UIImage imageNamed:@"wechat_image"];
    }
    return _weChat_imageView;
}

-(UIImageView*)QQ_imageView{
    if (!_QQ_imageView) {
        _QQ_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(50+40, (55-30)/2, 30, 30)];
        _QQ_imageView.image=[UIImage imageNamed:@"QQ_image"];
    }
    return _QQ_imageView;
}
-(UIImageView*)weibo_imageView{
    if (!_weibo_imageView) {
        _weibo_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(50+80, (55-30)/2, 30, 30)];
        _weibo_imageView.image=[UIImage imageNamed:@"weibo_image"];
    }
    return _weibo_imageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
