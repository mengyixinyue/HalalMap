//
//  HMImageCell.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMImageCell;
@protocol HMImageCellDelegate <NSObject>

-(void)deleteImage:(HMImageCell *)imageCell;

@end


@interface HMImageCell : UICollectionViewCell

@property (nonatomic, assign) id<HMImageCellDelegate>delegate;

-(void)configureWithModel:(id)model;

@end
