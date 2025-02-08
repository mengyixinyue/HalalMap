//
//  HMLocationCell.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/18.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMAddressModel.h"

@class HMLocationCell;
@protocol HMLocationCellDelegate <NSObject>

-(void)reflashLocationWithCell:(HMLocationCell *)cell;

@end

@interface HMLocationCell : UITableViewCell

@property (nonatomic, assign) id<HMLocationCellDelegate>delegate;

-(void)configureWithAddressModel:(HMAddressModel *)addressModel;

@end
