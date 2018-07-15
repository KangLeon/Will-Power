//
//  CalenderCollectionViewCell.m
//  Will Power
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CalenderCollectionViewCell.h"
#import "ColorDefine.h"

@implementation CalenderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //在这里设置的目的是为了可以每次都刷新所有边框的设置
        [self addSubview:self.calenderTitle];
    }
    return self;
}

-(UILabel *)calenderTitle{
    if (!_calenderTitle) {
        _calenderTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _calenderTitle.textAlignment=NSTextAlignmentCenter;
        _calenderTitle.textColor=[UIColor grayColor];
        _calenderTitle.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        _calenderTitle.adjustsFontSizeToFitWidth=YES;
    }
    return _calenderTitle;
}

@end
