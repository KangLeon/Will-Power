//
//  AddFirstModel.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseModel.h"

@interface AddFirstModel : BaseModel
//我想要的数据
@property(nonatomic,copy)NSString *subject_title;
@property(nonatomic,copy)NSString *subject_get;
@property(nonatomic,copy)NSString *subject_love_get;
@property(nonatomic,copy)NSString *subject_best_me;
//我要做的数据
@property(nonatomic,assign)NSInteger goal_total;//总共坚持多少天
@property(nonatomic,strong)NSDate *start_date;//开始时间
@property(nonatomic,strong)NSDate *clock_date;//提醒时间
//需要拒绝的东西数据
@property(nonatomic,copy)NSString *reject_things;
@property(nonatomic,copy)NSString *reject_people;
@property(nonatomic,copy)NSString *reject_time;
@property(nonatomic,copy)NSString *reject_thought;
//添加奖励
@property(nonatomic,copy)NSString *reward;

@end
