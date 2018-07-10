//
//  SwitchTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SwitchTableViewCell.h"
#import "ColorDefine.h"
#import "SizeDefine.h"

@implementation SwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.cell_image];
        [self.contentView addSubview:self.cell_title];
        [self.contentView addSubview:self.cell_switch];
        
    }
    return self;
}


#pragma mark --懒加载



-(UIImageView*)cell_image{
    if (!_cell_image) {
        _cell_image=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15,30 ,30)];
    }
    return _cell_image;
}
-(UILabel*)cell_title{
    if (!_cell_title) {
        _cell_title=[[UILabel alloc] initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH-140,30)];
        _cell_title.text=@"提醒已经开启";
        _cell_title.textColor=[UIColor grayColor];
        _cell_title.font=[UIFont systemFontOfSize:15];
    }
    return _cell_title;
}
-(UISwitch*)cell_switch{
    if (!_cell_switch) {
        _cell_switch=[[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 15, 80,30)];
        _cell_switch.on=NO;
    }
    return _cell_switch;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
