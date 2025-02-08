//
//  HMFeedModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMUserModel.h"
#import "HMVoteModel.h"
#import "HMCommentModel.h"
#import "HMPOIModel.h"
#import "HMPhotoModel.h"

@interface HMFeedModel : NSObject

@property (nonatomic, copy) NSString * feed_guid;// feed唯一标识
@property (nonatomic, copy) NSString * feed_created_at;// 创建时间，eg：“1457589727”
@property (nonatomic, copy) NSString * feed_description;// feed描述，长度为1到1500个字符
@property (nonatomic, copy) NSString * feed_is_in_restaurant;// 美食是否来自餐馆
@property (nonatomic, copy) NSString * feed_is_public;// 是否公开
@property (nonatomic, strong) HMUserModel * feed_publisher;// User 发布者
@property (nonatomic, strong) NSMutableArray * feed_images;// feed的所有图片
@property (nonatomic, strong) NSMutableArray * feed_votes;// feed的赞
@property (nonatomic, strong) NSMutableArray * feed_comments;// feed的评论
@property (nonatomic, strong) HMPOIModel * feed_related_poi;// feed关联的poi
@property (nonatomic, copy) NSString * feed_related_poi_guid;//  feed关联的poi的唯一标识
@property (nonatomic, copy) NSString * hasVoted;//是否已赞

@end
