//
//  HMLocationCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/18.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMLocationCell.h"

@implementation HMLocationCell
{
    __weak IBOutlet UILabel *_cityLabel;
    __weak IBOutlet UIButton *_locationButton;
}
- (void)awakeFromNib {
    // Initialization code
    _cityLabel.font = [HMFontHelper fontOfSize:16.0f];
}
- (IBAction)locationBtnClick:(UIButton *)sender
{
    NSLog(@"定位");
    if (self.delegate && [self.delegate respondsToSelector:@selector(reflashLocationWithCell:)]) {
        [self.delegate reflashLocationWithCell:self];
    }
}

-(void)configureWithAddressModel:(HMAddressModel *)addressModel
{
    _cityLabel.text = addressModel.city.city_short_name ? addressModel.city.city_short_name : addressModel.city.city_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
