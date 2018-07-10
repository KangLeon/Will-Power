//
//  AddRemarkViewController.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/8.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseViewController.h"
#import <ReactiveObjC.h>

@protocol refreshAllRemark<NSObject>

-(void)refresh;

@end

@interface AddRemarkViewController : BaseViewController

@property(nonatomic,weak)id<refreshAllRemark> delegate;

@end
