//
//  HMSelectProviceView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectPrivateView.h"

@implementation HMSelectPrivateView
{
    __weak IBOutlet UILabel *_tipsLabel;
}

-(void)awakeFromNib
{
    _tipsLabel.font = [HMFontHelper fontOfSize:16.0f];
}

- (IBAction)swithcChangeValue:(UISwitch *)sender
{
    NSLog(@"开关");
    if (self.delegate && [self.delegate respondsToSelector:@selector(privateInfo:selectPrivateView:)]) {
        [self.delegate privateInfo:sender.on selectPrivateView:self];
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
