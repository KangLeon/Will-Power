//
//  CheckTableViewCell.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/10.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckTableViewCell : UITableViewCell{
    CAShapeLayer *layer;
}
@property(nonatomic,strong) UILabel *subject_label;//任务标题lable
@property(nonatomic,strong) UILabel *subject_date_label;//任务日期label
@property(nonatomic,strong)UIImageView *subject_imageView;
@property(nonatomic,strong)UIView *check_backView;
@property(nonatomic,assign) BOOL status_check;

-(void)loadCheck;
-(void)removeCheck;
@end
