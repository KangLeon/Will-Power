//
//  MusicSelect.h
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/2.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapMusicButton.h"

@interface MusicSelect : UIView
@property(nonatomic,strong)UITableView *musicTableView;
@property(nonatomic,strong)TapMusicButton *close_button;
@end
