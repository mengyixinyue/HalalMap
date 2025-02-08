//
//  HMHelper.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMHelper.h"

@implementation HMHelper

+(id)xibWithClass:(Class)className
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(className) owner:self options:nil] lastObject];
}

+(id)xibWithViewControllerClass:(Class)className
{
    return [[className alloc] initWithNibName:NSStringFromClass([className class])  bundle:[NSBundle mainBundle]];
}

+(BOOL)netIsConnectedWithShowErrorMsg:(BOOL)showErrorMsg
{
    Reachability* internetReach = [Reachability reachabilityForInternetConnection];
    if ([internetReach currentReachabilityStatus] != NotReachable) {
        return YES;
    }
    if (showErrorMsg) {
        [SVProgressHUD showErrorWithStatus:ERROR_MESSAGE_NETWORK];
    }
    return NO;
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

+(NSString *)imageSavePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *imagesDirectory = [documentsDirectory stringByAppendingPathComponent:@"images"];
    // 创建目录
    [fileManager createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
     return imagesDirectory;
}

-(BOOL)isLogin
{
    return [HMRunData isLogin];
}

+ (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

+ (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
//    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:[HMHelper getApplicationName]])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}

+(void)getCityWithLon:(NSString *)lon lat:(NSString *)lat success:(void(^)(HMAddressModel * model))success faile:(void(^)(NSString *errorMsg))faile
{
    NSDictionary * params = @{
                              @"lon" : lon,
                              @"lat" : lat
                              };
    [HMNetwork getRequestWithPath:HMRequestGeocode params:params modelClass:[HMAddressModel class] success:^(id object, HMNetPageInfo *pageInfo) {
        HMAddressModel * model = object;
        model.lon = lon;
        model.lat = lat;
        success(model);
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        if (faile) {
            faile(errorMsg);
        }
    }];
}


+(HMCitiesModel *)getSelectedCity
{
   NSDictionary * city = [USERDEFAULT objectForKey:HMHomePageSelectCityKey];
    if (city) {
        HMCitiesModel * model = [[HMCitiesModel alloc] init];
        model.city_guid = [city objectForKey:@"city_guid"];
        model.city_name = [city objectForKey:@"city_name"];
        return model;
    }
    else{
        return nil;
    }
}

+(void)saveSelectedCity:(HMCitiesModel *)model
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:model.city_name forKey:@"city_name"];
    [dic setObject:model.city_guid forKey:@"city_guid"];
    [USERDEFAULT setObject:dic forKey:HMHomePageSelectCityKey];
    UserDefaultSynchronize;
}

@end
