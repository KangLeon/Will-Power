//
//  PickerTableViewCell.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/4.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "PickerTableViewCell.h"
#import "ColorDefine.h"
#import "SizeDefine.h"


@interface PickerTableViewCell ()
@end

@implementation PickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.cell_image];
        [self.contentView addSubview:self.cell_title];
        [self.contentView addSubview:self.cell_time];

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
        _cell_title.text=@"设置坚持目标";
        _cell_title.textColor=[UIColor grayColor];
        _cell_title.font=[UIFont systemFontOfSize:15];
    }
    return _cell_title;
}
-(UILabel*)cell_time{
    if (!_cell_time) {
        _cell_time=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 15, 150,30)];
        _cell_time.textColor=[UIColor grayColor];
        _cell_time.font=[UIFont systemFontOfSize:15];
        _cell_time.textAlignment=NSTextAlignmentCenter;
    }
    return _cell_time;
}




//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.forPicker_view.frame=CGRectMake(0, SCREEN_HEIGHT*0.55, SCREEN_WIDTH, SCREEN_HEIGHT*0.45);
//        NSLog(@"%f,%f",self.forPicker_view.frame.origin.x,self.forPicker_view.frame.origin.y);
//    } completion:nil];
//    // Configure the view for the selected state
//}

@end
