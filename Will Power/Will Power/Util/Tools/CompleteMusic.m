//
//  CompleteMusic.m
//  Will Power
//
//  Created by jitengjiao      on 2018/4/10.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "CompleteMusic.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation CompleteMusic

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
void soundCompleteCallBack_complete(SystemSoundID soundID, void    *clientData) {
    //    NSLog(@"播放完成");
}
- (void)playSoundEffect_complete{
    //获取音效文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"message.mp3" ofType:nil];
    //创建音效文件URL
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    //音效声音的唯一标示ID
    SystemSoundID soundID = 0;
    //将音效加入到系统音效服务中，NSURL需要桥接成CFURLRef，会返回一个长整形ID，用来做音效的唯一标示
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //设置音效播放完成后的回调C语言函数
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack_complete,NULL);
    //开始播放音效
    AudioServicesPlaySystemSound(soundID);
}
@end
