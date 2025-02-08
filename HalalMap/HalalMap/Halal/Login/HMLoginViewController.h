//
//  HMLoginViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@interface HMLoginViewController : HMBaseViewController

@property(nonatomic, strong)loginSuccessBlock loginSuccess;
@property(nonatomic, assign)BOOL isShowBackItem;

+(void)loginWithSuccess:(loginSuccessBlock)success inViewController:(UIViewController*)viewController;


@end
