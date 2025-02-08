//
//  HMPOICalloutView.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/18.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPOIModel.h"

@interface HMPOICalloutView : UIView

@property (nonatomic, assign) BOOL isShowWin;//是否展示酒
@property (nonatomic, copy) NSString *name; //商户名
@property (nonatomic, copy) NSString *address; //地址
@property (nonatomic, copy) NSString * score;//评分
@property (nonatomic, strong) HMPOIModel * model;

@end
