//
//  HttpEngine.m
//  Outing
//
//  Created by 张超毅 on 14-9-17.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "HttpEngine.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"

@implementation HttpEngine
SYNTHESIZE_SINGLETON_FOR_CLASS(HttpEngine)
- (id)init
{
    //Change the host name here to change the server your monitoring
    if (self = [super initWithHostName:@"qingzhenditu.com/api"]) {
        //通知 (网络状态变化)
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
		internetReach = [Reachability reachabilityForInternetConnection];
		[internetReach startNotifier];

    }
    return self;
}

#pragma mark Reachability
//监视网络状态,状态变化调用该方法.
- (void) reachabilityChanged: (NSNotification* )note
{
    if ([internetReach currentReachabilityStatus] != NotReachable) {
        //网络可用
        NSLog(@"网络可用");
    }
    else {
        //网络不可用
        NSLog(@"网络不可用");
    }
}
- (BOOL)checkIsWifi
{
    if ([internetReach currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    }
    return NO;
}

-(BOOL)checkNetwork:(NSString *)errorMessage
{
    if ([internetReach currentReachabilityStatus] == NotReachable) {
        if (errorMessage == nil) {
            return NO;
        }
        return NO;
    }
    return YES;
}

- (BOOL)checkShowNoNetworkError
{
    if (![self checkNetwork:nil]) {
//        [[ZCAlertHelper sharedZCAlertHelper] alertNetworkError];
        return NO;
    }
    return YES;
}

- (void)startOperation:(MKNetworkOperation *)op s:(MKNKResponseBlock)s f:(MKNKResponseErrorBlock)f
{
    NSLog(@"%@", op.url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//#ifdef DEBUG
//        NSDictionary *dic = [completedOperation responseJSON];
//        if (dic) {
//            NSLog(@"responseJSON:%@",dic);
//        }
//        else
//        {
//            NSLog(@"responseString:%@",[completedOperation responseString]);
//        }
//#endif
        if (s) {
//            NSLog(@"com:%@",completedOperation.responseString);
            s(completedOperation);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
#ifdef DEBUG
        NSLog(@"error:%@",[error description]);
#endif
        if (f) {
            f(completedOperation,error);
        }
    }];
    [self enqueueOperation:op];
}

- (NSMutableDictionary *)commonParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValueReal:@"halalmap" forKey:@"sign"];
    [params setValueReal:@"iOS" forKey:@"client"];
    [params setValueReal:currentShortVersionString forKey:@"app_version"];
    if ([HMRunData isLogin]) {
        [params setValueReal:HMRunDataShare.userModel.api_token forKey:@"api_token"];
    }
    return params;
}

-(MKNetworkOperation*) operationWithParams:(NSDictionary*) params
                              httpMethod:(NSString*)method  {
    NSMutableString * apiPath = [NSMutableString stringWithString:@"HalalAPI/Public/halalmap/index.php/"];
    return [super operationWithPath:apiPath params:params httpMethod:method];
}

-(MKNetworkOperation *)requestWithPath:(NSString *)path
                                params:(NSDictionary *)params
                            httpMethod:(NSString*)method
                               success:(void(^)(HMNetResponse *response))success
                               failure:(void(^)(HMNetResponse *response, NSError * error))failure

{
    NSMutableDictionary * mutableParams = [self commonParams];
    [mutableParams addEntriesFromDictionary:params];
    MKNetworkOperation *op = [self operationWithPath:path params:mutableParams httpMethod:method];
    
    [self startOperation:op s:^(MKNetworkOperation *completedOperation) {
        HMNetResponse * response = [[HMNetResponse alloc] initWithData:completedOperation.responseJSONRemoveNull];
        success(response);
    } f:^(MKNetworkOperation *completedOperation, NSError *error) {
        HMNetResponse * response = [[HMNetResponse alloc] initWithData:completedOperation.responseJSONRemoveNull];
        failure(response, error);
    }];
    return op;
}

#pragma mark - Muilt_Post images
-(MKNetworkOperation *)multipartPostImagesWithPath:(NSString *)path
                                            params:(NSDictionary *)params
                                       imagesPaths:(NSArray *)imagesPaths
                                        onProgress:(void(^)(double progress))progressBlock
                                           success:(void(^)(HMNetResponse *response))success
                                           failure:(void(^)(HMNetResponse *response, NSError * error))failure
{
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    //添加公共参数
    [allParams addEntriesFromDictionary:[self commonParams]];
    
    MKNetworkOperation * op = [self operationWithPath:path params:allParams httpMethod:@"POST"];
    for (NSString * imagePath in imagesPaths) {
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
        [op addData:UIImageJPEGRepresentation(image, 0.6) forKey:@"images[]" mimeType:@"mutipart/form-data" fileName:[NSString stringWithFormat:@"%lld.jpg",recordTime]];
    }
    [op onUploadProgressChanged:^(double progress) {
        progressBlock(progress);
    }];
    [self startOperation:op s:^(MKNetworkOperation *completedOperation) {
        HMNetResponse * response = [[HMNetResponse alloc] initWithData:completedOperation.responseJSONRemoveNull];
        success(response);
    } f:^(MKNetworkOperation *completedOperation, NSError *error) {
        HMNetResponse * response = [[HMNetResponse alloc] initWithData:completedOperation.responseJSONRemoveNull];
        failure(response, error);
    }];
    return op;
}

-(MKNetworkOperation *)postHeadImagesWithPath:(NSString *)path
                                            params:(NSDictionary *)params
                                       imagesPath:(NSString *)imagePath
                                        onProgress:(void(^)(double progress))progressBlock
                                           success:(void(^)(HMNetResponse *response))success
                                           failure:(void(^)(HMNetResponse *response, NSError * error))failure
{
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    //添加公共参数
    [allParams addEntriesFromDictionary:[self commonParams]];
    
    MKNetworkOperation * op = [self operationWithPath:path params:allParams httpMethod:@"POST"];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    [op addData:UIImageJPEGRepresentation(image, 0.6) forKey:@"avatar" mimeType:@"mutipart/form-data" fileName:[NSString stringWithFormat:@"%lld.jpg",recordTime]];
    [op onUploadProgressChanged:^(double progress) {
        progressBlock(progress);
    }];
    [self startOperation:op s:^(MKNetworkOperation *completedOperation) {
        HMNetResponse * response = [[HMNetResponse alloc] initWithData:completedOperation.responseJSONRemoveNull];
        success(response);
    } f:^(MKNetworkOperation *completedOperation, NSError *error) {
        HMNetResponse * response = [[HMNetResponse alloc] initWithData:completedOperation.responseJSONRemoveNull];
        failure(response, error);
    }];
    return op;
}



@end

@implementation MKNetworkOperation(null)

- (id)responseJSONRemoveNull
{
    id result = [self responseJSON];
    return [NSObject turnNullToNilForObject:result];
}

@end

@implementation MKNetworkOperation (errorString)

- (NSString *)errorString
{
    NSDictionary *dic = [self responseJSONRemoveNull];
    if ([dic[@"result"] isEqualToString:@"no_ok"]) {
        NSArray *errors = dic[@"errors"];
        if ([errors isKindOfClass:[NSArray class]] && errors.count) {
            NSDictionary *errorDic = errors[0];
            return errorDic[@"message"];
        }
    }
    return nil;
}

@end

@implementation NSArray(exception)

- (id)objectForKey:(NSString *)key
{
    return nil;
}
- (id)objectForKeyedSubscript:(id)key
{
    return nil;
}
@end



@implementation NSMutableDictionary(turnNil)

- (void)setValueReal:(id)value forKey:(NSString *)key
{
    if (value) {
        [self setValue:value forKey:key];
    }
}

@end
