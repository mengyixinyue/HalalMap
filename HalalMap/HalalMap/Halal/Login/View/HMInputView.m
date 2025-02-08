//
//  HMInputView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/1.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMInputView.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@implementation HMInputView
{
    NSString * _title;
    NSString * _placeholder;
    UIButton * _secretBtn;
    UIView   * _inputView;
    UILabel * _titleLabel;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialUI];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initialUI];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        _title = title;
        _placeholder = placeholder;
        _secureTextEntry = NO;
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    WS(weakSelf);

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    _titleLabel.textColor = HMBlackColor;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.equalTo(@58);
        make.height.equalTo(weakSelf);
    }];
    
    
    _inputView = [[UIView alloc] init];
    _inputView.layer.borderColor = HMSeperatorColor.CGColor;
    _inputView.layer.borderWidth = 0.5f;
    [self addSubview:_inputView];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).with.offset(15);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(weakSelf);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = _placeholder;
    [_inputView addSubview:self.textField];
  
    
     _secretBtn = [UIButton buttonWithImage:[UIImage imageNamed:@"pw_close.png"]
                                              target:self
                                              action:@selector(secretBtnClick:)];
    [_inputView addSubview:_secretBtn];
    [_secretBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_inputView);
        make.width.mas_equalTo(44);
        make.top.equalTo(_inputView);
        make.height.equalTo(_inputView);
    }];
    _secretBtn.hidden = YES;
    [_secretBtn setImage:[UIImage imageNamed:@"pw_open.png"] forState:UIControlStateSelected];
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    _secretBtn.hidden = !secureTextEntry;
    _textField.secureTextEntry = _secureTextEntry;
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints
{
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputView).with.offset(10);
        make.top.and.bottom.equalTo(_inputView);
        if (_secureTextEntry) {
            make.right.equalTo(_secretBtn.mas_left);
        }
        else{
            make.right.equalTo(_inputView);
        }
    }];

    [super updateConstraints];
}

-(void)secretBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.textField.secureTextEntry = !_secretBtn.selected;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
    CGSize size = [_title sizeAutoFitIOS7WithFont:_titleLabel.font];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = _placeholder;
}

@end
