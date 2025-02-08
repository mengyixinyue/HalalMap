//
//  HMNetwork.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMNetPageInfo.h"
#import "HMNetResponse.h"
#import "HttpEngine.h"

@interface HMNetwork : NSObject

/**
 *  post请求 默认失败处理
 *
 *  @param path       url
 *  @param params     参数字典
 *  @param modelClass 类型
 *  @param success    成功回调   失败默认是弹SVProgress
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)postRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                modelClass:(Class)modelClass
                                   success:(void(^)(id object, HMNetPageInfo *pageInfo))success;

/**
 *  post请求 需要自己处理失败情况  用于有失败页面的请求
 *
 *  @param path       url
 *  @param params     参数字典
 *  @param modelClass 类型
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)postRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                modelClass:(Class)modelClass
                                   success:(void(^)(id object, HMNetPageInfo *pageInfo))success
                                   failure:(void (^)(HMNetResponse *response, NSString * errorMsg))failure;

/**
 *  post请求 无解析的基本请求方法，自行处理
 *
 *  @param path    url
 *  @param params  参数字典
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)postRequestWithPath:(NSString *)path
                                    params:(NSDictionary *)params
                                   success:(void(^)(HMNetResponse *response))success
                                   failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure;

/**
 *  delete请求   无解析的基本请求方法，自行处理
 *
 *  @param path    url
 *  @param params  参数字典
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)deleteRequestWithPath:(NSString *)path
                                      params:(NSDictionary *)params
                                     success:(void(^)(HMNetResponse *response))success
                                     failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure;

/**
 *  get请求 默认失败处理
 *
 *  @param path       url
 *  @param params     参数字典
 *  @param modelClass 类型
 *  @param success    成功回调   失败默认是弹SVProgress
 *
 *  @return MKNetworkOperation 
 */
+(MKNetworkOperation *)getRequestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               modelClass:(Class)modelClass
                                  success:(void(^)(id object, HMNetPageInfo *pageInfo))success;

/**
 *  get请求 需要自己处理失败情况  用于有失败页面的请求
 *
 *  @param path       url
 *  @param params     参数字典
 *  @param modelClass 类型
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)getRequestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               modelClass:(Class)modelClass
                                  success:(void(^)(id object, HMNetPageInfo *pageInfo))success
                                  failure:(void (^)(HMNetResponse *response, NSString * errorMsg))failure;

/**
 *  get请求 无解析的基本请求方法，自行处理
 *
 *  @param path    url
 *  @param params  参数字典
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)getRequestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                                  success:(void(^)(HMNetResponse *response))success
                                  failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure;

/**
 *  上传表单接口请求
 *
 *  @param path          url
 *  @param params        参数字典
 *  @param filePaths     文件路径
 *  @param progressBlock 上传进度
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 *  @return MKNetworkOperation
 */
+(MKNetworkOperation *)multipartPostImagesWithPath:(NSString *)path
                                            params:(NSDictionary *)params
                                       imagesPaths:(NSArray *)imagesPaths
                                        onProgress:(void(^)(double progress))progressBlock
                                           success:(void(^)(HMNetResponse *response))success
                                           failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure;

+(MKNetworkOperation *)postHeadImagesWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                   imagesPath:(NSString *)imagePath
                                   onProgress:(void(^)(double progress))progressBlock
                                      success:(void(^)(HMNetResponse *response))success
                                      failure:(void(^)(HMNetResponse *response, NSString *errorMsg))failure;
@end
