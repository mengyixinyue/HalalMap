//
//  ZCPicItemCell.h
//  Outing
//
//  Created by yj on 14-11-25.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ZCPhotoItemCell;
@protocol ZCPhotoItemCellDelegate <NSObject>

- (BOOL)ZCPhotoItemCell:(ZCPhotoItemCell *)cell didSelect:(BOOL)select;

@end

@interface ZCPhotoItemCell : UICollectionViewCell


@property (nonatomic,assign) id <ZCPhotoItemCellDelegate>clickDelegate;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton * maskButton;

- (void)configureWithAsset:(ALAsset *)asset selected:(BOOL)selected;


@end
