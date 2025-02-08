//
//  ZCAddPicsAndTextFeedViewContr.h
//  Outing
//
//  Created by yj on 14-9-30.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "HMBaseViewController.h"
#import "ZCSelectAlbumTableView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZCPhotoItemCell.h"
#import "BSImageContentViewController.h"


@class ZCSelectPicsViewController;
@protocol ZCSelectPicsViewControllerDelegate <NSObject>

- (void)ZCSelectPicsViewController:(ZCSelectPicsViewController *)controller didFinishPickingAssets:(NSArray *)assets;

@end

@interface ZCSelectPicsViewController : HMBaseViewController
<
UICollectionViewDataSource,
UICollectionViewDelegate,
ZCSelectAlbumTableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ZCPhotoItemCellDelegate,
BSImageContentViewControllerDelegate
>
{
    UIControl *_bgAlphaView;
    ZCSelectAlbumTableView *_selectAlbumTableView;
    
    NSMutableArray *_assets;
    UICollectionView *_collectionView;
    
    NSMutableArray *_selectedAssetsArray;
    NSMutableArray *_selectdIdentifiersArray;
    UIButton *_doneBtn;
    
    NSInteger _originSelectedNum;
    
    NSMutableArray *_photosArray;
    
}

- (instancetype)initWithOriginSelectedNum:(NSInteger)originSelecteNum;


@property (nonatomic,assign) id<ZCSelectPicsViewControllerDelegate>delegate;
@property (nonatomic, retain) ALAssetsGroup *assetsGroup;

@end
