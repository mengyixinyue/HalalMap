//
//  HMPOIModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/18.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMPhotoModel.h"
#import "HMCommentModel.h"

@interface HMPOIModel : NSObject

@property (nonatomic, copy) NSString * poi_guid;//poi唯一标识
@property (nonatomic, copy) NSString * poi_name;//poi名字
@property (nonatomic, copy) NSString * poi_address;//poi地址
@property (nonatomic, copy) NSString * poi_lon;//经度
@property (nonatomic, copy) NSString * poi_lat;//纬度
@property (nonatomic, copy) NSString * poi_distance;//离给定坐标的距离
@property (nonatomic, copy) NSString * poi_telephone;//电话
@property (nonatomic, copy) NSString * poi_open_time;//营业时间
@property (nonatomic, copy) NSString * poi_stars;//评分
@property (nonatomic, copy) NSString * poi_is_avoid_drink;//是否禁酒
@property (nonatomic, copy) NSString * poi_is_halal_certified;//是否清真认证
@property (nonatomic, copy) NSString * poi_dp_comment_link;//在点评里的链接
@property (nonatomic, strong) NSArray * poi_photos;//poi的图片数组
@property (nonatomic, strong) HMPhotoModel * poi_photo;//poi的封面图片
@property (nonatomic, copy) NSString * comments;//poi的评论数组
@property (nonatomic, copy) NSString * comment_count;//评论的个数
@property (nonatomic, copy) NSString * is_current_user_favorited;//当前用户是否已收藏该poi

-(CLLocationCoordinate2D)getLocationCoordinate2D;


@end
