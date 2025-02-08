//
//  HMSelectRestaurantHeaderView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/20.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectRestaurantHeaderView.h"

@implementation HMSelectRestaurantHeaderView
{
    __weak IBOutlet UILabel *_tipsLabel;
    __weak IBOutlet UIButton *_addBtn;
}

-(void)awakeFromNib
{
    _tipsLabel.font = [HMFontHelper fontOfSize:18.0f];
    _tipsLabel.textColor = COLOR_WITH_RGB(142, 142, 147);
    _addBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    [_addBtn setTitleColor:HMMainColor forState:UIControlStateNormal];
}

-(void)configureWithTitle:(NSString *)title isShowAddBtn:(BOOL)isShowBtn
{
    _tipsLabel.text = title;
    _addBtn.hidden = !isShowBtn;
}

- (IBAction)addBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBtnClickWithHeaderView:)]) {
        [self.delegate addBtnClickWithHeaderView:self];
    }
}

@end
