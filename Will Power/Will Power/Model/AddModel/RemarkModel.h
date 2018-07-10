//
//  RemarkModel.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/1.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "BaseModel.h"

@interface RemarkModel : BaseModel

//id号
@property(nonatomic,assign)NSInteger remark_id;

//评论主题部分
@property(nonatomic,strong)NSString *remark_title;//评论标题
@property(nonatomic,strong)NSString *remark_content;//评论主体
@property(nonatomic,strong)NSString *remark_date;//评论日期
@property(nonatomic,strong)NSString *remark_heart;//评论心情

+(instancetype)shareAddMode;
-(void)insertData;//插入数据
-(void)deleteDataByTitle:(NSString *)title;//通过标题删除备注
-(void)updateDataWithRemark_title:(NSString *)title remark_content:(NSString *)content remark_date:(NSString *)date remark_heart:(NSString *)heart  where:(NSInteger)id;//通过id更新备注值
-(NSInteger)countForData;//计算有多少条数据
-(NSMutableArray*)selectEveryThing;//查询出所有的内容
@end
