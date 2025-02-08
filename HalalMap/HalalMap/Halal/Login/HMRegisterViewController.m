//
//  HMRegisterViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/7.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMRegisterViewController.h"
#import "HMLoginViewController.h"

#import "YSKeyboardScrollView.h"
#import "HMInputView.h"
#import "HMVerifyCode.h"

#define HMHorizonMargin      (20)
#define HMHorizonPadding     (5)
#define HMVerticalMargin     (40)
#define HMVerticalPadding    (20)
#define HMHeight             (44)

@interface HMRegisterViewController ()
<
UITextFieldDelegate
>
@end

@implementation HMRegisterViewController
{
    YSKeyboardScrollView    * _scrollView;
    UIView                  * _containerView;
    HMInputView             * _phoneInputView;
    HMInputView             * _pwInputView;
    HMInputView             * _veriCodeInputView;
    HMVerifyCode            * _verifyCode;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"注册", nil);
    [self initailizeUI];
}

-(void)initailizeUI
{
    if (!_scrollView) {
        YSKeyboardScrollView * keyBoardScrollView = [[YSKeyboardScrollView alloc] init];
        [self.view addSubview:keyBoardScrollView];
        [keyBoardScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(@0);
            make.width.equalTo(self.view);
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
    
    if (!_pwInputView) {
        _pwInputView = [[HMInputView alloc] initWithTitle:NSLocalizedString(@"密    码", nil)
                                              placeholder:NSLocalizedString(@"请输入密码", nil)];
        [_containerView addSubview:_pwInputView];
        _pwInputView.textField.returnKeyType = UIReturnKeyGo;
        _pwInputView.textField.delegate = self;
        [_pwInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(HMHorizonMargin);
            make.right.equalTo(_containerView).offset(-HMHorizonMargin);
            make.top.equalTo(_veriCodeInputView.mas_bottom).offset(HMVerticalPadding);
            make.height.mas_equalTo(HMHeight);
        }];
        _pwInputView.secureTextEntry = YES;
    }
    
    UIButton * userAgreementBtn = [UIButton buttonWithTitle:nil
                                                 image:nil
                                            titleColor:HMMainColor
                                                target:self
                                                action:@selector(userAgreementBtnCLick)];
    userAgreementBtn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    [_containerView addSubview:userAgreementBtn];
    
    NSString * str = NSLocalizedString(@"点击注册即代表同意用户协议", nil);
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    attributeStr.font = [HMFontHelper fontOfSize:14.0f];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:HMGrayColor range:[str rangeOfString:str]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:HMMainColor range:[str rangeOfString:NSLocalizedString(@"用户协议", nil)]];
    [userAgreementBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    userAgreementBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
        make.top.equalTo(_pwInputView.mas_bottom).with.offset(HMVerticalPadding);
        make.width.mas_equalTo(185);
    }];
    
    UIButton * registerBtn = [UIButton buttonWithTitle:NSLocalizedString(@"注册", nil)
                                            bgImage:nil
                                         titleColor:HMMainColor
                                             target:self
                                             action:@selector(registerBtnClick)];
    registerBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    [_containerView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView).with.offset(HMHorizonMargin);
        make.right.equalTo(_containerView).with.offset(-HMHorizonMargin);
        make.top.equalTo(userAgreementBtn.mas_bottom).with.offset(HMVerticalPadding);
        make.height.mas_equalTo(44);
    }];
    [registerBtn setBackgroundImage:[UIImage imageWithColor:COLOR_WITH_RGB(230, 230, 230) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    
    NSString * loginStr = NSLocalizedString(@"已有账号？登录", nil);
    NSRange loginRange = [loginStr rangeOfString:@"登录"];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:loginStr];
    one.font = [HMFontHelper fontOfSize:16.0f];
    [one addAttribute:NSForegroundColorAttributeName value:HMBlackColor range:[loginStr rangeOfString:loginStr]];
    [one addAttribute:NSForegroundColorAttributeName value:HMMainColor range:loginRange];
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
    border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
    
    YYTextHighlight * loginHighlight = [YYTextHighlight new];
    [loginHighlight setBorder:border];
    loginHighlight.tapAction =  ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"登录");
        [self gotoLoginVC];
    };
    [one setTextHighlight:loginHighlight range:loginRange];
    
    YYLabel * loginLabel  = [YYLabel new];
    loginLabel.width = self.view.width;
    loginLabel.attributedText = one;
    loginLabel.numberOfLines = 0;
    loginLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self.view addSubview:loginLabel];
    
    CGSize size = [loginStr sizeAutoFitIOS7WithFont:one.font];
    loginLabel.frame = CGRectMake(HMHorizonMargin, SCREEN_HEIGHT_NOBAR + 64 + 20  - HMVerticalMargin - size.height, size.width, size.height);
    
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginLabel.mas_top).with.offset(-5);
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_scrollView);
        make.width.equalTo(self.view);
        make.bottom.mas_equalTo(registerBtn.mas_bottom).priorityLow();
        make.height.mas_greaterThanOrEqualTo(loginLabel.top);
    }];
}

-(void)gotoLoginVC
{
    NSArray * vcs = self.navigationController.viewControllers;
    for (UIViewController * vc in vcs) {
        if ([vc isKindOfClass:[HMLoginViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    HMLoginViewController * loginVC = [[HMLoginViewController alloc] initWithNibName:NSStringFromClass([HMLoginViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginVC animated:YES];
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
    [HMNetwork  getRequestWithPath:HMRequestSendRegisterVeriCode params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"获取验证码成功，请注意查收", nil)];
        [_verifyCode startCountTime];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

-(void)userAgreementBtnCLick
{
    NSLog(@"用户协议");
}

#pragma mark - 注册
-(void)registerBtnClick
{
    NSLog(@"注册");
    [self.view endEditing:YES];
    NSString * phoneStr = _phoneInputView.textField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGULAR_PHONE];
    BOOL isValid = [predicate evaluateWithObject:phoneStr];
    if (!isValid) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手机号输入错误，请输入正确的手机号", nil)];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"注册中...", nil)];
    NSDictionary * params = @{
                              @"phone" : _phoneInputView.textField.text,
                              @"vericode" : _veriCodeInputView.textField.text,
                              @"password" : _pwInputView.textField.text
                              };
    [HMNetwork postRequestWithPath:HMRequestRegister
                            params:params
                           success:^(HMNetResponse *response) {
                               [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"注册成功", nil)];
                               [self login];
                           }
                           failure:^(HMNetResponse *response, NSString *errorMsg) {
                               [SVProgressHUD showErrorWithStatus:errorMsg];
                           }];
}

-(void)login
{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"登录中...", nil)];
    NSDictionary * params = @{
                              @"phone" : _phoneInputView.textField.text,
                              @"password" : _pwInputView.textField.text
                              };
    [HMNetwork postRequestWithPath:HMRequestLogin
                            params:params
                           success:^(HMNetResponse *response) {
                               [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];;
                               if ([response.data isKindOfClass:[NSDictionary class]]) {
                                   NSDictionary * dataDict = (NSDictionary *)response.data;
                                   [HMRunDataShare.userInfoDic setDictionary:dataDict];
                                   [HMRunDataShare userInfoSynchronize];
                                   NSLog(@"%@", [HMRunData sharedHMRunData]);
                               }
                           }
                           failure:^(HMNetResponse *response, NSString *errorMsg) {
                               [SVProgressHUD showErrorWithStatus:errorMsg];
                           }];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneInputView.textField) {
        [_veriCodeInputView.textField becomeFirstResponder];
    }
    else if (textField == _veriCodeInputView.textField) {
        [_pwInputView.textField becomeFirstResponder];
    }
    else if(textField == _pwInputView.textField){
        NSLog(@"注册");
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
