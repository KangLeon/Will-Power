//
//  NotifiModel.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/5.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

//这个里面的好多方法是根本没有使用过的，回头整理的时候希望可以删除掉

#import "NotifiModel.h"
#import <FMDatabase.h>

@interface NotifiModel ()
@property(nonatomic,strong)FMDatabase *database;
@end

@implementation NotifiModel

//设计成单利的
+(instancetype)notifiModel{
    static NotifiModel *notifiModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notifiModel=[[NotifiModel alloc] init];
    });
    return notifiModel;
}

#pragma mark --FMDB数据库的操作

//创建任务数据表的接口
-(void)createDataBase{
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    
    //检查数据库是否创建成功
    if (self.database!=nil) {
        NSLog(@"数据库创建成功");
    }
    if ([self.database open]) {
        NSLog(@"打开数据库成功");
    }
    //创建数据表的sql语句
    NSString *stringCreateTable=@"create table if not exists alarm(id integer preimary key,subject_id integer,alarm_day varchar(20),alarm_hour varchar(20),alarm_minute varchar(20))";
    //检查数据表是否创建成功
    if ([self.database executeUpdate:stringCreateTable]){
        NSLog(@"创建数据表成功");
    }
}

#pragma mark 插入数据部分
//插入数据的接口
-(void)insertData{
    [self createDataBase];
    if (self.database!=nil) {
        if([self.database open]){
            if ([self.database executeUpdate:@"insert into alarm values (?,?,?,?,?)",@(self.alarm_id),@(self.subject_id),self.alarm_day,self.alarm_hour,self.alarm_minute]) {
                NSLog(@"插入数据成功");
            }
        }
    }
}
//#pragma mark 删除数据部分
//删除数据---这里不好分散操作，所以整个数组装填，删除也把该id下的全部删除然后再添加新数组的值
-(void)deleteDataByID:(NSInteger )id{
    //删除数据，默认已经执行查询数据了
    if (self.database!=nil) {
        if ([self.database open]) {
            if([self.database executeUpdate:@"delete from alarm where subject_id=?",@(id)]){
                NSLog(@"删除数据成功");
            }
        }
    }
}

//不用做修改，有删除所有值重新添加值就够了
//#pragma mark 修改数据部分
////修改数据，每一项都应该提供修改借口
//-(void)updateDataWithSubject_title:(NSString *)title subject_get:(NSString *)get subject_love_get:(NSString *)love subject_best_me:(NSString *)best goal_total:(NSInteger)goal start_date:(NSString*)date reject_things:(NSString *)things reject_people:(NSString *)people reject_time:(NSString*)time reject_thought:(NSString*)thought reward:(NSString*)reward where:(NSInteger)id{
//
//    //修改数据，默认已经执行查询数据了
//
//    if (self.database!=nil) {
//        if([self.database open]){
//            NSLog(@"修改数据，打开数据库成功");
//            if ([self.database executeUpdate:@"update subject set subject_title=? subject_get=? subject_love_get=? subject_best_me=? goal_total=? start_date=? reject_things=? reject_people=? reject_time=? reject_thought=? reward=? where id=?",title,get,love,best,goal,date,things,people,time,thought,reward,id]) {
//                NSLog(@"修改数据成功");//通过id修改除id外的所有数据
//            }
//        }
//    }
//}

#pragma mark 查询数据部分
//查询数据，每一项都应该提供查询借口

//1.数据库中现在有多少条数据
-(NSInteger)countForData{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    [self createDataBase];
    
    
    NSString *query=@"select * from alarm";
    NSInteger count=0;
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            while ([result next]) {
                count+=1;
                NSLog(@"哈哈又一条NotifiModel");
            }
            return count;
        }
    }
    return count;
}
//该条查询语句报错了--》和下面的错误点是一样的

//1.数据库中现在有多少条数据
-(NSInteger)countForDataIn:(NSInteger)subject_id{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    [self createDataBase];
    
    NSInteger count=0;
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:@"select * from alarm where subject_id=?",@(subject_id)];
            
            while ([result next]) {
                count+=1;
                NSLog(@"当前项目下的提醒又一条");
            }
            return count;
        }
    }
    return count;
}

//2.如果有数据的话，遍历查询出所有数据然后放到字典里面
-(NSMutableArray*)selectEveryThing{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];

    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    [self createDataBase];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];

    NSString *query=@"select * from alarm";
    if (self.database!=nil) {
        if ([self.database open]) {

            FMResultSet *result=[self.database executeQuery:query];

            //由于返回的是一个set，所以遍历所有结果
            while ([result next]) {
                //获取id字段内容(根据字段名字来获取)
                NSInteger id=[result intForColumn:@"id"];
                //获取id字段内容(根据字段名字来获取)
                NSInteger subject_id=[result intForColumn:@"subject_id"];
                //获取subject_title字段内容(根据字段名字来获取)
                NSString *alarm_day=[result stringForColumn:@"alarm_day"];
                //获取subject_get字段内容(根据字段名字来获取)
                NSString *alarm_hour=[result stringForColumn:@"alarm_hour"];
                //获取subject_get字段内容(根据字段名字来获取)
                NSString *alarm_minute=[result stringForColumn:@"alarm_minute"];

                //装入字典
                NSDictionary *resultDicitonary=@{@"id":@(id),
                                                 @"subject_id":@(subject_id),
                                                 @"alarm_day":alarm_day,
                                                 @"alarm_hour":alarm_hour,
                                                 @"alarm_minute":alarm_minute
                                                 };
                [resultArray addObject:resultDicitonary];//把取出来的字典添加到数组中
                NSLog(@"输出验证%ld,%ld,%@,%@,%@",id,subject_id,alarm_day,alarm_hour,alarm_minute);
            }
        }
    }
    return resultArray;//返回数组
}


//只查找出与当前任务相关的所有的提醒项
-(NSMutableArray*)selectItemsIn:(NSInteger)subject_id_for_select{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    [self createDataBase];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    NSString *query=@"select * from alarm where subject_id=?";
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query,@(subject_id_for_select)];
            
            //由于返回的是一个set，所以遍历所有结果
            while ([result next]) {
                //获取id字段内容(根据字段名字来获取)
                NSInteger id=[result intForColumn:@"id"];
                //获取id字段内容(根据字段名字来获取)
                NSInteger subject_id=[result intForColumn:@"subject_id"];
                //获取subject_title字段内容(根据字段名字来获取)
                NSString *alarm_day=[result stringForColumn:@"alarm_day"];
                //获取subject_get字段内容(根据字段名字来获取)
                NSString *alarm_hour=[result stringForColumn:@"alarm_hour"];
                //获取subject_get字段内容(根据字段名字来获取)
                NSString *alarm_minute=[result stringForColumn:@"alarm_minute"];
                
                //装入字典
                NSDictionary *resultDicitonary=@{@"id":@(id),
                                                 @"subject_id":@(subject_id),
                                                 @"alarm_day":alarm_day,
                                                 @"alarm_hour":alarm_hour,
                                                 @"alarm_minute":alarm_minute
                                                 };
                [resultArray addObject:resultDicitonary];//把取出来的字典添加到数组中
                NSLog(@"输出验证现在关联id下的任务有%ld,%ld,%@,%@,%@",id,subject_id,alarm_day,alarm_hour,alarm_minute);
            }
        }
    }
    return resultArray;//返回数组
}



@end
