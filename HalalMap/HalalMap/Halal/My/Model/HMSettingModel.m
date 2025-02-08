//
//  HMSettingModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSettingModel.h"

@implementation HMSettingModel

+(HMSettingModel *)settingModelWithType:(HMSettingType)settingType title:(NSString *)title
{
    HMSettingModel * model = [[HMSettingModel alloc] init];
    model.settingType = settingType;
    model.title = title;
    return model;
}

@end
