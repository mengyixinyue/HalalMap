//
//  HMUserModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMUserModel.h"

@implementation HMUserModel
//gender

-(NSString *)gender
{
    switch ([_gender integerValue]) {
        case HMSexTypeMan:
        {
            return @"男";
        }
            break;
        case HMSexTypeWoman:
        {
            return @"女";
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
