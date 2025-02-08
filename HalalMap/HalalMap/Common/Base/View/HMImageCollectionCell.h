//
//  HMImageCollectionCell.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/2/21.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMImageCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


-(void)configureWithModel:(id)model;

@end
