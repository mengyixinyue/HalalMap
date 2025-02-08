//
//  HMMAPointAnnotation.m
//  HalalMaps
//
//  Created by 刘艳杰 on 15/10/20.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMMAPointAnnotation.h"

@implementation HMMAPointAnnotation

- (id)initWithIdentifier:(NSString *)identifier name:(NSString *)name address:(NSString *)address score:(NSString *)score isShowWin:(BOOL)isShowWin model:(HMPOIModel *)model
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.address = address;
        self.score = score;
        self.isShowWin = isShowWin;
        self.model = model;
    }
    return self;
}

@end
