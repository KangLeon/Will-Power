//
//  TextFieldTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "TextFieldTableViewCell.h"


@interface TextFieldTableViewCell ()
@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        self.left_ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 30, 30)];
        
        [titleView addSubview: self.left_ImageView];
        
        self.cellTextField=[[UITextField alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width, self.frame.size.height)];
        self.cellTextField.leftView=titleView;
        
        self.cellTextField.leftViewMode=UITextFieldViewModeAlways;
        
        [self addSubview:self.cellTextField];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
