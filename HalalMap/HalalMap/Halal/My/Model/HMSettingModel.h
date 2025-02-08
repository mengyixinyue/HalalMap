//
//  HMSettingModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HMSettingTypePersonalInfo,//个人资料
    HMSettingTypeChangePassword,//修改密码
    HMSettingTypeHomePageShowType,//首页默认显示形式
    HMSettingTypeClearCache,//清除缓存
    HMSettingTypeSuggest,//意见与建议
    HMSettingTypeGotoComment,//五星好评
    HMSettingTypeAbout//关于
} HMSettingType;

@interface HMSettingModel : NSObject

@property (nonatomic, assign) HMSettingType settingType;
@property (nonatomic, copy) NSString * title;

+(HMSettingModel *)settingModelWithType:(HMSettingType)settingType title:(NSString *)title;

@end
