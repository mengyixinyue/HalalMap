//
//  MJPhotoViewForLocalImage.h
//  Outing
//
//  Created by yj on 14/12/10.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPhotoLoadingView.h"
#import "MJPhotoForLocalImage.h"

@class MJPhotoBrowser, MJPhoto, MJPhotoViewForLocalImage;

@protocol MJPhotoViewForLocalImageDelegate <NSObject>
@optional
- (void)photoViewImageFinishLoad:(MJPhotoViewForLocalImage *)photoView;
- (void)photoViewSingleTap:(MJPhotoViewForLocalImage *)photoView;
- (void)photoViewDidEndZoom:(MJPhotoViewForLocalImage *)photoView;
@end

@interface MJPhotoViewForLocalImage : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *_imageView;
    MJPhotoLoadingView *_photoLoadingView;
}

// 图片
@property (nonatomic, strong) MJPhotoForLocalImage *photo;
// 代理
@property (nonatomic, weak) id<MJPhotoViewForLocalImageDelegate> photoViewDelegate;
@end
