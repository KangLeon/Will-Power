//
//  AddModel.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/4/26.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseModel.h"
#import "NotifiModel.h"

@interface AddModel : BaseModel
//id号
@property(nonatomic,assign)NSInteger subject_id;
//我想要的数据
@property(nonatomic,copy)NSString *subject_title;
@property(nonatomic,copy)NSString *subject_get;
@property(nonatomic,copy)NSString *subject_love_get;
@property(nonatomic,copy)NSString *subject_best_me;
//我要做的数据
@property(nonatomic,assign)NSInteger goal_total;//总共坚持多少天
@property(nonatomic,strong)NSString *start_date;//开始时间
//@property(nonatomic,strong)NotifiModel *notifiModel;//提醒时间
//需要拒绝的东西数据
@property(nonatomic,copy)NSString *reject_things;
@property(nonatomic,copy)NSString *reject_people;
@property(nonatomic,copy)NSString *reject_time;
@property(nonatomic,copy)NSString *reject_thought;
//添加奖励
@property(nonatomic,copy)NSString *reward;

//方法
+(instancetype)shareAddMode;
-(void)insertData;//插入数据
-(NSInteger)countForData;//查询数据库中有多少条数据
-(NSMutableArray*)selectEveryThing;//查询出数据库中所有数据
-(void)updateDataWithSubject_title:(NSString *)title subject_get:(NSString *)get subject_love_get:(NSString *)love subject_best_me:(NSString *)best goal_total:(NSInteger)goal start_date:(NSString*)date reject_things:(NSString *)things reject_people:(NSString *)people reject_time:(NSString*)time reject_thought:(NSString*)thought reward:(NSString*)reward where:(NSInteger)id;//修改特定id下的数据
-(void)deleteDataByTitle:(NSString *)title;//删除在指定title下的数据

@end
