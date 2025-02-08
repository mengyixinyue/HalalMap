//
//  HMSelectProviceView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSelectPrivateView;
@protocol HMSelectPrivateViewDelegate <NSObject>

-(void)privateInfo:(BOOL)privateInfo selectPrivateView:(HMSelectPrivateView *)selectPrivateView;

@end

@interface HMSelectPrivateView : UIView

@property (nonatomic, assign) id<HMSelectPrivateViewDelegate>delegate;

@end
