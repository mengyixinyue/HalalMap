//
//  HMCommentModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMCommentModel.h"

@implementation HMCommentModel

+(CGFloat)heightWithFiveLinew
{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < 5; i++) {
        if (i == 4) {
            [str appendFormat:@"测试文字"];
        }else{
            [str appendString:@"测试文字\n"];
        }
    }
    CGSize size = [str sizeAutoFitIOS7WithFont:[HMFontHelper fontOfSize:11.0f] constrainedToSize:CGSizeMake(ScreenWidth - 60 - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return size.height;
}

+(CGFloat)heightWithComment:(NSString *)comment
{
    CGSize size = [comment sizeForFont:[HMFontHelper fontOfSize:11.0f] size:CGSizeMake(ScreenWidth - 60 - 20, MAXFLOAT)  mode:NSLineBreakByCharWrapping];
    return size.height;
}

@end
