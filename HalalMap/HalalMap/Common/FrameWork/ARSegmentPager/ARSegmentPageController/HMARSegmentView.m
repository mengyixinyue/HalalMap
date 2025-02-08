//
//  HMARSegmentView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMARSegmentView.h"


@implementation HMARSegmentView
{
    UIButton * _selectedBtn;
}

- (instancetype)initWithTitles:(NSArray *)titles
{
    if (self = [super init]) {
        self.backgroundColor = COLOR_WITH_RGB(245, 245, 245);
        [self initialUIWithTitles:titles];
    }
    return self;
}

-(void)initialUIWithTitles:(NSArray *)titles
{
    CGFloat width = self.width / titles.count;
    UIButton * tmpBtn;
    for (int i = 0; i < titles.count; i ++) {
        
        UIButton * btn = [UIButton buttonWithFrame:CGRectMake(0, 0, width, self.height) title:titles[i] image:nil titleColor:HMBlackColor target:self action:@selector(btnClick:)];
        [btn setTitleColor:HMMainColor forState:UIControlStateSelected
         ];
        btn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
        btn.tag = i;
        [self addSubview:btn];
        
        WS(weakSelf);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (tmpBtn) {
                make.left.equalTo(tmpBtn.mas_right);
            }
            else
            {
                make.left.equalTo(@0);
            }
            make.top.equalTo(weakSelf);
            make.width.equalTo(weakSelf).multipliedBy(1.0/titles.count);
            make.height.equalTo(weakSelf);
        }];
        
        tmpBtn = btn;
        
        if (i < titles.count - 1) {
            UIView *sepeLine = [[UIView alloc] init];
            sepeLine.backgroundColor = HMSeperatorColor;
            [self addSubview:sepeLine];
            [sepeLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btn);
                make.centerY.equalTo(btn);
                make.width.equalTo(@1);
                make.height.equalTo(@26.5);
            }];
        }
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
    }
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    _selectedBtn.selected = NO;
    btn.selected = !btn.selected;
    _selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hmARSegmentView:didSelectItemAtIndex:)]) {
        [self.delegate hmARSegmentView:self didSelectItemAtIndex:btn.tag];
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
