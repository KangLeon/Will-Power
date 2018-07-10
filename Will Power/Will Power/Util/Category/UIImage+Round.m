//
//  UIImage+Round.m
//  Will Power
//
//  Created by 吉腾蛟 on 2018/6/26.
//  Copyright © 2018年 JiYoung. All rights reserved.
//

#import "UIImage+Round.h"

@implementation UIImage (Round)
- (UIImage *)hyb_imageWithCornerRadius:(CGFloat)radius{
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
