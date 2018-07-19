//
//  SubjectModel.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/7.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseModel.h"

@interface SubjectModel : BaseModel

//只需要存关联任务id和该id下的所有任务
//id号，主键
@property(nonatomic,assign)NSInteger plus_id;
//关联id号,不是主键
@property(nonatomic,assign)NSInteger subject_id;
//我想要的数据
@property(nonatomic,strong)NSDate *subject_execute;//一个任务只需要关联一个NSDate，

@property(nonatomic,strong)NSMutableArray *add_array;


//方法
+(instancetype)shareSubjectModel;
-(void)insertData;
-(NSInteger)countForData;
-(NSInteger)countForDataAtId:(NSInteger)select_id;
-(NSMutableArray*)selectEveryThing;
-(NSMutableArray*)selectEveryThing:(NSInteger)for_select_id;
@end
