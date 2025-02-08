//
//  HMSelectAddressView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectAddressView.h"

@interface HMSelectAddressView ()
@end

@implementation HMSelectAddressView
{
    IBOutlet  UISegmentedControl * _segment;
    __weak IBOutlet UILabel *_tipsLabel;
}


-(void)awakeFromNib
{
    _tipsLabel.font = [HMFontHelper fontOfSize:16.0f];
}

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAddressView:isSelectedRestaurant:)]) {
        if (sender.selectedSegmentIndex == 0) {
            [self.delegate selectAddressView:self isSelectedRestaurant:YES];
        }
        else{
            [self.delegate selectAddressView:self isSelectedRestaurant:NO];
        }
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
