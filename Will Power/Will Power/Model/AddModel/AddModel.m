//
//  AddModel.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/4/26.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "AddModel.h"
#import <FMDatabase.h>
#import "CheckedModel.h"

@interface AddModel ()

@property(nonatomic,strong)FMDatabase *database;

@end

@implementation AddModel

//设计成单利的
+(instancetype)shareAddMode{
    static AddModel *addmodel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addmodel=[[AddModel alloc] init];
    });
    return addmodel;
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
    NSString *stringCreateTable=@"create table if not exists subject(id integer preimary key,subject_title varchar(20),subject_get varchar(20),subject_love_get varchar(20),subject_best_me varchar(20),goal_total integer,start_date varchar(20),reject_things varchar(20),reject_people varchar(20),reject_time varchar(20),reject_thought varchar(20),reward varchar(20),image)";
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
            if ([self.database executeUpdate:@"insert into subject values (?,?,?,?,?,?,?,?,?,?,?,?,?)",@(self.subject_id),self.subject_title,self.subject_get,self.subject_love_get,self.subject_best_me,@(self.goal_total),self.start_date,self.reject_things,self.reject_people,self.reject_time,self.reject_thought,self.reward,self.subject_image_index]) {
                NSLog(@"插入数据成功");
            }
        }
    }
}
#pragma mark 删除数据部分
//删除数据
-(void)deleteDataByID:(NSInteger)id{
    //删除数据，默认已经执行查询数据了
    if (self.database!=nil) {
        if ([self.database open]) {
            if([self.database executeUpdate:@"delete from subject where id=?",@(id)]){
                NSLog(@"删除数据成功");
            }
        }
        //忘了一点：同时把NotifiModel，subjectModel和checkedModel里的相关id下的所有内容都要删除
        //删除NotifiModel的
        if([self.database executeUpdate:@"delete from alarm where subject_id=?",@(id)]){
            NSLog(@"删除数据成功");
        }
        //删除subjectModel的
        if([self.database executeUpdate:@"delete from mission where id=?",@(id)]){
            NSLog(@"删除数据成功");
        }
        //删除CheckModel的
        [[CheckedModel shareCheckedModel] createDataBase];
        if([self.database executeUpdate:@"delete from checked where id=?",@(id)]){
            NSLog(@"删除数据成功");
        }
        //1.同时把后面的所有数据都移动到前面,
        //2.同时将所有的关联NotifiModel，SubjectModel，CheckedModel的subject_id都修改
        if(id==1){
            //修改后面两条
            //一.修改第一条
            if ([self.database executeUpdate:@"update subject set id=? where id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//将第三条改成第二条
            }
            //修改NotifiModel的
            if ([self.database executeUpdate:@"update alarm set subject_id=? where subject_id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//
            }
            //修改SubjectModel的
            if ([self.database executeUpdate:@"update mission set id=? where id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//
            }
            //修改CheckModel的
            [[CheckedModel shareCheckedModel] createDataBase];
            if ([self.database executeUpdate:@"update checked set id=? where id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//
            }
            //二.修改第三条
            if ([self.database executeUpdate:@"update subject set id=? where id=?",@(id),@(id+2)]) {
                NSLog(@"修改数据成功");//将第三条改成第二条
            }
            //修改NotifiModel的
            if ([self.database executeUpdate:@"update alarm set subject_id=? where subject_id=?",@(id),@(id+2)]) {
                NSLog(@"修改数据成功");//
            }
            //修改SubjectModel的
            if ([self.database executeUpdate:@"update mission set id=? where id=?",@(id),@(id+2)]) {
                NSLog(@"修改数据成功");//
            }
            //修改CheckModel的
            [[CheckedModel shareCheckedModel] createDataBase];
            if ([self.database executeUpdate:@"update checked set id=? where id=?",@(id),@(id+2)]) {
                NSLog(@"修改数据成功");//
            }
        }else if (id==2){
            //修改后面一条
            if ([self.database executeUpdate:@"update subject set id=? where id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//将第三条改成第二条
            }
            //修改NotifiModel的
            if ([self.database executeUpdate:@"update alarm set subject_id=? where subject_id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//
            }
            //修改SubjectModel的
            if ([self.database executeUpdate:@"update mission set id=? where id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//
            }
            //修改CheckModel的
            [[CheckedModel shareCheckedModel] createDataBase];
            if ([self.database executeUpdate:@"update checked set id=? where id=?",@(id),@(id+1)]) {
                NSLog(@"修改数据成功");//
            }
        }else if (id==3){
            //不需要做修改
        }
    }
}

#pragma mark 修改数据部分
//修改数据，每一项都应该提供修改借口
-(void)updateDataWithSubject_title:(NSString *)title subject_get:(NSString *)get subject_love_get:(NSString *)love subject_best_me:(NSString *)best goal_total:(NSInteger)goal start_date:(NSString*)date reject_things:(NSString *)things reject_people:(NSString *)people reject_time:(NSString*)time reject_thought:(NSString*)thought reward:(NSString*)reward where:(NSInteger)id{

    //修改数据，默认已经执行查询数据了
    
    if (self.database!=nil) {
        if([self.database open]){
            NSLog(@"修改数据，打开数据库成功");
            if ([self.database executeUpdate:@"update subject set subject_title=?,subject_get=?,subject_love_get=?,subject_best_me=?,goal_total=?,start_date=?,reject_things=?,reject_people=?,reject_time=?,reject_thought=?,reward=? where id=?",title,get,love,best,@(goal),date,things,people,time,thought,reward,@(id)]) {
                NSLog(@"修改数据成功");//通过id修改除id外的所有数据
            }
        }
    }
}
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
    [self createDataBase];//不知道为什么会出现no such tabel的错误
    
    NSString *query=@"select * from subject";
    NSInteger count=0;
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            while ([result next]) {
                count+=1;
                NSLog(@"哈哈又一条AddModel");
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
    
    NSString *query=@"select * from subject";
    if (self.database!=nil) {
        if ([self.database open]) {
            
            FMResultSet *result=[self.database executeQuery:query];
            
            //由于返回的是一个set，所以遍历所有结果
            while ([result next]) {
                //获取id字段内容(根据字段名字来获取)
                NSInteger id=[result intForColumn:@"id"];
                //获取subject_title字段内容(根据字段名字来获取)
                NSString *subject_title=[result stringForColumn:@"subject_title"];
                //获取subject_get字段内容(根据字段名字来获取)
                NSString *subject_get=[result stringForColumn:@"subject_get"];
                //获取subject_love_get字段内容(根据字段名字来获取)
                NSString *subject_love_get=[result stringForColumn:@"subject_love_get"];
                //获取subject_best_me字段内容(根据字段名字来获取)
                NSString *subject_best_me=[result stringForColumn:@"subject_best_me"];
                //获取goal_total字段内容(根据字段名字来获取)
                NSInteger goal_total=[result intForColumn:@"goal_total"];
                //获取start_date字段内容(根据字段名字来获取)
                NSString *start_date=[result stringForColumn:@"start_date"];
                //获取reject_things字段内容(根据字段名字来获取)
                NSString *reject_things=[result stringForColumn:@"reject_things"];
                //获取reject_people字段内容(根据字段名字来获取)
                NSString *reject_people=[result stringForColumn:@"reject_people"];
                //获取reject_time字段内容(根据字段名字来获取)
                NSString *reject_time=[result stringForColumn:@"reject_time"];
                //获取reject_thought字段内容(根据字段名字来获取)
                NSString *reject_thought=[result stringForColumn:@"reject_thought"];
                //获取reward字段内容(根据字段名字来获取)
                NSString *reward=[result stringForColumn:@"reward"];
                //获取image字段内容(根据字段名字来获取)
                NSString *image=[result stringForColumn:@"image"];
       
                //装入字典
                NSDictionary *resultDicitonary=@{@"id":@(id),
                                                            @"subject_title":subject_title,
                                                            @"subject_get":subject_get,
                                                            @"subject_love_get":subject_love_get,
                                                            @"subject_best_me":subject_best_me,
                                                            @"goal_total":@(goal_total),
                                                            @"start_date":start_date,
                                                            @"reject_things":reject_things,
                                                            @"reject_people":reject_people,
                                                            @"reject_time":reject_time,
                                                            @"reject_thought":reject_thought,
                                                            @"reward":reward,
                                                            @"image":image
                                                        };
                [resultArray addObject:resultDicitonary];//把取出来的字典添加到数组中
                NSLog(@"%ld,%@,%@,%@,%@,%ld,%@,%@,%@,%@,%@,%@,%@",id,subject_title,subject_get,subject_love_get,subject_best_me,goal_total,start_date,reject_things,reject_people,reject_time,reject_thought,reward,image);
        }
    }
}
    return resultArray;//返回数组
}


@end
