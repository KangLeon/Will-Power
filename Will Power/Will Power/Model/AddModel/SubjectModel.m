//
//  SubjectModel.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/7.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubjectModel.h"
#import <FMDatabase.h>

@interface SubjectModel ()

@property(nonatomic,strong)FMDatabase *database;

@end

@implementation SubjectModel
//设计成单利的
+(instancetype)shareSubjectModel{
    static SubjectModel *subjectModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        subjectModel=[[SubjectModel alloc] init];
    });
    return subjectModel;
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
    NSString *stringCreateTable=@"create table if not exists mission(id integer preimary key,subject_execute varchar(20))";
    //检查数据表是否创建成功
    if ([self.database executeUpdate:stringCreateTable]){
        NSLog(@"创建数据表成功");
    }
    [self.database close];
}
#pragma mark 插入数据部分
//插入数据的接口
-(void)insertData{
    [self createDataBase];
    if (self.database!=nil) {
        if([self.database open]){
            if ([self.database executeUpdate:@"insert into mission values (?,?)",@(self.subject_id),self.subject_execute]) {
                NSLog(@"插入数据成功");
            }
        }
        [self.database close];
    }
}
#pragma mark 修改删除，暂时没有需求，所以暂时不做，

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
    
    NSString *query=@"select * from mission";
    NSInteger count=0;
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            while ([result next]) {
                count+=1;
//                NSLog(@"哈哈又一条");
            }
            return count;
        }
        [self.database close];
    }
    return count;
}
-(NSInteger)countForDataAtId:(NSInteger)select_id{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    [self createDataBase];
    
    NSString *query=@"select * from mission where id=?";
    NSInteger count=0;
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query,@(select_id)];
            
            while ([result next]) {
                count+=1;
                //                NSLog(@"哈哈又一条");
            }
            return count;
        }
        [self.database close];
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
    
    NSString *query=@"select * from mission";
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            //由于返回的是一个set，所以遍历所有结果
            while ([result next]) {
                //获取id字段内容(根据字段名字来获取)
                NSInteger id=[result intForColumn:@"id"];
                //获取subject_title字段内容(根据字段名字来获取)
                NSDate *subject_execute=[result dateForColumn:@"subject_execute"];
                
                //装入字典
                NSDictionary *resultDicitonary=@{@"id":@(id),
                                                 @"subject_execute":subject_execute
                                                 };
                [resultArray addObject:resultDicitonary];//把取出来的字典添加到数组中
//                NSLog(@"查找所有提醒时间%ld,%@",id,subject_execute);
            }
        }
        [self.database close];
    }
    return resultArray;//返回数组
}

//3.如果有数据的话，遍历查询出所有数据然后放到字典里面
-(NSMutableArray*)selectEveryThing:(NSInteger)for_select_id{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[document stringByAppendingString:@"/subject1.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，就创建指定的数据库，如果路径下已经存在数据库，加载数据库到内存
    self.database=[FMDatabase databaseWithPath:path];
    [self createDataBase];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    NSString *query=@"select * from mission where id=?";
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query,@(for_select_id)];
            
            //由于返回的是一个set，所以遍历所有结果
            while ([result next]) {
                //获取id字段内容(根据字段名字来获取)
                NSInteger id=[result intForColumn:@"id"];
                //获取subject_title字段内容(根据字段名字来获取)
                NSDate *subject_execute=[result dateForColumn:@"subject_execute"];
                
                //装入字典
                NSDictionary *resultDicitonary=@{@"id":@(id),
                                                 @"subject_execute":subject_execute
                                                 };
                [resultArray addObject:resultDicitonary];//把取出来的字典添加到数组中
//                NSLog(@"查找关联id下的提醒时间%ld,%@",id,subject_execute);
            }
        }
        [self.database close];
    }
    return resultArray;//返回数组
}

@end
