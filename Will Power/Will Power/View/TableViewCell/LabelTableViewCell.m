//
//  LabelTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/8.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "LabelTableViewCell.h"

@implementation LabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        self.left_ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 20, 20)];
        
        [titleView addSubview: self.left_ImageView];
        [self addSubview:titleView];
        
        self.cell_label=[[UILabel alloc] initWithFrame:CGRectMake(60, 2, self.frame.size.width, self.frame.size.height)];
        self.cell_label.textColor=[UIColor darkGrayColor];
        self.cell_label.font=[UIFont systemFontOfSize:16];
        self.cell_label.textAlignment=NSTextAlignmentLeft;
        
        [self addSubview:self.cell_label];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
