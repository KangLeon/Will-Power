//
//  GetSaying.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/7/13.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "GetSaying.h"

@interface GetSaying ()

@property(nonatomic,strong)NSArray *sayingsArray;

@end

@implementation GetSaying
+(instancetype)shareGetSaying{
    static GetSaying *getSaying;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getSaying=[[GetSaying alloc] init];
    });
    return getSaying;
}

-(NSArray *)sayingsArray{
    if (!_sayingsArray) {
        _sayingsArray=@[@"人生中有两种痛苦，一种是努力的痛苦，一种是后悔的痛苦，而后者要比前者大千倍。",
                        @"认识自我、关心自我和提醒自己真正重要的事物，这三种方法正是自我控制的基石。",
                        @"自控力最强的人不是从与自我的较量中获得自控，而是学会了如何接受相互冲突的自我，并将这些自我融为一体。",
                        @"不要总想着今天犯错，明天补救，不要向明天赊账，明天和今天毫无差别。",
                        @"你需要一个生活规划，帮你结束内心的挣扎。",
                        @"你需要静下心来，弄清自己的欲望。",
                        @"人生短暂，逝者如斯。",
                        @"在意志力挑战中获胜的关键，在于学会利用原始本能，而不是反抗那些本能。",
                        @"长期睡眠不足哼容易让你感到压力，萌生欲望，收到诱惑。",
                        @"在我看来，能够战胜自己欲望的人比那些能征服自己敌人的更为勇敢，因为最难取得的胜利便是对自己的胜利。",
                        @"敌人就在门内，它与我们的奢侈、愚蠢和恶性同在，我们必须与之斗争。",
                        @"我们有力量去做的事，也有力量不去做。",
                        @"劝君莫惜金缕衣,劝君惜取少年时.有花堪折直须折,莫待无花空折枝。",
                        @"我们要有最朴素的生活，与最遥远的梦想，及时明日天寒地冻，路远马亡。",
                        @"要么庸俗，要么孤独。",
                        @"自律的代价总是要比后悔低。",
                        @"浪费时间的恶果需要自己来承担。",
                        @"环境越是糟糕越要提醒自己不忘自省，自律。",
                        @"跑步教会我的是自律，是克制，是不放弃，是死磕到底。",
                        @"任何让你一时很爽的事情都不会是真正的好事情。",
                        @"当你真正喜欢做一件事时，自律就会成为你的本能。",
                        @"懒惰和放纵会吞噬一个人的斗志，使他被困在生活琐碎而短暂的享受中。",
                        @"逼迫自己做一些非常消耗自控力的事，在短期会让你的自控力下降；而是不是这样做，却能让你的自控力在长期有一个提升。",
                        @"那些有自控力的人都值得我妒忌和敬佩。",
                        @"我的身体是由我控制的，而不是我的身体。",
                        @"如果你周围的人都是很有自控的人，你也会变得更加自控。"
                     ];
    }
    return _sayingsArray;
}

-(NSString *)getRandomSaying{
    NSInteger value=(arc4random()%(self.sayingsArray.count-1));//获取在数组范围内的字符串索引
    return self.sayingsArray[value];
}

@end
