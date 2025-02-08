//
//  HMLoginAndRegisterAPI.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/9.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#ifndef HMLoginAndRegisterAPI_h
#define HMLoginAndRegisterAPI_h

//获取注册验证码
#define HMRequestSendRegisterVeriCode @"v1/auth/sendRegisterVeriCode"

//获取找回密码验证码
#define HMRequestSendFindPWVeriCode @"v1/auth/sendFindPWVeriCode"

//注册
#define HMRequestRegister @"v1/user/register"

//登录
#define HMRequestLogin @"v1/auth/login"

//重设密码
#define HMRequestResetPassword @"v1/auth/resetPassword"

#endif /* HMLoginAndRegisterAPI_h */
