//
//  HMUserModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HMSexTypeMan = 0, //男
    HMSexTypeWoman,//女
} HMSexType;


@interface HMUserModel : NSObject

@property (nonatomic, copy) NSString * user_unique_key;//用户唯一id
@property (nonatomic, copy) NSString * nickname;//昵称
@property (nonatomic, copy) NSString * signature;//个人签名
@property (nonatomic, copy) NSString * avatar;//头像的绝对地址
@property (nonatomic, copy) NSString * birthday;//生日
@property (nonatomic, copy) NSString * gender;//性别
@property (nonatomic, copy) NSString * race;//民族
@property (nonatomic, copy) NSString * group_id;//用户分组id，0为普通用户，1为管理员，2为Root
@property (nonatomic, copy) NSString * api_token;//登录权限，即access_token

@end
