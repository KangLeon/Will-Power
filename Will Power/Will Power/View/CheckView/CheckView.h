//
//  CheckView.h
//  Will Power
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckView : UIView
{
    CAShapeLayer *layer;
}
@property(nonatomic,strong)UIButton *check_button;
@property(nonatomic,strong)UIImageView *check_imageView;
@property(nonatomic,strong)UILabel *check_title;
@property(nonatomic,strong)UILabel *check_description;
@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,strong)UIView *check_backView;

-(void)loadCheck;
-(void)removeCheck;

@end
