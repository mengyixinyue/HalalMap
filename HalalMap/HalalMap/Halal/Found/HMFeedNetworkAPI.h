//
//  HMFeedNetworkAPI.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#ifndef HMFeedNetworkAPI_h
#define HMFeedNetworkAPI_h

typedef enum : NSUInteger {
    HMReportTypeNoHalal,
    HMReportTypeCustom,
} HMReportType;


//Feed 列表
#define HMRequestFeedList @"v1/feed/list"

//用关键词搜索某城市内的POI
#define HMRequestSearchKeywordPOI(city_guid)  ([NSString stringWithFormat:@"v1/poi/%@/search", city_guid])


//发布feed
#define  HMRequestPublishFeed       @"v1/feed/add"


#define HMRequestFeedVote(feed_guid)  ([NSString stringWithFormat:@"v1/feed/%@/vote", feed_guid])


//举报FEED或者向餐厅反馈意见
#define HMRequestClaim              @"v1/claim"

//发布一条评论
#define HMRequestComment(feed_guid)   ([NSString stringWithFormat:@"v1/feed/%@/comment", feed_guid])



#endif /* HMFeedNetworkAPI_h */
