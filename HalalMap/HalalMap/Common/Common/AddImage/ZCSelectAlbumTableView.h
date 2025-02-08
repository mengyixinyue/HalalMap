//
//  ZCSelectAlbumTableView.h
//  Outing
//
//  Created by yj on 14-10-3.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kSelectAlbumTableViewHeight             56 * 4


@class ZCSelectAlbumTableView;

@protocol ZCSelectAlbumTableViewDelegate <NSObject>

- (void)ZCSelectAlbumTableView:(ZCSelectAlbumTableView *)tableView didSelectAssetsGroup:(ALAssetsGroup *)assetsGroup;
- (void)ZCSelectAlbumTableViewDidLoadFirstGroup;
@end

@interface ZCSelectAlbumTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_assetsGroups;
    ALAssetsFilter *_filter;
}

@property (nonatomic,assign) id<ZCSelectAlbumTableViewDelegate>selectDelegate;
@property (nonatomic,strong) NSMutableArray *assetsGroups;
- (void)addPicToGroup;
- (id)initWithFrame:(CGRect)frame ALAssetsFilter:(ALAssetsFilter *)filter;

@end
