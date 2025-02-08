//
//  ZCPicItemCell.m
//  Outing
//
//  Created by yj on 14-11-25.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "ZCPhotoItemCell.h"


@implementation ZCPhotoItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
        
        _maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskButton.frame = CGRectMake(self.width - 30, 0, 30, 30);
        [_maskButton setImage:[UIImage imageNamed:@"发布feed_图片未选中.png"] forState:UIControlStateNormal];
        [_maskButton setImage:[UIImage imageNamed:@"发布feed_图片选中.png"] forState:UIControlStateSelected];
        [_maskButton addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_maskButton];
        
    }
    return self;
}

- (void)configureWithAsset:(ALAsset *)asset selected:(BOOL)selected
{
    [_imgView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    _maskButton.selected = selected;
}

- (void)maskBtnClick:(UIButton *)sender
{
    BOOL result = NO;
    sender.selected = !sender.selected;
    if ([self.clickDelegate respondsToSelector:@selector(ZCPhotoItemCell:didSelect:)]) {
        result = [self.clickDelegate ZCPhotoItemCell:self didSelect:sender.selected];
    }
    if (!result) {
        sender.selected = !sender.selected;
    }
    else
    {
        if (sender.selected) {
            [sender peng];
        }
    }

}

@end
