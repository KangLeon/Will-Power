//
//  NotifiModel.h
//  Will Power
//
//  Created by jitengjiao      on 2018/4/5.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseModel.h"

@interface NotifiModel : BaseModel
@property(nonatomic,strong) NSMutableArray *notifi_date_array;

//id号
@property(nonatomic,assign)NSInteger alarm_id;
//关联项目的ID号
@property(nonatomic,assign)NSInteger subject_id;

@property(nonatomic,copy)NSString *alarm_day;
@property(nonatomic,copy)NSString *alarm_hour;
@property(nonatomic,copy)NSString *alarm_minute;

+(instancetype)notifiModel;
-(void)insertData;
//-(void)deleteDataByTitle:(NSInteger )id;
-(NSInteger)countForData;
-(NSMutableArray*)selectEveryThing;

//只查找关联任务的项
-(NSMutableArray*)selectItemsIn:(NSInteger)subject_id;//只查找出与当前任务相关的所有的提醒项
-(NSInteger)countForDataIn:(NSInteger)subject_id;//计算与当前任务相关的所有的提醒项的树木
@end
