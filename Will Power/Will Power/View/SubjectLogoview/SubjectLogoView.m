//
//  SubjectLogoView.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/13.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "SubjectLogoView.h"
#import "SizeDefine.h"
#import "ColorDefine.h"
#import <Masonry.h>


static NSString *cell_id=@"reuse_collection_subject";

@interface SubjectLogoView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIImageView *title_imageView;
@property(nonatomic,strong)UILabel *title_label;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UIView *back_view;
@property(nonatomic,strong)UIImageView *next_imageView;
@property(nonatomic,strong)UILabel *next_label;

@end

@implementation SubjectLogoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
//        [self updateConstraintsIfNeeded];
    }
    return self;
}

-(void)loadUI{
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=12;
    [self addSubview:self.title_imageView];
    [self addSubview:self.title_label];
    [self addSubview:self.collectionView];
    [self addSubview:self.back_view];
}

#pragma mar 懒加载部分
-(UIImageView *)title_imageView{
    if (!_title_imageView) {
        _title_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        _title_imageView.image=[UIImage imageNamed:@"select_your_icon"];
    }
    return _title_imageView;
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
        _title_label.text=@"选择图标";
        _title_label.textColor=[UIColor grayColor];
        _title_label.textAlignment=NSTextAlignmentCenter;
        _title_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightThin];
    }
    return _title_label;
}

-(UICollectionView*)collectionView{
    if (!_collectionView) {
        //实例化
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        //每个item的size
        //        layout.itemSize=CGSizeMake((SCREEN_WIDTH-20-3*6)/7, (SCREEN_WIDTH-20-5*6)/7+5);
        
        //滑动方向
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(20, 50, (SCREEN_WIDTH-60), 200) collectionViewLayout:layout];
        
        _collectionView.backgroundColor=[UIColor whiteColor];
        
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        
//        //注册id
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cell_id];
        //不自定义cell了，使用默认的cell
    }
    return _collectionView;
}

-(UIView *)back_view{
    if (!_back_view) {
        _back_view=[[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-150)/2, 250, 150, 60)];
        _back_view.backgroundColor=[UIColor whiteColor];
        _back_view.layer.cornerRadius=8;
        [_back_view addSubview:self.next_imageView];
        [_back_view addSubview:self.next_label];
    }
    return _back_view;
}

-(UIImageView*)next_imageView{
    if (!_next_imageView) {
        _next_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        _next_imageView.image=[UIImage imageNamed:@"down_for_more"];
    }
    return _next_imageView;
}

-(UILabel *)next_label{
    if (!_next_label) {
        _next_label=[[UILabel alloc] initWithFrame:CGRectMake(55, 15, 95, 30)];
        _next_label.text=@"更多图标";
        _next_label.textColor=[UIColor grayColor];
        _next_label.textAlignment=NSTextAlignmentCenter;
        _next_label.font=[UIFont systemFontOfSize:18.0 weight:UIFontWeightThin];
    }
    return _next_label;
}

-(NSString *)image_index{
    if (!_image_index) {
        _image_index=@"2";
    }
    return _image_index;
}
#pragma mark 数据源与代理
#pragma mark --collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 62;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    }
    cell.backgroundColor=[UIColor clearColor];//初始的默认背景是灰色的
    
    UIImageView *imageView_for_content=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    NSString *string_tem=[NSString stringWithFormat:@"%ld.png",indexPath.row+1];
    imageView_for_content.image=[UIImage imageNamed:string_tem];
    cell.contentView.layer.borderColor=[UIColor whiteColor].CGColor;
    cell.contentView.layer.borderWidth=0;
    //判断image_index的值
    if ([[NSString stringWithFormat:@"%ld",indexPath.row+1] isEqualToString:self.image_index]) {
        cell.contentView.layer.borderColor=BACKGROUND_COLOR.CGColor;
        cell.contentView.layer.borderWidth=3;
    }
    
    [cell.contentView addSubview:imageView_for_content];
    
    return cell;
}

//collectionView的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //3.将点击的cell的值存在数据库中
    NSString *string_test=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    self.image_index=string_test;
    [collectionView reloadData];
}


//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(60,60);
    return size;
}

//水平之间cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
