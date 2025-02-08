//
//  HMFoundImageView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMFoundImageView.h"
#import "HMCycleScrollowView.h"
#import "HMPhotoModel.h"

@interface HMFoundImageView ()
<
HMCycleScrollowViewDelegate
>
@end

@implementation HMFoundImageView
{
    UIImageView * _bigImageView;
    HMCycleScrollowView * _cycleView;
    NSMutableArray * _imageArray;
    UIActivityIndicatorView * _indicatorView;
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
    __weak typeof(self) _self = self;

    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        _bigImageView.clipsToBounds = YES;
        [self addSubview:_bigImageView];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_self);
            make.height.mas_equalTo(_self.width * 4 / 5);
        }];
    }
    
    __weak UIImageView * weakBigImageView = _bigImageView;
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(weakBigImageView);
        }];
    }
    
    if (!_cycleView) {
        _cycleView = [[HMCycleScrollowView alloc] init];
        _cycleView.delegate = self;
        [self addSubview:_cycleView];
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_bigImageView.mas_bottom).with.offset(4);
            make.height.mas_equalTo(48);
            make.bottom.equalTo(_self).with.offset(-7.5);
        }];
    }
}

-(void)configureWithImageArray:(NSArray *)imageArray
{
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:imageArray];
    HMPhotoModel * photoModel = imageArray[0];
    
//    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.original_url] placeholderImage:nil];
    
    [_indicatorView startAnimating];
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.original_url]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_indicatorView stopAnimating];
    }];
    [_cycleView configureWithArray:_imageArray];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self) _self = self;
    [_bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_self.width * 4 / 5);
    }];
}

#pragma mark - HMCycleScrollowViewDelegate
-(void)cycleScrollowView:(HMCycleScrollowView *)cycleScrollowView selectedIndex:(NSInteger)index
{
    HMPhotoModel * photoModel = _imageArray[index];
    [_indicatorView startAnimating];

    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.original_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_indicatorView stopAnimating];
    }];
}

@end
