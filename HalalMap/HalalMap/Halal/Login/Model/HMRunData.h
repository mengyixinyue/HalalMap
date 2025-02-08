//
//  HMUserModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/6.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMUserModel.h"

@interface HMRunData : NSObject

@property (nonatomic, strong) NSMutableDictionary* userInfoDic;
@property (nonatomic, strong) HMUserModel * userModel;
@property (nonatomic, assign) BOOL needReflashMyFeed;
@property (nonatomic, assign) BOOL needReflashMyPOI;


+(HMRunData *)sharedHMRunData;

/**
 *  是否是登录状态
 *
 *  @return <#return value description#>
 */
+(BOOL)isLogin;

/**
 *  同步用户信息
 */
-(void)userInfoSynchronize;

/**
 *  获取当前用户信息
 */
-(void)getUserInfo;

/**
 *  退出登录数据处理
 */
-(void)logout;

@end
