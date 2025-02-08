//
//  HMFindPasswordViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/12.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMFindPasswordViewController.h"
#import "YSKeyboardScrollView.h"
#import "HMInputView.h"
#import "HMVerifyCode.h"

#define HMHorizonMargin      (20)
#define HMHorizonPadding     (5)
#define HMVerticalMargin     (40)
#define HMVerticalPadding    (20)
#define HMHeight             (44)

@interface HMFindPasswordViewController ()
<
UITextFieldDelegate
>
@end

@implementation HMFindPasswordViewController
{
    YSKeyboardScrollView    * _scrollView;
    UIView                  * _containerView;
    HMInputView             * _phoneInputView;
    HMInputView             * _newPWInputView;
    HMInputView             * _veriCodeInputView;
    HMVerifyCode            * _verifyCode;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"找回密码", nil);
    [self initailizeUI];
}

-(void)initailizeUI
{
    if (!_scrollView) {
        YSKeyboardScrollView * keyBoardScrollView = [[YSKeyboardScrollView alloc] init];
        [self.view addSubview:keyBoardScrollView];
        [keyBoardScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(@0);
            make.width.and.height.equalTo(self.view);
        }];
        _scrollView = keyBoardScrollView;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_scrollView addSubview:_containerView];
    }
    
    if (!_phoneInputView) {
        _phoneInputView = [[HMInputView alloc] initWithTitle:NSLocalizedString(@"手机号", nil)
                                                 placeholder:NSLocalizedString(@"请输入手机号", nil)];
        [_containerView addSubview:_phoneInputView];
        _phoneInputView.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _phoneInputView.textField.returnKeyType = UIReturnKeyNext;
        _phoneInputView.textField.delegate = self;
        [_phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(HMHorizonMargin);
            make.right.equalTo(_containerView).offset(-HMHorizonMargin);
            make.top.equalTo(_containerView).offset(HMVerticalMargin);
            make.height.mas_equalTo(HMHeight);
        }];
    }
    
    UIButton * getVeriCodeBtn = [UIButton buttonWithTitle:NSLocalizedString(@"获取验证码", nil)
                                                    image:nil
                                               titleColor:HMMainColor
                                                   target:self
                                                   action:@selector(getVeriCodeBtnClick:)];
    getVeriCodeBtn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    [_containerView addSubview:getVeriCodeBtn];
    [getVeriCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView).offset(-HMHorizonMargin);
        make.width.mas_equalTo(80);
        make.top.equalTo(_phoneInputView.mas_bottom).offset(HMVerticalPadding);
        make.height.mas_equalTo(HMHeight);
    }];
    
    _verifyCode = [[HMVerifyCode alloc] initWithButton:getVeriCodeBtn];
    
    if (!_veriCodeInputView) {
        _veriCodeInputView = [[HMInputView alloc] initWithTitle:NSLocalizedString(@"验证码", nil)
                                                    placeholder:NSLocalizedString(@"请输入验证码", nil)];
        [_containerView addSubview:_veriCodeInputView];
        _veriCodeInputView.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        _veriCodeInputView.textField.returnKeyType = UIReturnKeyNext;
        _veriCodeInputView.textField.delegate = self;
        [_veriCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(HMHorizonMargin);
            make.top.equalTo(_phoneInputView.mas_bottom).offset(HMVerticalPadding);
            make.right.equalTo(getVeriCodeBtn.mas_left).offset(-HMHorizonPadding);
            make.height.mas_equalTo(HMHeight);
        }];
        
    }
    
    if (!_newPWInputView) {
        _newPWInputView = [[HMInputView alloc] initWithTitle:NSLocalizedString(@"新密码", nil)
                                              placeholder:NSLocalizedString(@"请输入新密码", nil)];
        [_containerView addSubview:_newPWInputView];
        _newPWInputView.textField.returnKeyType = UIReturnKeyGo;
        _newPWInputView.textField.delegate = self;
        [_newPWInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(HMHorizonMargin);
            make.right.equalTo(_containerView).offset(-HMHorizonMargin);
            make.top.equalTo(_veriCodeInputView.mas_bottom).offset(HMVerticalPadding);
            make.height.mas_equalTo(HMHeight);
        }];
        _newPWInputView.secureTextEntry = YES;
    }
    
    
    UIButton * findPWBtn = [UIButton buttonWithTitle:NSLocalizedString(@"找回密码", nil)
                                               bgImage:nil
                                            titleColor:HMMainColor
                                                target:self
                                              action:@selector(findPWBtnClick)];
    findPWBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    [_containerView addSubview:findPWBtn];
    [findPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView).with.offset(HMHorizonMargin);
        make.right.equalTo(_containerView).with.offset(-HMHorizonMargin);
        make.top.equalTo(_newPWInputView.mas_bottom).with.offset(HMVerticalPadding);
        make.height.mas_equalTo(44);
    }];
    [findPWBtn setBackgroundImage:[UIImage imageWithColor:COLOR_WITH_RGB(230, 230, 230) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_scrollView);
        make.width.equalTo(self.view);
        make.bottom.mas_equalTo(findPWBtn.mas_bottom).priorityLow();
        make.height.mas_greaterThanOrEqualTo(self.view);
    }];
}

#pragma mark - 获取验证码
-(void)getVeriCodeBtnClick:(UIButton *)btn
{
    NSLog(@"获取验证码");
    [self.view endEditing:YES];
    NSString * phoneStr = _phoneInputView.textField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGULAR_PHONE];
    BOOL isValid = [predicate evaluateWithObject:phoneStr];
    if (!isValid) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手机号输入错误，请输入正确的手机号", nil)];
        return;
    }

    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取验证码...", nil)];
    NSDictionary * params = @{
                              @"phone" : _phoneInputView.textField.text
                              };
    
    [HMNetwork getRequestWithPath:HMRequestSendFindPWVeriCode params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"获取验证码成功，请注意查收", nil)];
        [_verifyCode startCountTime];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

#pragma mark - 找回密码
-(void)findPWBtnClick
{
    NSLog(@"找回密码");
    NSString * phoneStr = _phoneInputView.textField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGULAR_PHONE];
    BOOL isValid = [predicate evaluateWithObject:phoneStr];
    if (!isValid) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手机号输入错误，请输入正确的手机号", nil)];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在重置密码...", nil)];
    NSDictionary * params = @{
                              @"phone" : _phoneInputView.textField.text,
                              @"vericode" : _veriCodeInputView.textField.text,
                              @"password" : _newPWInputView.textField.text
                              };

    [HMNetwork postRequestWithPath:HMRequestResetPassword params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"重置密码成功", nil)];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:2];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneInputView.textField) {
        [_veriCodeInputView.textField becomeFirstResponder];
    }
    else if (textField == _veriCodeInputView.textField)
    {
        [_newPWInputView.textField becomeFirstResponder];
    }
    else{
        [self findPWBtnClick];
    }
    return YES;
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
