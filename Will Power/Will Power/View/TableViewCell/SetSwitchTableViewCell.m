//
//  SetSwitchTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SetSwitchTableViewCell.h"
#import "ColorDefine.h"
#import "SizeDefine.h"

@implementation SetSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.cell_title];
        [self.contentView addSubview:self.cell_switch];
        
    }
    return self;
}


#pragma mark --懒加载

-(UILabel*)cell_title{
    if (!_cell_title) {
        _cell_title=[[UILabel alloc] initWithFrame:CGRectMake(10, (55-40)/2, SCREEN_WIDTH-140,40)];
        _cell_title.text=@"";
        _cell_title.textColor=[UIColor grayColor];
        _cell_title.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    }
    return _cell_title;
}
-(UISwitch*)cell_switch{
    if (!_cell_switch) {
        _cell_switch=[[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, (55-30)/2, 80,30)];
        _cell_switch.on=NO;
    }
    return _cell_switch;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
