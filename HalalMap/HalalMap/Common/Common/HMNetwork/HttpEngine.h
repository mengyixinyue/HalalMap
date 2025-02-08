//
//  HttpEngine.h
//  Outing
//
//  Created by 张超毅 on 14-9-17.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "MKNetworkKit.h"
#import <MapKit/MapKit.h>
#import "HMNetResponse.h"


typedef void(^requestSuccessBlock)(id data);
typedef void(^requestFailBlock)(NSString *errorCode, NSString *errorMsg, NSError* error);

@interface HttpEngine : MKNetworkEngine
{
    //判断网络是否连接
	Reachability* internetReach;
}

+ (HttpEngine *)sharedHttpEngine;
- (BOOL)checkIsWifi;

-(BOOL)checkNetwork:(NSString *)errorMessage;
- (BOOL)checkShowNoNetworkError;

-(MKNetworkOperation *)requestWithPath:(NSString *)path
                                params:(NSDictionary *)params
                            httpMethod:(NSString*)method
                               success:(void(^)(HMNetResponse *response))success
                               failure:(void(^)(HMNetResponse *response, NSError * error))failure;
#pragma mark - Muilt_Post images
-(MKNetworkOperation *)multipartPostImagesWithPath:(NSString *)path
                                            params:(NSDictionary *)params
                                       imagesPaths:(NSArray *)imagesPaths
                                        onProgress:(void(^)(double progress))progressBlock
                                           success:(void(^)(HMNetResponse *response))success
                                           failure:(void(^)(HMNetResponse *response, NSError * error))failure;

-(MKNetworkOperation *)postHeadImagesWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                   imagesPath:(NSString *)imagePath
                                   onProgress:(void(^)(double progress))progressBlock
                                      success:(void(^)(HMNetResponse *response))success
                                      failure:(void(^)(HMNetResponse *response, NSError * error))failure;

@end

@interface MKNetworkOperation(null)
- (id)responseJSONRemoveNull;
@end

@interface MKNetworkOperation (errorString)

- (NSString *)errorString;

@end

//防止数组调用[@"key"]崩溃
@interface NSArray(exception)
- (id)objectForKey:(NSString *)key;
- (id)objectForKeyedSubscript:(id)key;
@end

@interface NSMutableDictionary(turnNil)
- (void)setValueReal:(id)value forKey:(NSString *)key;
@end

static inline NSString* tranJSON(id components) {
    if (!components) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:components options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
