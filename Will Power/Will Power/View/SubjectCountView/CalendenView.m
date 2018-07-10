//
//  CalendenView.m
//  Will Power
//
//  Created by mac on 2018/4/22.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CalendenView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <ReactiveObjC.h>
#import "NSString+DateTitle.h"
#import "NSDate+LocalDate.h"
#import "CalenderData.h"
#import "CalenderCollectionViewCell.h"
#import "TapMusicButton.h"
#import "CheckedModel.h"
#import "NSString+DateTitle.h"
#import "AddModel.h"

#define SIZE ((SCREEN_WIDTH-20-6*5)/7)

static NSString *cell_id=@"reuse_collection";

@interface CalendenView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//两个切换button
@property(nonatomic,strong)TapMusicButton *month_button;
@property(nonatomic,strong)UILabel *month_label;

@property(nonatomic,strong)TapMusicButton *year_button;
@property(nonatomic,strong)UILabel *year_label;

//月度统计部分
//左右按键 月份表示 周表示
@property(nonatomic,strong)UILabel *current_month;
@property(nonatomic,strong)TapMusicButton *left_button;
@property(nonatomic,strong)TapMusicButton *right_button;

//日历主体部分
@property(nonatomic,strong)UICollectionView *calender_collectionView;
@property(nonatomic,assign)NSInteger month_total_days;//本月总共有多少天

@property(nonatomic,strong)UIView *back_view;

//年度统计部分
//左右按键 年度表示
@property(nonatomic,strong)UILabel *current_year;
@property(nonatomic,strong)TapMusicButton *left_button_year;
@property(nonatomic,strong)TapMusicButton *right_button_year;

//图标主体部分

@property(nonatomic,strong)UIView *back_view_year;
@property(nonatomic,strong)UIView *count_view;

//tool
@property(nonatomic,copy)NSString *tem_month;
@property(nonatomic,copy)NSString *this_year;//当前年，加载的时候存储字符串，然后在左键回来的时候，如果是当前的话，就将月份变少，

@end

@implementation CalendenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.month_button];
        [[self.month_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 animations:^{
                self.month_button.backgroundColor=[UIColor whiteColor];
                self.year_button.backgroundColor=CALENDER_GRAY;
                self.month_button.frame=CGRectMake(0, 0, (SCREEN_WIDTH-20-5)/2+5, 50);
                self.month_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
                self.month_label.textColor=[UIColor darkGrayColor];
                self.year_button.frame=CGRectMake((SCREEN_WIDTH-20-5)/2+5+5, 3, (SCREEN_WIDTH-20-5)/2-5, 50);
                self.year_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
                self.year_label.textColor=[UIColor grayColor];
            }];
            [self addSubview:self.back_view];
            [self.back_view_year removeFromSuperview];
        }];
        
        [self addSubview:self.year_button];
        [[self.year_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.5 animations:^{
                self.month_button.backgroundColor=CALENDER_GRAY;
                self.year_button.backgroundColor=[UIColor whiteColor];
                self.month_button.frame=CGRectMake(0, 3, (SCREEN_WIDTH-20-5)/2-5, 50);
                self.month_label.font=[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
                self.month_label.textColor=[UIColor grayColor];
                self.year_button.frame=CGRectMake((SCREEN_WIDTH-20-5)/2+5-5, 0, (SCREEN_WIDTH-20-5)/2+5, 50);
                self.year_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
                self.year_label.textColor=[UIColor darkGrayColor];
            }];
        [self.back_view removeFromSuperview];
        [self addSubview:self.back_view_year];
        }];
        [self addSubview:self.back_view];
        
        //得到当前月
        NSDate *date=[NSDate localdate];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString *tem_dateString=[formatter stringFromDate:date];
        self.tem_month=[tem_dateString substringWithRange:NSMakeRange(5, 2)];
        
        [[CalenderData sharedCalenderData] loadCurrentMonth];//加载本月数据,只在页面初始化的时候加载，其他位置不可加载
        
        //将当前年的字符串值赋值
    }
    return self;
}

#pragma mark --头部的两个button

-(TapMusicButton *)month_button{
    if (!_month_button) {
        _month_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-20-5)/2+5, 50)];
        _month_button.backgroundColor=[UIColor whiteColor];
        _month_button.layer.cornerRadius=12;
        
        self.month_label=[[UILabel alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH-20-5)/2+5-80)/2, 10, 80, 20)];
        self.month_label.text=@"每月统计";
        self.month_label.textColor=[UIColor darkGrayColor];
        self.month_label.font=[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        self.month_label.textAlignment=NSTextAlignmentCenter;
        [_month_button addSubview:self.month_label];
    }
    return _month_button;
}
-(TapMusicButton *)year_button{
    if (!_year_button) {
        _year_button=[[TapMusicButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20-5)/2+5+5, 3, (SCREEN_WIDTH-20-5)/2-5, 50)];
        _year_button.backgroundColor=CALENDER_GRAY;
        _year_button.layer.cornerRadius=12;
        
        self.year_label=[[UILabel alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH-20-5)/2-5-80)/2, 10, 80, 20)];
        self.year_label.text=@"年度统计";
        self.year_label.textColor=[UIColor grayColor];
        self.year_label.font=[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        self.year_label.textAlignment=NSTextAlignmentCenter;
        [_year_button addSubview:self.year_label];
        
    }
    return _year_button;
}

#pragma mark 月统计部分

-(UIView *)back_view{
    if (!_back_view) {
        _back_view=[[UIView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH-20, 55+(SIZE+5)*5+4*5+15)];
        _back_view.backgroundColor=[UIColor whiteColor];
        _back_view.layer.cornerRadius=12;
        
        [_back_view addSubview:self.current_month];//当前月
        [_back_view addSubview:self.left_button];
        
        //向左按钮点击事件
        [[self.left_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CalenderData *calender_data=[CalenderData sharedCalenderData];
            [calender_data loadLastMonth];
            [self.calender_collectionView reloadData];
            
            //设置标题
            NSString *changeString=[CalenderData sharedCalenderData].dateString;
            
            NSString *current_month_title=[changeString monthForDateString:changeString];
            
            self.current_month.text=current_month_title;
            
            //当向左按钮点击时需要判断如果是当前月就不可以往后跳，所以应该把该按钮设置为不显示
            //当代码执行到这里的时候页面已经执行过-loadCurrentMonth方法了，可以直接取当月的值
            if ([[CalenderData sharedCalenderData].month isEqualToString:[CalenderData sharedCalenderData].current_month]) {
                [self.right_button removeFromSuperview];
            }else{
                [self.back_view addSubview:self.right_button];
            }
        }];
        
        //初始化时需要判断如果是当前月就不可以往后跳，所以应该把该按钮设置为不显示
        //当代码执行到这里的时候页面已经执行过-loadCurrentMonth方法了，可以直接取当月的值
        if ([[CalenderData sharedCalenderData].month isEqualToString:[CalenderData sharedCalenderData].current_month]) {
            [self.right_button removeFromSuperview];
        }else{
            [_back_view addSubview:self.right_button];
        }
        
        //向右按钮点击事件
        [[self.right_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            CalenderData *calender_data=[CalenderData sharedCalenderData];
            [calender_data loadNextMonth];
            [self.calender_collectionView reloadData];
            
            //设置标题
            NSString *changeString=[CalenderData sharedCalenderData].dateString;
            
            NSString *current_month_title=[changeString monthForDateString:changeString];
            
            self.current_month.text=current_month_title;
            
            //当向左按钮点击时需要判断如果是当前月就不可以往后跳，所以应该把该按钮设置为不显示
            //当代码执行到这里的时候页面已经执行过-loadCurrentMonth方法了，可以直接取当月的值
            if ([[CalenderData sharedCalenderData].month isEqualToString:[CalenderData sharedCalenderData].current_month]) {
                [self.right_button removeFromSuperview];
            }else{
                [self.back_view addSubview:self.right_button];
            }
        }];
        
        
        NSArray *weeks_array=@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        for (int i=0; i<7; i++) {
            UILabel *week_label=[[UILabel alloc] initWithFrame:CGRectMake(0+(SCREEN_WIDTH-20)/7*i, 35, (SCREEN_WIDTH-20)/7, 15)];
            week_label.text=weeks_array[i];
            week_label.textColor=[UIColor grayColor];
            week_label.font=[UIFont systemFontOfSize:14.0 weight:UIFontWeightThin];
            week_label.textAlignment=NSTextAlignmentCenter;
            [_back_view addSubview:week_label];
        }
        
        //日历主体部分
        [_back_view addSubview:self.calender_collectionView];
    }
    return _back_view;
}

-(UILabel *)current_month{
    if (!_current_month) {
        _current_month=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100-20)/2, 10, 100, 20)];
        
        [[CalenderData sharedCalenderData] loadCurrentMonth];//加载本月数据,只在页面初始化的时候加载，其他位置不可加载
        NSString *dateString=[CalenderData sharedCalenderData].dateString;
        
        NSString *current_month_title=[dateString monthForDateString:dateString];
        _current_month.text=current_month_title;
        _current_month.textColor=[UIColor darkGrayColor];
        _current_month.textAlignment=NSTextAlignmentCenter;
        _current_month.font=[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    }
    return _current_month;
}

-(TapMusicButton *)left_button{
    if (!_left_button) {
        _left_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
        UIImageView *buttonImage=[[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 10, 15)];
        buttonImage.image=[UIImage imageNamed:@"calender_left_image"];
        [_left_button addSubview:buttonImage];
    }
    return _left_button;
}

-(TapMusicButton *)right_button{
    if (!_right_button) {
        _right_button=[[TapMusicButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70-20, 10, 60, 30)];
        UIImageView *buttonImage=[[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 10, 15)];
        buttonImage.image=[UIImage imageNamed:@"calender_right_image"];
        [_right_button addSubview:buttonImage];
    }
    return _right_button;
}

-(UICollectionView*)calender_collectionView{
    if (!_calender_collectionView) {
        //实例化
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        //每个item的size
//        layout.itemSize=CGSizeMake((SCREEN_WIDTH-20-3*6)/7, (SCREEN_WIDTH-20-5*6)/7+5);
        
        //滑动方向
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        _calender_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH-20, (SIZE+5)*5+4*5) collectionViewLayout:layout];
        
        _calender_collectionView.backgroundColor=[UIColor whiteColor];
        
        _calender_collectionView.dataSource=self;
        _calender_collectionView.delegate=self;
        
        //注册id
        [_calender_collectionView registerClass:[CalenderCollectionViewCell class] forCellWithReuseIdentifier:cell_id];
    }
    return _calender_collectionView;
}

#pragma  mark --年度统计部分
-(UIView *)back_view_year{
    if (!_back_view_year) {
        _back_view_year=[[UIView alloc] init];
        //如果比四个月大的话，就扩大frame,因为放不下超过4个月的数据
        if ([[CalenderData sharedCalenderData].month integerValue]>4) {
            _back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150+25*([[CalenderData sharedCalenderData].month integerValue]-4));
        }else{
           _back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150);
        }

        //添加视图
        _back_view_year.backgroundColor=[UIColor whiteColor];
        _back_view_year.layer.cornerRadius=12;
        
        [_back_view_year addSubview:self.current_year];
        [_back_view_year addSubview:self.left_button_year];
        
        //向左按钮的点击事件
        [[self.left_button_year rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //这里只是显示，数据操作显示还需要完善，究竟是需要再改一下数据呢，还是load方法里面改????????
            
            //将当前日期标题减一
             self.current_year.text=[NSString stringWithFormat:@"%d",[self.current_year.text intValue]-1];//当前日期标题的内容
            
            //判断需求：如果翻页翻到的是今年的话,就只显示到当前月
            if([self.current_year.text integerValue]==[[CalenderData sharedCalenderData].current_year integerValue]){
                //如果是当前年的话
                 NSString *month=[CalenderData sharedCalenderData].month;//比较的时候还是拿这个比较的
                
                //如果是大于4个月的话，frame就耀根据月份数动态扩大
                if ([month integerValue]>4) {
                    self.back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150+25*([month integerValue]-4));
                }else{
                    self.back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150);
                }
                //移除旧的所有label和view，
                //遍历count_view上的所有子view都移除掉
                for (UIView *view in self.count_view.subviews) {
                    [view removeFromSuperview];
                }
                //添加新的，这样的话有个问题，会不会引起太浪费资源的问题
                for (int i=0; i<([month integerValue]); i++) {
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 15+(i*25), 60, 15)];
                    label.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    label.textColor=[UIColor grayColor];
                    label.textAlignment=NSTextAlignmentCenter;
                    label.text=[NSString stringWithFormat:@"%d月",i+1];
                    [self.count_view addSubview:label];
                    
                    //月份判断逻辑
                    NSInteger month_count;
                    int year_count=[self.current_year.text intValue];
                    if ([self isSpecial:year_count]) {
                        //闰年
                        if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                            month_count=31;
                        }else if((i+1)==2){
                            month_count=29;
                        }else{
                            month_count=30;
                        }
                    }else{
                        //平年
                        if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                            month_count=31;
                        }else if((i+1)==2){
                            month_count=28;
                        }else{
                            month_count=30;
                        }
                    }
                    
                    for (NSInteger j=0; j<month_count; j++) {
                        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(65+(10*j), 17+(i*25), 9, 9)];
                        view.backgroundColor=CALENDER_GRAY;
                        [self.count_view addSubview:view];
                        
                        //判断逻辑，如果数据库中关于当年，当月，有数据，并且当日值和j的值相同，那么就把view的背景颜色改为绿色，
                        for (NSDictionary *resault_dict in [[CheckedModel shareCheckedModel] selectEveryThingById:self.index_calender]){
                            NSString *checked_dateString=[NSString stringFrom:[resault_dict objectForKey:@"checked"]];//得到数据库中存的日期的字符串
                            if ([[checked_dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:self.current_year.text]) {
                                //判断月是否一样
                                if ([[checked_dateString substringWithRange:NSMakeRange(5, 2)] integerValue]==(i+1)) {
                                    //判断日是否一样
                                    if ([[checked_dateString substringWithRange:NSMakeRange(8, 2)] integerValue]==(j+1)) {
                                        view.backgroundColor=CALENDER_GREEN;
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                //如果是比当前年小
                //(向左不可能比当前年大)
                //年分减一
                
                self.back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150+25*8);
                self.count_view.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 120+25*8);
                //移除旧的，
                //遍历count_view上的所有子view都移除掉
                for (UIView *view in self.count_view.subviews) {
                    [view removeFromSuperview];
                }
                //添加新的，这样的话有个问题，会不会引起太浪费资源的问题
                for (int i=0; i<(12); i++) {
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 15+(i*25), 60, 15)];
                    label.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    label.textColor=[UIColor grayColor];
                    label.textAlignment=NSTextAlignmentCenter;
                    label.text=[NSString stringWithFormat:@"%d月",i+1];
                    [self.count_view addSubview:label];
                    
                    //月份判断逻辑
                    NSInteger month_count;
                    int year_count=[self.current_year.text intValue];
                    if ([self isSpecial:year_count]) {
                        //闰年
                        if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                            month_count=31;
                        }else if((i+1)==2){
                            month_count=29;
                        }else{
                            month_count=30;
                        }
                    }else{
                        //平年
                        if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                            month_count=31;
                        }else if((i+1)==2){
                            month_count=28;
                        }else{
                            month_count=30;
                        }
                    }
                    
                    for (NSInteger j=0; j<month_count; j++) {
                        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(65+(10*j), 17+(i*25), 9, 9)];
                        view.backgroundColor=CALENDER_GRAY;
                        [self.count_view addSubview:view];
                        
                        //判断逻辑，如果数据库中关于当年，当月，有数据，并且当日值和j的值相同，那么就把view的背景颜色改为绿色，
                        for (NSDictionary *resault_dict in [[CheckedModel shareCheckedModel] selectEveryThingById:self.index_calender]){
                            NSString *checked_dateString=[NSString stringFrom:[resault_dict objectForKey:@"checked"]];//得到数据库中存的日期的字符串
                            if ([[checked_dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:self.current_year.text]) {
                                //判断月是否一样
                                if ([[checked_dateString substringWithRange:NSMakeRange(5, 2)] integerValue]==(i+1)) {
                                    //判断日是否一样
                                    if ([[checked_dateString substringWithRange:NSMakeRange(8, 2)] integerValue]==(j+1)) {
                                        view.backgroundColor=CALENDER_GREEN;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }];
        
        [_back_view_year addSubview:self.right_button_year];
        
        //向右按钮的点击事件
        [[self.right_button_year rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //这里只是显示，数据操作显示还需要完善，究竟是需要再改一下数据呢，还是load方法里面改
            //如果不是当前年的话，就12个月都显示
            
            //年份加一
            self.current_year.text=[NSString stringWithFormat:@"%d",[self.current_year.text intValue]+1];
            
            //还需要加一个判断是不是比当前年的大，大的话只显示一个label，没有数据显示
            if ([self.current_year.text integerValue]>[[CalenderData sharedCalenderData].current_year integerValue]) {
               
                    //移除所有view
                    for (UIView *view in self.count_view.subviews) {
                        [view removeFromSuperview];
                    }
                    //将view的frame缩小
                    self.back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150);
                    self.count_view.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 120);
               
            }else if([self.current_year.text integerValue]==[[CalenderData sharedCalenderData].current_year integerValue]){
                //是否和当前年是一样的，是的话，完成frame的缩小
                
                //判断当前的月从而绘制之前的月
                //运行到这的时候loadCurrentMonth已经执行了，可以直接取值
                NSString *month=[CalenderData sharedCalenderData].month;//比较的时候还是拿这个比较的
                
                    //扩大back_view_year的frame
                    if ([[CalenderData sharedCalenderData].month integerValue]>4) {
                        self.back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150+25*([[CalenderData sharedCalenderData].month integerValue]-4));
                    }else{
                        self.back_view_year.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 150);
                    }
                    
                    //如果比四个月大的话，就扩大count_view的frame
                    if ([[CalenderData sharedCalenderData].month integerValue]>4) {
                        self.count_view.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 120+25*([[CalenderData sharedCalenderData].month integerValue]-4));
                    }else{
                        self.count_view.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 120);
                    }
                    //移除旧的，
                    for (UIView *view in self.count_view.subviews) {
                        [view removeFromSuperview];
                    }
                    //添加新的，这样的话有个问题，会不会引起太浪费资源的问题
                    for (int i=0; i<([month integerValue]); i++) {
                        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 15+(i*25), 60, 15)];
                        label.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                        label.textColor=[UIColor grayColor];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.text=[NSString stringWithFormat:@"%d月",i+1];
                        [self.count_view addSubview:label];
                        
                        //月份判断逻辑
                        NSInteger month_count;
                        int year_count=[self.current_year.text intValue];
                        if ([self isSpecial:year_count]) {
                            //闰年
                            if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                                month_count=31;
                            }else if((i+1)==2){
                                month_count=29;
                            }else{
                                month_count=30;
                            }
                        }else{
                            //平年
                            if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                                month_count=31;
                            }else if((i+1)==2){
                                month_count=28;
                            }else{
                                month_count=30;
                            }
                        }
                        
                        for (int j=0; j<month_count; j++) {
                            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(65+(10*j), 17+(i*25), 9, 9)];
                            view.backgroundColor=CALENDER_GRAY;
                            [self.count_view addSubview:view];
                            
                            //判断逻辑，如果数据库中关于当年，当月，有数据，并且当日值和j的值相同，那么就把view的背景颜色改为绿色，
                            for (NSDictionary *resault_dict in [[CheckedModel shareCheckedModel] selectEveryThingById:self.index_calender]){
                                NSString *checked_dateString=[NSString stringFrom:[resault_dict objectForKey:@"checked"]];//得到数据库中存的日期的字符串
                                if ([[checked_dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:self.current_year.text]) {
                                    //判断月是否一样
                                    if ([[checked_dateString substringWithRange:NSMakeRange(5, 2)] integerValue]==(i+1)) {
                                        //判断日是否一样
                                        if ([[checked_dateString substringWithRange:NSMakeRange(8, 2)] integerValue]==(j+1)) {
                                            view.backgroundColor=CALENDER_GREEN;
                                        }
                                    }
                                }
                            }
                        }
                    }
               
            }
        }];
        
        [_back_view_year addSubview:self.count_view];
    }
    return _back_view_year;
}

-(UILabel *)current_year{
    if (!_current_year) {
        _current_year=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100-20)/2, 10, 100, 20)];
        
        [[CalenderData sharedCalenderData] loadCurrentMonth];//加载本月数据,只在页面初始化的时候加载，其他位置不可加载
        NSString *year=[CalenderData sharedCalenderData].year;

        _current_year.text=year;
        _current_year.textColor=[UIColor darkGrayColor];
        _current_year.textAlignment=NSTextAlignmentCenter;
        _current_year.font=[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    }
    return _current_year;
}

-(TapMusicButton *)left_button_year{
    if (!_left_button_year) {
        _left_button_year=[[TapMusicButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
        UIImageView *buttonImage=[[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 10, 15)];
        buttonImage.image=[UIImage imageNamed:@"calender_left_image"];
        [_left_button_year addSubview:buttonImage];
    }
    return _left_button_year;
}

-(TapMusicButton *)right_button_year{
    if (!_right_button_year) {
        _right_button_year=[[TapMusicButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70-20, 10, 60, 30)];
        UIImageView *buttonImage=[[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 10, 15)];
        buttonImage.image=[UIImage imageNamed:@"calender_right_image"];
        [_right_button_year addSubview:buttonImage];
    }
    return _right_button_year;
}

-(UIView *)count_view{
    if (!_count_view) {
        _count_view=[[UIView alloc] init];
        
        //如果比四个月大的话，就扩大frame
        if ([[CalenderData sharedCalenderData].month integerValue]>4) {
            _count_view.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 120+25*([[CalenderData sharedCalenderData].month integerValue]-4));
        }else{
            _count_view.frame=CGRectMake(0, 35, SCREEN_WIDTH-20, 120);
        }
        
        _count_view.backgroundColor=[UIColor whiteColor];
        _count_view.layer.cornerRadius=12.0;
        
        //判断当前的月从而绘制之前的月
        //运行到这的时候loadCurrentMonth已经执行了，可以直接取值
        NSString *month=[CalenderData sharedCalenderData].month;//比较的时候还是拿这个比较的
        
        for (int i=0; i<([month integerValue]); i++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 15+(i*25), 60, 15)];
            label.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
            label.textColor=[UIColor grayColor];
            label.textAlignment=NSTextAlignmentCenter;
            label.text=[NSString stringWithFormat:@"%d月",i+1];
            [_count_view addSubview:label];
            
            //月份判断逻辑
            NSInteger month_count;
            int year_count=[self.current_year.text intValue];
            if ([self isSpecial:year_count]) {
                //闰年
                if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                    month_count=31;
                }else if((i+1)==2){
                    month_count=29;
                }else{
                    month_count=30;
                }
            }else{
                //平年
                if ((i+1)==1 | (i+1)==3 | (i+1)==5 | (i+1)==7 | (i+1)==8 | (i+1)==10 | (i+1)==12) {
                    month_count=31;
                }else if((i+1)==2){
                    month_count=28;
                }else{
                    month_count=30;
                }
            }
            
            for (int j=0; j<month_count; j++) {
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(65+(10*j), 17+(i*25), 9, 9)];
                view.backgroundColor=CALENDER_GRAY;
                [_count_view addSubview:view];
                
                //判断逻辑，如果数据库中关于当年，当月，有数据，并且当日值和j的值相同，那么就把view的背景颜色改为绿色，
                for (NSDictionary *resault_dict in [[CheckedModel shareCheckedModel] selectEveryThingById:self.index_calender]){
                    NSString *checked_dateString=[NSString stringFrom:[resault_dict objectForKey:@"checked"]];//得到数据库中存的日期的字符串
                    if ([[checked_dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:self.current_year.text]) {
                        //判断月是否一样
                        if ([[checked_dateString substringWithRange:NSMakeRange(5, 2)] integerValue]==(i+1)) {
                            //判断日是否一样
                            if ([[checked_dateString substringWithRange:NSMakeRange(8, 2)] integerValue]==(j+1)) {
                                view.backgroundColor=CALENDER_GREEN;
                            }
                        }
                    }
                }
            }
        }
    }
    return _count_view;
}


#pragma mark --collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 35;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalenderCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[CalenderCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, SIZE, SIZE+5)];
    }
    cell.backgroundColor=CALENDER_GRAY;//初始的默认背景是灰色的
    CalenderData *calender_data=[CalenderData sharedCalenderData];
    
    //判断该月有多少天
    NSString *month=calender_data.month;
    NSString *year=calender_data.year;
    if ([month isEqualToString:@"01"] | [month isEqualToString:@"03"] | [month isEqualToString:@"05"] | [month isEqualToString:@"07"] | [month isEqualToString:@"08"] | [month isEqualToString:@"10"] | [month isEqualToString:@"12"]) {
        //是大月的话，31天
        self.month_total_days=31;
    }else if ([month isEqualToString:@"02"]){
        if (calender_data.isSpecialYear) {
            //如果是闰年的话2月是29天
            self.month_total_days=29;
        }else{
            //平年2月是28天
            self.month_total_days=28;
        }
    }else if ([month isEqualToString:@"04"] | [month isEqualToString:@"06"] | [month isEqualToString:@"09"] | [month isEqualToString:@"11"]){
        //小月是30天
        self.month_total_days=30;
    }
    
    //将之前的赋值和背景设置都清空
    cell.calenderTitle.text=@"";
    cell.calenderTitle.textColor=[UIColor grayColor];
    cell.calenderTitle.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    
    //首先判断今天是周几,从哪一行开始
    NSString *week=calender_data.thisMonthFirst_week;//本月的月初是周几
    if ([week isEqualToString:@"星期一"]) {
        //如果月初是周一的话，那么日历的的每一天日期数和索引是对应的
        if (indexPath.row>0) {
            if (indexPath.row>self.month_total_days) {
                cell.calenderTitle.text=@"";
            }else{
              cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row];
            }
            //11月和12月字体较大时的处理，将月初日期字体缩小，并且改变内容
            if (indexPath.row==1) {
                NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
                //判断是不是十一月或十二月 将字体缩小
                if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                    cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }else{
                    cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }
            }
            //只有是当前月，才显示当前日期为蓝色的
            if ([month isEqualToString:self.tem_month]) {
                if (indexPath.row==[calender_data.current_date integerValue]) {
                    cell.calenderTitle.textColor=BACKGROUND_COLOR;
                }
            }
            
        }
    }else if ([week isEqualToString:@"星期二"]){
        if (indexPath.row>1) {
            if ((indexPath.row-1)>self.month_total_days) {
                cell.calenderTitle.text=@"";
            }else{
              cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row-1];
            }
            //将月初日期字体缩小，并且改变内容
            if (indexPath.row==2) {
                NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
                //判断是不是十一月或十二月 将字体缩小
                if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                    cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }else{
                    cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }
            }
            //只有是当前月，才显示当前日期为蓝色的
            if ([month isEqualToString:self.tem_month]) {
                if ((indexPath.row-1)==[calender_data.current_date integerValue]) {
                    cell.calenderTitle.textColor=BACKGROUND_COLOR;
                }
            }
            
        }
    }else if ([week isEqualToString:@"星期三"]){
        if (indexPath.row>2) {
            if ((indexPath.row-2)>self.month_total_days) {
                cell.calenderTitle.text=@"";
            }
            else{
                 cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row-2];
            }
            //将月初日期字体缩小，并且改变内容
            if (indexPath.row==3) {
                NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
                //判断是不是十一月或十二月 将字体缩小
                if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                    cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }else{
                    cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }
            }
            //只有是当前月，才显示当前日期为蓝色的
            if ([month isEqualToString:self.tem_month]) {
                if ((indexPath.row-2)==[calender_data.current_date integerValue]) {
                    cell.calenderTitle.textColor=BACKGROUND_COLOR;
                }
            }
           
        }
    }else if ([week isEqualToString:@"星期四"]){
        if (indexPath.row>3) {
            if ((indexPath.row-3)>self.month_total_days) {
                cell.calenderTitle.text=@"";
            }
            else{
                cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row-3];
            }
            //将月初日期字体缩小，并且改变内容
            if (indexPath.row==4) {
                NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
                //判断是不是十一月或十二月 将字体缩小
                if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                    cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }else{
                    cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }
            }
            //只有是当前月，才显示当前日期为蓝色的
            if ([month isEqualToString:self.tem_month]) {
                if ((indexPath.row-3)==[calender_data.current_date integerValue]) {
                    cell.calenderTitle.textColor=BACKGROUND_COLOR;
                }
            }
            
        }
    }else if ([week isEqualToString:@"星期五"]){
        if (indexPath.row>4) {
            if ((indexPath.row-4)>self.month_total_days) {
                cell.calenderTitle.text=@"";
            }
            else{
            cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row-4];
            }
            //将月初日期字体缩小，并且改变内容
            if (indexPath.row==5) {
                NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
                //判断是不是十一月或十二月 将字体缩小
                if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                    cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }else{
                    cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }
            }
            //只有是当前月，才显示当前日期为蓝色的
            if ([month isEqualToString:self.tem_month]) {
                if ((indexPath.row-4)==[calender_data.current_date integerValue]) {
                    cell.calenderTitle.textColor=BACKGROUND_COLOR;
                }
            }
           
        }
    }else if ([week isEqualToString:@"星期六"]){
        if (indexPath.row>5) {
            if ((indexPath.row-5)>self.month_total_days) {
                cell.calenderTitle.text=@"";
            }
            else{
                 cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row-5];
            }
            //将月初日期字体缩小，并且改变内容
            if (indexPath.row==6) {
                NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
                //判断是不是十一月或十二月 将字体缩小
                if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                    cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }else{
                    cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                    cell.calenderTitle.text=month_str;
                }
            }
            //只有是当前月，才显示当前日期为蓝色的
            if ([month isEqualToString:self.tem_month]) {
                if ((indexPath.row-5)==[calender_data.current_date integerValue]) {
                    cell.calenderTitle.textColor=BACKGROUND_COLOR;
                }
            }
          
        }
    }else if ([week isEqualToString:@"星期日"]){
        if ((indexPath.row+1)>self.month_total_days) {
            cell.calenderTitle.text=@"";
        }
        else{
             cell.calenderTitle.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        }
        //将月初日期字体缩小，并且改变内容
        if (indexPath.row==0) {
            NSString *month_str=[calender_data.dateString monthForDateString:calender_data.dateString];
            //判断是不是十一月或十二月 将字体缩小
            if ([month_str isEqualToString:@"Nov 十一月"] | [month_str isEqualToString:@"Dec 十二月"]) {
                cell.calenderTitle.font=[UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium];
                cell.calenderTitle.text=month_str;
            }else{
                cell.calenderTitle.font=[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
                cell.calenderTitle.text=month_str;
            }
        }
        //只有是当前月，才显示当前日期为蓝色的
        if ([month isEqualToString:self.tem_month]) {
            if ((indexPath.row+1)==[calender_data.current_date integerValue]) {
                cell.calenderTitle.textColor=BACKGROUND_COLOR;
            }
        }
        
    }
    
    //该部分是对日历已经完成任务的日期背景填充颜色的
    //从数据库中查到数据以字符串来比较，如过和当前的日期一样的话就将背景置为绿色
    //开始循环，如果cell里面的文字日期和数据库中存的日一样的话，则改变背景的颜色为绿色
    for (NSDictionary *resault_dict in [[CheckedModel shareCheckedModel] selectEveryThingById:self.index_calender]){
        NSString *checked_dateString=[NSString stringFrom:[resault_dict objectForKey:@"checked"]];//得到数据库中存的日期的字符串
        if ([year isEqualToString:[checked_dateString substringWithRange:NSMakeRange(0, 4)]]) {
            //确定年一致
            if ([month isEqualToString:[checked_dateString substringWithRange:NSMakeRange(5, 2)]]) {
                //确定月一致
                //对数据库里面得到的日期文字进行处理，把01转化为1
                //需要对获得到的月初进行转化
                NSString *cell_text=cell.calenderTitle.text;
                if ([cell_text isEqualToString:@"Jan 一月"] | [cell_text isEqualToString:@"Feb 二月"] | [cell_text isEqualToString:@"Mar 三月"] | [cell_text isEqualToString:@"Apr 四月"] | [cell_text isEqualToString:@"May 五月"] | [cell_text isEqualToString:@"Jun 六月"] | [cell_text isEqualToString:@"Jul 七月"] | [cell_text isEqualToString:@"Aug 八月"] | [cell_text isEqualToString:@"Sep 九月"] | [cell_text isEqualToString:@"Oct 十月"] | [cell_text isEqualToString:@"Nov 十一月"] | [cell_text isEqualToString:@"Dec 十二月"]) {
                    cell_text=[cell_text monthfirstString:cell_text];
                }
                if ([cell_text isEqualToString:[[checked_dateString substringWithRange:NSMakeRange(8, 2)] simpleDayFrom:[checked_dateString substringWithRange:NSMakeRange(8, 2)]]]) {
                    cell.backgroundColor=CALENDER_GREEN;
                }
            }
        }
    }
    
    
    return cell;
}

//暂时先不做item的事件点击
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    //选择item的代理方法
//    //1.将所有的item的背景先清空
//    for (NSInteger row = 0; row < 35; row++) {
//        NSIndexPath *indexPath_forcal = [NSIndexPath indexPathForItem:row inSection:0];
//        CalenderCollectionViewCell *cell_forcal=(CalenderCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath_forcal];
//        cell_forcal.layer.borderColor=CALENDER_GRAY.CGColor;
//        cell_forcal.layer.borderWidth=0;
//    }
//
//    //2.将点击的item边框改变
//    CalenderCollectionViewCell *cell=(CalenderCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.layer.borderColor=CALENDER_BLUE.CGColor;
//    cell.layer.borderWidth=3;
//
//    //3.STPopup的业务逻辑，显示备注，
//    //发送通知，让自己的viewController展示ViewControler
//    //需要传送的数据是：查询所需的任务标题和当前点击的item日期
//    //1.根据索引查询出当前任务的标题
//    //2.把当前点击日期的indexPath得到，根据indexPath查询出当前日期字符串
//    NSString *did_select_date=[NSString stringWithFormat:@"%@-%@-%@",[CalenderData sharedCalenderData].year,[CalenderData sharedCalenderData].month,[cell.calenderTitle.text  simpleDayStringFrom:cell.calenderTitle.text]];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"stpopup" object:nil userInfo:@{@"subject_title":[[[[AddModel shareAddMode] selectEveryThing] objectAtIndex:self.index_calender] objectForKey:@"subject_title"],
//                                                                                                @"didSelect_item_date":did_select_date
//                                                                                                    }];
//}
//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(SIZE,SIZE+5);
    return size;
}

//水平之间cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

#pragma mark 多余的方法
-(BOOL)isSpecial:(int)year{
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
