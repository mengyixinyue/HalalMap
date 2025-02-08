//
//  BSImageContentViewController.h
//  BSValue
//
//  Created by 谷硕 on 11-7-8.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPhotoToolbarForLocalImage.h"

@class BSImageContentViewController;
@protocol BSImageContentViewControllerDelegate <NSObject>

- (void)BSImageContentViewControllerDidDismiss;
- (void)BSImageContentViewControllerDidComplete;
@end

@interface BSImageContentViewController : UIViewController<UIScrollViewDelegate,MJPhotoToolbarForLocalImageDelegate>

@property (nonatomic,assign) id<BSImageContentViewControllerDelegate>delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic,strong) NSMutableArray *selectdIdentifiersArray;
@property (nonatomic,strong) NSMutableArray *selectedAssetsArray;
@property (nonatomic,assign) NSInteger originSelectedNum;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic,strong) UIButton *selectBtn;

- (void)updateTollbarState;

@end
