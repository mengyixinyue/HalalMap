//
//  HMFeedModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMFeedModel.h"

@implementation HMFeedModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"feed_images" : [HMPhotoModel class],
             @"feed_votes" : [HMVoteModel class],
             @"feed_comments" : [HMCommentModel class],
             };
}

@end
