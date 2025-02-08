//
//  HMCommons.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

//公共的
#ifndef HMCommons_h
#define HMCommons_h

#import "Macrodefinition.h"
#import "SynthesizeSingleton.h"

#import "HttpEngine.h"

#import "BSUIBarButtonItem.h"

#import "HMFontHelper.h"
#import "HMHelper.h"

#import "HMRunData.h"



#define ERROR_MESSAGE   @"网络错误"
#define ERROR_MESSAGE_NETWORK @"您似乎中断了与网络的连接"

#define ERRORMESSAGESHOWTIME  (2)
#define SUCCESSMESSAGESHOWTIME  (1)

#define isIOS(a)    ([[[UIDevice currentDevice] systemVersion] floatValue] >= a)
#define PRE_IOS_8            ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)//小于ios8.0的版本

#define ScreenWidth                         ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight                         ([UIScreen mainScreen].bounds.size.height)

#define StatusBarHeight  ([[UIApplication sharedApplication]statusBarFrame].size.height)

#define SCREEN_HEIGHT_NONAV ([UIScreen mainScreen].bounds.size.height-44 - StatusBarHeight) //去掉导航条的屏幕高度
#define SCREEN_HEIGHT_NOBAR ([UIScreen mainScreen].bounds.size.height-44 -49 - StatusBarHeight) //去掉导航条和tabbar的屏幕高度



#define REGULAR_PHONE   @"^1[34578][0-9]{9}$"

typedef void(^loginSuccessBlock)(void);

#define NotificationLoginSuccess    @"notificationLoginSuccess"//登录成功通知
#define NotificationLogOut          @"notificationLogOut"//退出登录


#define HMAppName           [HMHelper getApplicationName]
#define HMURLScheme         [HMHelper getApplicationScheme]

typedef enum : NSUInteger {
    HMHomePageShowTypeMap = 1,
    HMHomePageShowTypeList,
} HMHomePageShowType;

#define HMHomePageShowTypeKey @"HMHomePageShowType"
#define HMHomePageSelectCityKey @"HMHomePageSelectCityKey"

#endif /* HMCommons_h */
