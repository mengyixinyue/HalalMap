//
//  HMNoDataView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/12.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMNoDataView.h"

@implementation HMNoDataView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tipsLabel.font = [HMFontHelper fontOfSize:14.0f];
}

@end
