//
//  ZCImageInfoModel.m
//  Outing
//
//  Created by yj on 14-11-14.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "ZCImageInfoModel.h"

@implementation ZCImageInfoModel

//@property (nonatomic,copy) NSString *imagePath,*imageName,*imageWidth,*imageHeight;
- (void)setDataWithDic:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

- (NSDictionary *)imageInfoDic
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:self.imagePath forKey:@"imagePath"];
    [muDic setObject:self.imageName forKey:@"imageName"];
    [muDic setObject:self.imageWidth forKey:@"imageWidth"];
    [muDic setObject:self.imageHeight forKey:@"imageHeight"];
    
    return muDic;
}

@end
