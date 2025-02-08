//
//  HMVerifyCode.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/13.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMVerifyCode.h"

@implementation HMVerifyCode
{
    UIButton    * _verifyCodeBtn;
    NSTimer     *_timer;
    int         _tickCount;
}

-(id)initWithButton:(UIButton *)btn
{
    self = [super init];
    if (self) {
        _verifyCodeBtn = btn;
    }
    return self;
}

- (void)startCountTime
{
    _verifyCodeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(NSTimer *)timer
{
    NSString *title = [NSString stringWithFormat:@"%ds",60 - _tickCount];
    [_verifyCodeBtn setTitle:title forState:UIControlStateDisabled];
    if (_tickCount >= 60) {
        [_verifyCodeBtn setTitle:NSLocalizedString(@"重发验证码", nil) forState:UIControlStateNormal];
        [_verifyCodeBtn setTitle:NSLocalizedString(@"重发验证码", nil) forState:UIControlStateDisabled];
        _verifyCodeBtn.enabled = YES;
        [self stopTimer];
        _tickCount = 0;
    }
    _tickCount += 1;
}

#pragma mark - 停止定时器
- (void)stopTimer
{
    if (_timer && _timer.isValid)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
