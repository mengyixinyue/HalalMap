//
//  HMPOINetworkAPI.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#ifndef HMPOINetworkAPI_h
#define HMPOINetworkAPI_h

//餐厅详情
#define HMRequestPOIDetail(poi_guid)  ([NSString stringWithFormat:@"v1/poi/%@", poi_guid])

//餐厅评论列表
#define HMRequestPOICommentList(poi_guid) ([NSString stringWithFormat:@"v1/poi/%@/comment/list", poi_guid])

//poi图片列表
#define HMRequestPOIPictureList(poi_guid)     ([NSString stringWithFormat:@"v1/poi/%@/photos", poi_guid])


//发布 需要登录
#define HMRequestAddPOI @"v1/poi/add"

//上传图片 需要登录
#define HMRequestPostPOIImages(poi_guid)  ([NSString stringWithFormat: @"v1/poi/%@/image", poi_guid])

//收藏POI
#define HMRequestFavoritePOI(poi_guid)  ([NSString stringWithFormat: @"v1/poi/%@/favorite", poi_guid])

//申请修改POI
#define HMRequestModifyPOI(poi_guid) ([NSString stringWithFormat: @"v1/poi/%@/modify", poi_guid])

//评价标签
#define HMRequestTagList @"v1/poi/tag/list"

//POI发布评论
#define HMRequestPublishComment(poi_guid) ([NSString stringWithFormat: @"v1/poi/%@/comment", poi_guid])

#endif /* HMPOINetworkAPI_h */
