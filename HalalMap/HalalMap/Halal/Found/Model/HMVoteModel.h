//
//  HMVoteModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMUserModel.h"

@interface HMVoteModel : NSObject

@property (nonatomic, copy) NSString * vote_guid;//comment唯一标识
@property (nonatomic, strong) HMUserModel * vote_user;// 赞的人

@end
