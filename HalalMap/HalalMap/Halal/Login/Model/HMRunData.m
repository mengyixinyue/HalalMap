//
//  HMUserModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/6.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMRunData.h"

#define HMUserInfo @"UserInfo"

@implementation HMRunData
SYNTHESIZE_SINGLETON_FOR_CLASS(HMRunData)

-(instancetype)init
{
    self = [super init];
    if (self) {
        _userInfoDic = [[NSMutableDictionary alloc] init];
        [self getUserInfo];
    }
    return self;
}

-(void)getUserInfo
{
    NSDictionary * dict = [USERDEFAULT objectForKey:HMUserInfo];
    self.userModel = [HMUserModel mj_objectWithKeyValues:dict];
}

+(BOOL)isLogin
{
    if (HMRunDataShare.userModel && HMRunDataShare.userModel.api_token && HMRunDataShare.userModel.api_token.length != 0) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)setUserInfoDic:(NSMutableDictionary *)userInfoDic
{
    [_userInfoDic setDictionary:userInfoDic];
    _userModel = [HMUserModel mj_objectWithKeyValues:userInfoDic];
}


-(void)userInfoSynchronize
{
    NSDictionary * userInfo = [self.userModel mj_JSONObject];
    [USERDEFAULT setObject:userInfo forKey:HMUserInfo];
    UserDefaultSynchronize;
}

-(void)logout
{
    self.userModel = nil;
    [USERDEFAULT removeObjectForKey:HMUserInfo];
    UserDefaultSynchronize;
    HM_POST_MSG(NotificationLogOut);
    
}

@end
