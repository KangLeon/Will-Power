//
//  SubSubjectcountViewController.h
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseViewController.h"
#import "CalendenView.h"

@interface SubSubjectcountViewController : BaseViewController

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSIndexPath *indexPath;
@property(nonatomic,strong)CalendenView *view_calender;

@end
