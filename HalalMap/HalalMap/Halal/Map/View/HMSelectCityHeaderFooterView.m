//
//  HMSelectCityHeaderFooterView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/16.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectCityHeaderFooterView.h"

@interface HMSelectCityHeaderFooterView ()
{
    __weak IBOutlet UILabel *_label;
    __weak IBOutlet UIView *_view;
}

@end

@implementation HMSelectCityHeaderFooterView

-(void)awakeFromNib
{
    _view.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
    _label.font = [HMFontHelper fontOfSize:16.0f];
}

-(void)configureWithTitle:(NSString *)title
{
    _label.text = title;
}

@end
