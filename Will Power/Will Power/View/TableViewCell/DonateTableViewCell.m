//
//  DonateTableViewCell.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/14.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "DonateTableViewCell.h"
@interface DonateTableViewCell ()

@end

@implementation DonateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加视图
        [self.contentView addSubview:self.left_imageView];
        [self.contentView addSubview:self.title_label];
        [self.contentView addSubview:self.money_imageView];
    }
    return self;
}

#pragma mark --懒加载

-(UIImageView *)left_imageView{
    if (!_left_imageView) {
        _left_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        _left_imageView.image=[UIImage imageNamed:@"donate_image"];
    }
    return _left_imageView;
}
-(UILabel *)title_label{
    if (!_title_label) {
        _title_label=[[UILabel alloc] initWithFrame:CGRectMake(90, 13, 200, 20)];
        _title_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightThin];
        _title_label.textColor=[UIColor blackColor];
        _title_label.textAlignment=NSTextAlignmentLeft;
    }
    return _title_label;
}
-(UIImageView*)money_imageView{
    if (!_money_imageView) {
        _money_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(90, 36, 80, 34)];
    }
    return _money_imageView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
