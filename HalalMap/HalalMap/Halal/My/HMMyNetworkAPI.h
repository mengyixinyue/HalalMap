//
//  HMMyNetworkAPI.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#ifndef HMMyNetworkAPI_h
#define HMMyNetworkAPI_h


//我发布过的feed
#define HMRequestMyAddedFeedList @"v1/feed/add/list"

//收藏列表
#define HMRequestMyFavoriteList @"v1/poi/favorite/list"

//修改密码
#define HMRequestChangePassword @"v1/user/password"

//修改个人资料
#define HMRequestEditPersonInfo @"v1/user/profile"

//x修改个人头像
#define HMRequestChangeHeaderImage @"v1/user/avatar"

//用户个人信息
#define HMRequestUserInfo(user_unique_key) [NSString stringWithFormat:@"v1/user/info/%@", user_unique_key]

//民族列表
#define HMRequestRacesList @"v1/metadata/races"

#define HMRequestFeedback @"v1/feedback"

#endif /* HMMyNetworkAPI_h */
