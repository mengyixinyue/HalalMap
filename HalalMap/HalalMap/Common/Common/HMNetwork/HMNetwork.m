//
//  HMNetwork.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMNetwork.h"

@implementation HMNetwork


+(MKNetworkOperation *)postRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                modelClass:(Class)modelClass
                                   success:(void(^)(id object, HMNetPageInfo *pageInfo))success
{
   return  [self postRequestWithPath:path params:params modelClass:modelClass success:success failure:^(HMNetResponse *response, NSString *errorMsg) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [SVProgressHUD showErrorWithStatus:errorMsg];
       });
    }];
}

+(MKNetworkOperation *)postRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                modelClass:(Class)modelClass
                                   success:(void(^)(id object, HMNetPageInfo *pageInfo))success
                                   failure:(void (^)(HMNetResponse *response, NSString * errorMsg))failure
{
    return [self postRequestWithPath:path params:params success:^(HMNetResponse *response) {
        if (response.response) {
            id result;
            id object = response.data;
            if ([object isKindOfClass:[NSArray class]]) {
                result = [modelClass mj_objectArrayWithKeyValuesArray:object];
            }
            else{
                result = [modelClass mj_objectWithKeyValues:object];
            }
            success(result, response.pageInfo);
        }
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        failure(response, errorMsg);
    }];
}

+(MKNetworkOperation *)postRequestWithPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(void(^)(HMNetResponse *response))success
                   failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure
{
    return [[HttpEngine sharedHttpEngine] requestWithPath:path params:params httpMethod:@"POST" success:success failure:^(HMNetResponse *response, NSError *error) {
            NSString * message;
            if (response.message && response.message.length != 0) {
                message = response.message;
            }
            else if (error.domain && error.domain.length != 0){
                message = error.domain;
            }
            else{
                message = ERROR_MESSAGE;
            }
            failure(response, message);
    }];
}

+(MKNetworkOperation *)deleteRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                   success:(void(^)(HMNetResponse *response))success
                                   failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure
{
    return [[HttpEngine sharedHttpEngine] requestWithPath:path params:params httpMethod:@"DELETE" success:success failure:^(HMNetResponse *response, NSError *error) {
        NSString * message;
        if (response.message && response.message.length != 0) {
            message = response.message;
        }
        else if (error.domain && error.domain.length != 0){
            message = error.domain;
        }
        else{
            message = ERROR_MESSAGE;
        }
        failure(response, message);
    }];
}

+(MKNetworkOperation *)getRequestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               modelClass:(Class)modelClass
                                  success:(void(^)(id object, HMNetPageInfo *pageInfo))success
{
    return  [self getRequestWithPath:path params:params modelClass:modelClass success:success failure:^(HMNetResponse *response, NSString *errorMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:errorMsg];
        });
    }];
}

+(MKNetworkOperation *)getRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                modelClass:(Class)modelClass
                                   success:(void(^)(id object, HMNetPageInfo *pageInfo))success
                                   failure:(void (^)(HMNetResponse *response, NSString * errorMsg))failure
{
    return [self getRequestWithPath:path params:params success:^(HMNetResponse *response) {
        if (response.response) {
            id result;
            id object = response.data;
            if ([object isKindOfClass:[NSArray class]]) {
                result = [modelClass mj_objectArrayWithKeyValuesArray:object];
            }
            else{
                result = [modelClass mj_objectWithKeyValues:object];
            }
            success(result, response.pageInfo);
        }
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
                failure(response, errorMsg);
    }];
}

+(MKNetworkOperation *)getRequestWithPath:(NSString *)path
                   params:(NSDictionary *)params
                  success:(void(^)(HMNetResponse *response))success
                  failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure
{
    return [[HttpEngine sharedHttpEngine] requestWithPath:path params:params httpMethod:@"GET" success:success failure:^(HMNetResponse *response, NSError *error) {
        NSString * message;
        if (response.message && response.message.length != 0) {
            message = response.message;
        }
        else if (error.domain && error.domain.length != 0){
            message = error.domain;
        }
        else{
            message = ERROR_MESSAGE;
        }
        failure(response, message);
    }];
}

+(MKNetworkOperation *)multipartPostImagesWithPath:(NSString *)path
                                            params:(NSDictionary *)params
                                       imagesPaths:(NSArray *)imagesPaths
                                        onProgress:(void(^)(double progress))progressBlock
                                           success:(void(^)(HMNetResponse *response))success
                                           failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure
{
    return [[HttpEngine sharedHttpEngine] multipartPostImagesWithPath:path params:params imagesPaths:imagesPaths onProgress:progressBlock success:success failure:^(HMNetResponse *response, NSError *error) {
        NSString * message;
        if (response.message && response.message.length != 0) {
            message = response.message;
        }
        else if (error.domain && error.domain.length != 0){
            message = error.domain;
        }
        else{
            message = ERROR_MESSAGE;
        }
        failure(response, message);
    }];
}


+(MKNetworkOperation *)postHeadImagesWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                   imagesPath:(NSString *)imagePath
                                   onProgress:(void(^)(double progress))progressBlock
                                      success:(void(^)(HMNetResponse *response))success
                                      failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure
{
    return [[HttpEngine sharedHttpEngine] postHeadImagesWithPath:path params:params imagesPath:imagePath onProgress:progressBlock success:success failure:^(HMNetResponse *response, NSError *error) {
        NSString * message;
        if (response.message && response.message.length != 0) {
            message = response.message;
        }
        else if (error.domain && error.domain.length != 0){
            message = error.domain;
        }
        else{
            message = ERROR_MESSAGE;
        }
        failure(response, message);
    }];
}
@end
