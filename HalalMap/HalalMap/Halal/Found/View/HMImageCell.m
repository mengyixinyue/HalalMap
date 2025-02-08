//
//  HMImageCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMImageCell.h"
#import "ZCImageInfoModel.h"

@implementation HMImageCell
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIButton    *_deleteBtn;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)configureWithModel:(id)model
{
    if ([model isKindOfClass:[ZCImageInfoModel class]]) {
        ZCImageInfoModel * imageInfoModel = (ZCImageInfoModel *)model;
        _imageView.image = [UIImage imageWithContentsOfFile:imageInfoModel.imagePath];
    }
}

-(IBAction)deleteBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImage:)]) {
        [self.delegate deleteImage:self];
    }
}

@end
