//
//  HMSelectAddressEntranceView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectAddressEntranceView.h"

@implementation HMSelectAddressEntranceView
{
    __weak IBOutlet UILabel *_addressLabel;
    
}

-(void)awakeFromNib
{
    _addressLabel.font = [HMFontHelper fontOfSize:16.0f];
    _selectedRestaurantLabel.font = [HMFontHelper fontOfSize:16.0f];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

-(void)tapClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAddressEntranceView:)]) {
        [self.delegate selectAddressEntranceView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
