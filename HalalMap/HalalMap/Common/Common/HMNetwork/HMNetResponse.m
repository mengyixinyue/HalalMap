//
//  HMNetResponse.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMNetResponse.h"

@implementation HMNetResponse

-(instancetype)initWithData:(id)responseData
{
    self = [super init];
    if (self) {
        self.response = responseData;
        _notReachable = NO;
        _errocode = 0;
        _httpError = 0;
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            return [self initWithDictionary:responseData];
        }
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!self) {
        self = [super init];
    }
    if (self) {
        if (dictionary) {
            if ([[dictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
                if ([dictionary objectForKey:@"data"]) {
                    id contentTemp = [dictionary objectForKey:@"data"];
                    _data = contentTemp;
                }
                if ([dictionary objectForKey:@"pageInfo"]) {
                    NSDictionary *pageInfoDictionary = [dictionary dictionaryForKey:@"pageInfo"];
                    HMNetPageInfo * pageInfo = [[HMNetPageInfo alloc] init];
                    pageInfo.hadMore = [[pageInfoDictionary objectForKey:@"hasMore"] intValue];
                    _pageInfo = pageInfo;
                }
            }
            else{
                if ([dictionary objectForKey:@"errors"]) {
                    NSArray * errors = [dictionary objectForKey:@"errors"];
                    if ([errors isKindOfClass:[NSArray class]]) {
                        NSDictionary * errorDict = [errors firstObject];
                        if ([errorDict isKindOfClass:[NSDictionary class]]) {
                            if ([errorDict objectForKey:@"message"]) {
                                _message = [NSString stringWithFormat:@"%@",[errorDict objectForKey:@"message"]];
                            }
                            if ([[errorDict objectForKey:@"field"] isEqualToString:@"api_token"]) {
                                [HMRunDataShare logout];
                            }
                            
                        }
                    }
                }
            }
            
           
        }
    }
    return self;
}

@end
