//
//  HMOtherLoginView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/2.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMOtherLoginView.h"

typedef enum : NSUInteger {
    LoginBtnTypeWechat = 1,
    LoginBtnTypeSina,
    LoginBtnTypeQQ,
} LoginBtnType;

@implementation HMOtherLoginView

-(id)init
{
    self = [super init];
    if (self) {
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    
    UILabel * label = [[UILabel alloc] init];
    [self addSubview:label];
    label.text = NSLocalizedString(@"第三方账号登录", nil);
    label.font = [HMFontHelper fontOfSize:12.0f];
    label.textColor = HMGrayColor;
    label.width = SCREEN_WIDTH;
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    UIView * leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = HMSeperatorColor;
    [self addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(25);
        make.right.equalTo(label.mas_left).with.offset(-15);
        make.centerY.equalTo(label);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView * rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = HMSeperatorColor;
    [self addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(label);
        make.height.mas_equalTo(0.5);
    }];
    
    NSArray * btnImageArray = @[@"wechat_login.png", @"sina_login.png", @"qq_login.png"];
    UIButton * lastBtn = nil;
    for (int i = 0; i < btnImageArray.count; i ++) {
        UIButton * btn = [UIButton buttonWithImage:[UIImage imageNamed:btnImageArray[i]]
                                            target:self
                                            action:@selector(btnClick:)];
        btn.tag = i + 1;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);

            if (i == 0) {
                make.left.equalTo(self).with.offset(90);
            }
            else if(i == btnImageArray.count - 1){
                make.right.equalTo(self).with.offset(-90);
            }
            else{
                make.centerX.equalTo(self);
            }
            make.width.and.height.mas_equalTo(45);
        }];
        lastBtn = btn;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastBtn.mas_bottom);
    }];
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"微信");
    }
    else if (btn.tag == 2){
        NSLog(@"新浪");
    }
    else if (btn.tag == 3){
        NSLog(@"QQ");
    }
}

@end
