//
//  HMPOIPicListViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/11.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOIPicListViewController.h"
#import "HMAddPicsViewController.h"

#import "HMImageCollectionCell.h"
#import "HMNoDataView.h"

#import "HMPhotoModel.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface HMPOIPicListViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
HMAddPicsViewControllerDelegate
>
@end

@implementation HMPOIPicListViewController
{
    __weak IBOutlet UICollectionView    *_collectionView;
    NSMutableArray                      * _dataArray;
    NSInteger                           _pageIndex;
    __weak IBOutlet UIButton            *_addBtn;
    HMNoDataView                        *_noDataView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"所有图片", nil);
    self.view.backgroundColor = COLOR_WITH_RGB(231, 231, 231);
    _pageIndex = 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self initialUI];
    [self getData];
}

-(void)initialUI
{
    _addBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15;//同一行 cell与cell之间的间距
    layout.minimumLineSpacing = 15;//行与行之间的间距
    CGFloat width = (_collectionView.width - 5 * 15) / 4.0f;
    layout.itemSize = CGSizeMake( width, width * 4  / 5.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"HMImageCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HMImageCollectionCell class])];
    
    _noDataView = [HMHelper xibWithClass:[HMNoDataView class]];
    _noDataView.frame = _collectionView.frame;
    [self.view addSubview:_noDataView];
    [self.view sendSubviewToBack:_noDataView];
    _noDataView.hidden = YES;
}

-(void)getData
{
    NSDictionary * params = @{
                              @"page" : [NSString stringWithFormat:@"%ld", (long)_pageIndex],
                              @"limit" : @"40"
                              };
    [HMNetwork getRequestWithPath:HMRequestPOIPictureList(self.poi_guid) params:params modelClass:[HMPhotoModel class] success:^(id object, HMNetPageInfo *pageInfo) {
        if (_pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        
        NSArray * arr = (NSArray *)object;
        if (arr.count == 0 && _pageIndex == 1) {
            _noDataView.hidden = NO;
            _noDataView.tipsLabel.text = @"暂无图片";
            _collectionView.hidden = YES;
        }
        else{
            [_dataArray addObjectsFromArray:object];
            [_collectionView reloadData];
            _pageIndex += 1;
        }
    }];
}

#pragma mark  - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMImageCollectionCell * imageCell = (HMImageCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HMImageCollectionCell class]) forIndexPath:indexPath];
    [imageCell configureWithModel:_dataArray[indexPath.row]];
    return imageCell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger count = _dataArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        HMPhotoModel *photoModel = _dataArray[i];
        NSString *url = photoModel.original_url;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = ((HMImageCollectionCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]).imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (_collectionView.width - 5 * 15) / 4.0f;
    return CGSizeMake( width, width * 4  / 5.0f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 0, 15);
}



- (IBAction)addBtnClick:(UIButton *)sender
{
    HMAddPicsViewController * addPicsVC = [HMHelper xibWithViewControllerClass:[HMAddPicsViewController class]];
    addPicsVC.poi_guid = _poi_guid;
    addPicsVC.delegate = self;
    [self.navigationController pushViewController:addPicsVC animated:YES];
}

-(void)reflashPicList
{
    _pageIndex = 1;
    [self getData];
}


@end
