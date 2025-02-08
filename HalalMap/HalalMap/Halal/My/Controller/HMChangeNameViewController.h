//
//  HMChangeNameViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/22.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@protocol HMChangeNameViewControllerDelegate <NSObject>

-(void)changeNameWithNewText:(NSString *)newText;

@end

@interface HMChangeNameViewController : HMBaseViewController

@property (nonatomic, assign) id<HMChangeNameViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString * oldText;
@property (nonatomic, copy) NSString * placeHolder;
@property (nonatomic, assign) NSInteger maxStrNum;

@end
