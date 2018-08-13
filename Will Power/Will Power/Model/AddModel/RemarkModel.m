//
//  RemarkModel.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/1.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "RemarkModel.h"
#import <FMDatabase.h>

@interface RemarkModel ()
@property(nonatomic,strong)FMDatabase *database;
@end

@implementation RemarkModel
//设计成单利的
//这个名字是错的，------------------------------------------->待修改
+(instancetype)shareAddMode{
    static RemarkModel *remarkModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        remarkModel=[[RemarkModel alloc] init];
    });
    return remarkModel;
}
#pragma mark --FMDB数据库的操作
//创建任务数据表的接口
-(void)createDataBase{
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [[NSFileManager defaultManager] createDirectoryAtPath:[document stringByAppendingPathComponent:@"database"]
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    NSString *path=[document stringByAppendingString:@"/database/t_contact.sqlite"];
    
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
    NSString *stringCreateTable=@"create table if not exists remark(id integer primary key autoincrement,remark_title varchar(20),remark_content varchar(20),remark_date varchar(20),remark_heart varchar(20))";
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
            if ([self.database executeUpdate:@"insert into remark values (?,?,?,?,?)",NULL,self.remark_title,self.remark_content,self.remark_date,self.remark_heart]) {
                NSLog(@"插入数据成功");
            }
        }
        [self.database close];
    }
}
#pragma mark 删除数据部分
//删除数据,
-(void)deleteDataByTitle:(NSString *)title{
    [self createDataBase];
    //删除数据，默认已经执行查询数据了
    if (self.database!=nil) {
        if ([self.database open]) {
            if([self.database executeUpdate:@"delete from remark where remark_title=?",title]){
                NSLog(@"删除数据成功");
            }
        }
        [self.database close];
    }
}
-(void)deleteData{
    [self createDataBase];
    //删除数据，默认已经执行查询数据了
    if (self.database!=nil) {
        if ([self.database open]) {
            if([self.database executeUpdate:@"delete from remark"]){
                NSLog(@"删除数据成功");
            }
        }
        [self.database close];
    }
}
#pragma mark 修改数据部分
//修改数据，每一项都应该提供修改借口
-(void)updateDataWithRemark_title:(NSString *)title remark_content:(NSString *)content remark_date:(NSString *)date remark_heart:(NSString *)heart  where:(NSInteger)id{
    [self createDataBase];
    //修改数据，默认已经执行查询数据了
    if (self.database!=nil) {
        if([self.database open]){
            NSLog(@"修改数据，打开数据库成功");
            if ([self.database executeUpdate:@"update remark set remark_title=? remark_content=? remark_date=? remark_heart=? where id=?",title,content,date,heart,id]) {
                NSLog(@"修改数据成功");//通过id修改除id外的所有数据
            }
        }
        [self.database close];
    }
}
#pragma mark 查询数据部分
//1.数据库中现在有多少条数据
-(NSInteger)countForData{
    //查询数据必须确保数据库已经打开并加载到内存中，至于有没有数据这个不管我查询的事
    [self createDataBase];
    
    NSString *query=@"select * from remark";
    NSInteger count=0;
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            while ([result next]) {
                count+=1;
                NSLog(@"备注总共有%ld条",count);
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
    [self createDataBase];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    NSString *query=@"select * from remark";
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            //由于返回的是一个set，所以遍历所有结果
            while ([result next]) {
                //获取id字段内容(根据字段名字来获取)
                NSInteger id=[result intForColumn:@"id"];
                //获取subject_title字段内容(根据字段名字来获取)
                NSString *remark_title=[result stringForColumn:@"remark_title"];
                //获取subject_get字段内容(根据字段名字来获取)
                NSString *remark_content=[result stringForColumn:@"remark_content"];
                //获取subject_love_get字段内容(根据字段名字来获取)
                NSString *remark_date=[result stringForColumn:@"remark_date"];
                //获取subject_best_me字段内容(根据字段名字来获取)
                NSString *remark_heart=[result stringForColumn:@"remark_heart"];
                
                //装入字典
                NSDictionary *resultDicitonary=@{@"id":@(id),
                                                 @"remark_title":remark_title,
                                                 @"remark_content":remark_content,
                                                 @"remark_date":remark_date,
                                                 @"remark_heart":remark_heart
                                                 };
                [resultArray addObject:resultDicitonary];//把取出来的字典添加到数组中
                NSLog(@"%ld,%@,%@,%@,%@",id,remark_title,remark_content,remark_date,remark_heart);
            }
        }
        [self.database close];
    }
    return resultArray;//返回数组
}
@end
