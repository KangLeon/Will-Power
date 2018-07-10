//
//  PopChallengeViewController.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/8.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "PopChallengeViewController.h"
#import "ColorDefine.h"
#import "AddModel.h"

static NSString *cell_pop_id=@"cell_pop";
@interface PopChallengeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *pop_tableView;
@property(nonatomic,strong)NSMutableArray *pop_array;
@end

@implementation PopChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 50)];
    titleLabel.text=@"切换自控项目";
    titleLabel.textColor=PICKER_TITLE;
    titleLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(20, 38, 100, 2)];
    line.backgroundColor=PICKER_TITLE;
    
    [self.view addSubview:line];
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.pop_tableView];
    
}
//懒加载
-(UITableView *)pop_tableView{
    if (!_pop_tableView) {
        _pop_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, 150, 40*3)];
        _pop_tableView.dataSource=self;
        _pop_tableView.delegate=self;
        _pop_tableView.backgroundColor=POP_GRAYCOLOR;
        _pop_tableView.scrollEnabled=false;
        _pop_tableView.backgroundColor=[UIColor clearColor];
    }
    return _pop_tableView;
}
-(NSMutableArray *)pop_array{
    if (!_pop_array) {
        _pop_array=[[NSMutableArray alloc] init];
        //自己有一套判断逻辑来显示
        //查询数据库中有多少数据，然后把标题显示到上面cell上面,cell长度显示为8个人
        if ([[AddModel shareAddMode] countForData]==0) {
            //目前还没有数据
            //如果可以的话在这里也显示空视图
        }else if ([[AddModel shareAddMode] countForData]>0){
            for(int i=1; i<[[AddModel shareAddMode] countForData] | i==[[AddModel shareAddMode] countForData]; i++) {
                //添加到可变字典中
                [_pop_array addObject:[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:i-1] objectForKey:@"subject_title"]];
            }
        }
        
    }
    return _pop_array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pop_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_pop_id];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_pop_id];
    }
    cell.textLabel.text=self.pop_array[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

//点击切换按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是点击到第几行
    if (indexPath.row==0) {
        //在这里设置显示第一个任务的相关内容
        self.currentIndex=0;
        //在这里发送通知，通知其他页面已经更改了挑战内容
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSubject" object:nil userInfo:@{@"currentIndex":@(self.currentIndex)}];
    }else if (indexPath.row==1){
        //在这里设置显示第二个任务的相关内容
        self.currentIndex=1;
        //在这里发送通知，通知其他页面已经更改了挑战内容
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSubject" object:nil userInfo:@{@"currentIndex":@(self.currentIndex)}];
    }else if (indexPath.row==2){
        //在这里设置显示第三个任务的相关内容
        self.currentIndex=2;
        //在这里发送通知，通知其他页面已经更改了挑战内容
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSubject" object:nil userInfo:@{@"currentIndex":@(self.currentIndex)}];
    }
    //在这里自动使自己消失，但是不知道这个步骤是否是最佳的
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
