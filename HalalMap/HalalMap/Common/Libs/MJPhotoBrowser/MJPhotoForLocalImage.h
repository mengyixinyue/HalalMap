//
//  MJPhotoForLocalImage.h
//  Outing
//
//  Created by yj on 14/12/10.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZCImageInfoModel.h"

@interface MJPhotoForLocalImage : NSObject

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic, strong) ZCImageInfoModel *imageInfoModel;

@property (nonatomic,assign) BOOL selected;
@property (nonatomic, assign) int index; // 索引
@property (nonatomic, assign) BOOL firstShow;

@end
