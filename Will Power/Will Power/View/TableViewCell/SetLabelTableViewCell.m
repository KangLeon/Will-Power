//
//  SetLabelTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/11.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SetLabelTableViewCell.h"
#import "SizeDefine.h"

@implementation SetLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.title_label];
        [self addSubview:self.content_label];
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

-(UILabel*)content_label{
    if (!_content_label) {
        _content_label=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, (55-40)/2, (SCREEN_WIDTH-20)/2-30, 40)];
        _content_label.font=[UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
        _content_label.textAlignment=NSTextAlignmentRight;
        _content_label.textColor=[UIColor grayColor];
    }
    return _content_label;
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
