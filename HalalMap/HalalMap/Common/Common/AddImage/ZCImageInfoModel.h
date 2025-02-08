//
//  ZCImageInfoModel.h
//  Outing
//
//  Created by yj on 14-11-14.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCImageInfoModel : NSObject

@property (nonatomic,copy) NSString *imagePath,*imageName,*imageWidth,*imageHeight;

- (NSDictionary *)imageInfoDic;


@end
