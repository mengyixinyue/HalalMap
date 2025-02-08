//
//  HMHelper.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMAddressModel.h"
#import "HMCitiesModel.h"


@interface HMHelper : NSObject
/**
 *  通过xib创建一个对象
 *
 *  @param className xib的名字
 *
 *  @return <#return value description#>
 */
+(id)xibWithClass:(Class)className;


/**
 *  通过xib创建的VC
 *
 *  @param className 类名
 *
 *  @return vc对象
 */
+(id)xibWithViewControllerClass:(Class)className;


/**
 *  判断网络状态
 *
 *  @param showErrorMsg 是否展示无网时的错误信息
 *
 *  @return 有网返回YES，无网则返回NO
 */
+(BOOL)netIsConnectedWithShowErrorMsg:(BOOL)showErrorMsg;

/**
 *  图片liberary
 *
 *  @return <#return value description#>
 */
+ (ALAssetsLibrary *)defaultAssetsLibrary;

/**
 *  图片保存在沙盒目录的路径
 *
 *  @return <#return value description#>
 */
+(NSString *)imageSavePath;

/**
 *  是否登录
 *
 *  @return <#return value description#>
 */
-(BOOL)isLogin;

/**
 *  获取appname
 *
 *  @return appname
 */
+ (NSString *)getApplicationName;


/**
 *  获取app scheme
 *
 *  @return app url scheme
 */
+ (NSString *)getApplicationScheme;

/**
 *  获取当前定位地区的信息
 *
 *  @param lon     经度    
 *  @param lat     纬度
 *  @param success 返回地区model
 *  @param faile   返回错误信息
 */
+(void)getCityWithLon:(NSString *)lon lat:(NSString *)lat success:(void(^)(HMAddressModel * model))success faile:(void(^)(NSString *errorMsg))faile;

/**
 *  获取之前选择的城市
 *
 *  @return cityModel 只有id和name
 */
+(HMCitiesModel *)getSelectedCity;

/**
 *  保存当前选择的城市model
 *
 *  @param model cityModel 只保存了id和name
 */
+(void)saveSelectedCity:(HMCitiesModel *)model;

@end
