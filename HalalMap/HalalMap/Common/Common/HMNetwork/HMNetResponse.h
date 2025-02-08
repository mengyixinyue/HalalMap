//
//  HMNetResponse.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMNetPageInfo.h"

@interface HMNetResponse : NSObject

// 服务端网络不通(近似)；(code == HDResponseServerNotReachableErrorCode)
@property (nonatomic) BOOL notReachable;
// http协议报错(400,500,404等)
@property (nonatomic,strong) NSError *httpError;

// 服务端的响应码
@property (nonatomic) NSInteger errocode;
// 服务器返回的内容
@property (nonatomic,strong) id response;

// 服务端的响应信息
@property (nonatomic, copy) NSString *message;

// 或为返回的JSON文本中的content(NSDictionary或NSArray型)字段的内容，或为图片、语音等资源数据(NSData型)；资源数据只有content部分；
@property (nonatomic, strong) id data;

// 翻页数据的页面信息
@property (nonatomic, strong) HMNetPageInfo *pageInfo; // will be nil if there isn't a paged list.

// 初始化方法(id)
- (instancetype)initWithData:(id)responseData;

// 初始化方法(NSDictionary)
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
