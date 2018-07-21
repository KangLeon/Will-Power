//
//  CheckedModel.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/8.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseModel.h"

@interface CheckedModel : BaseModel
//只需要存关联任务id和该id下的所有任务
//用于累加的id号
@property(nonatomic,assign)NSInteger count;
//id号
@property(nonatomic,assign)NSInteger subject_id;
//我想要的数据
@property(nonatomic,strong)NSString *checked;//一个任务只关联一个NSDate

//方法
+(instancetype)shareCheckedModel;
-(void)createDataBase;
-(void)insertData;
-(NSInteger)countForData;
-(NSInteger)countForDataByID:(NSInteger)select_id;
-(void)deleteDataByChecked:(NSString*)date andId:(NSInteger)id;//删除指定id下的数据
-(void)deleteAll;
-(NSMutableArray*)selectEveryThing;
-(NSMutableArray*)selectEveryThingById:(NSInteger)select_id;
@end
