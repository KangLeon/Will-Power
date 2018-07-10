//
//  AddTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AddTableViewCell.h"
#import "ColorDefine.h"
#import "SizeDefine.h"

@implementation AddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.cell_image];
        [self.contentView addSubview:self.cell_title];
        
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
        _cell_title.text=@"点击添加更多时间";
        _cell_title.textColor=[UIColor grayColor];
        _cell_title.font=[UIFont systemFontOfSize:15];
    }
    return _cell_title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
