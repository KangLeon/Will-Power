//
//  TapMusic.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/3.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "TapMusic.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TapMusic ()



@end

@implementation TapMusic

+(instancetype)shareTapMusic{
    static TapMusic *tapMuisc=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tapMuisc==nil) {
            tapMuisc=[[TapMusic alloc] init];
        }
    });
    return tapMuisc;
}

#pragma mark 播放音乐部分
void soundCompleteCallBack(SystemSoundID soundID, void    *clientData) {
//    NSLog(@"播放完成");
}
- (void)playSoundEffect{
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"tap3.mp3" ofType:nil];
    //创建音效文件URL
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    //音效声音的唯一标示ID
    SystemSoundID soundID = 0;
    //将音效加入到系统音效服务中，NSURL需要桥接成CFURLRef，会返回一个长整形ID，用来做音效的唯一标示
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //设置音效播放完成后的回调C语言函数
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
    //开始播放音效
    AudioServicesPlaySystemSound(soundID);
}

//用于runtime交换方法的实现
-(void)empty{
    NSLog(@"交换了");
}






@end
