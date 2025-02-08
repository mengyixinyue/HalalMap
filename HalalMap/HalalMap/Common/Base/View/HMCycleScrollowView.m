//
//  HMCycleScrollowView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/1/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMCycleScrollowView.h"
#import "HMImageCollectionCell.h"

@interface HMCycleScrollowView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@end

@implementation HMCycleScrollowView
{
    UICollectionView * _collectionView;
    NSMutableArray * _imageArray;
}


-(id)init
{
    self = [super init];
    if (self) {
        _imageArray = [[NSMutableArray alloc] init];
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 9;//同一行 cell与cell之间的间距
    layout.minimumLineSpacing = 9;//行与行之间的间距
    layout.itemSize = CGSizeMake( self.height * 5 / 4, self.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    [_collectionView registerNib:[UINib nibWithNibName:@"HMImageCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HMImageCollectionCell class])];
}

#pragma mark  - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView.collectionViewLayout invalidateLayout];
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMImageCollectionCell * imageCell = (HMImageCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HMImageCollectionCell class]) forIndexPath:indexPath];
    [imageCell configureWithModel:_imageArray[indexPath.row]];
    return imageCell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollowView:selectedIndex:)]) {
        [self.delegate cycleScrollowView:self selectedIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( self.height * 5 / 4, self.height);
}

-(void)configureWithArray:(NSArray *)array
{
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:array];
    [_collectionView reloadData];
}


@end
