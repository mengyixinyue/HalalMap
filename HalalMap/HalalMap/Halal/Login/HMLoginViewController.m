//
//  HMLoginViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMLoginViewController.h"
#import "YSKeyboardScrollView.h"
#import "HMInputView.h"
#import "HMOtherLoginView.h"
#import "HMRegisterViewController.h"
#import "HMFindPasswordViewController.h"

#define HMHorizonMargin      (20)
#define HMHorizonPadding     (5)
#define HMVerticalMargin     (40)
#define HMVerticalPadding    (20)

@interface HMLoginViewController ()
<
UITextFieldDelegate
>

@end

@implementation HMLoginViewController
{
    YSKeyboardScrollView    * _scrollView;
    UIView                  * _containerView;
    HMInputView             * _phoneInputView;
    HMInputView             * _pwInputView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"登录", nil);
    [self initialUI];
}

-(void)initialUI
{
    __weak typeof(self) _self = self;

    if (!_scrollView) {
        YSKeyboardScrollView * keyBoardScrollView = [[YSKeyboardScrollView alloc] init];
        [self.view addSubview:keyBoardScrollView];
        [keyBoardScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(@0);
            make.width.equalTo(_self.view);
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
            make.height.equalTo(@44);
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
            make.top.equalTo(_phoneInputView.mas_bottom).offset(HMVerticalPadding);
            make.height.equalTo(@44);
        }];
        _pwInputView.secureTextEntry = YES;
    }
    
    UIButton * forgetPWBtn = [UIButton buttonWithTitle:NSLocalizedString(@"忘记密码？", nil)
                                                 image:nil
                                            titleColor:HMMainColor
                                                target:self
                                                action:@selector(forgetPasssWordBtnCLick)];
    forgetPWBtn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    [_containerView addSubview:forgetPWBtn];
    [forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.top.equalTo(_pwInputView.mas_bottom).with.offset(HMVerticalPadding);
        make.width.mas_equalTo(80);
    }];
    
     UIButton * loginBtn = [UIButton buttonWithTitle:NSLocalizedString(@"登录", nil)
                                            bgImage:nil
                                         titleColor:HMMainColor
                                             target:self
                                             action:@selector(loginBtnClick)];
    loginBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    [_containerView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView).with.offset(HMHorizonMargin);
        make.right.equalTo(_containerView).with.offset(-HMHorizonMargin);
        make.top.equalTo(forgetPWBtn.mas_bottom).with.offset(HMVerticalPadding);
        make.height.mas_equalTo(44);
    }];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:COLOR_WITH_RGB(230, 230, 230) size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    
    
    HMOtherLoginView * otherLoginView  = [[HMOtherLoginView alloc] init];
    [_containerView addSubview:otherLoginView];
    [otherLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_containerView);
        make.top.equalTo(loginBtn.mas_bottom).with.offset(80);
    }];
    
    NSString * str = NSLocalizedString(@"没有账号？注册 或 以游客身份访问", nil);
    NSRange registerRange = [str rangeOfString:NSLocalizedString(@"注册", nil)];
    NSRange touristLoginRange = [str rangeOfString:NSLocalizedString(@"以游客身份访问", nil)];
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
    one.font = [HMFontHelper fontOfSize:16.0f];
    [one addAttribute:NSForegroundColorAttributeName value:HMBlackColor range:[str rangeOfString:str]];
    [one addAttribute:NSForegroundColorAttributeName value:HMMainColor range:registerRange];
    [one addAttribute:NSForegroundColorAttributeName value:HMMainColor range:touristLoginRange];

    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
    border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
    
    YYTextHighlight *registerHighlight = [YYTextHighlight new];
    [registerHighlight setBorder:border];
    registerHighlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"注册");
        [_self gotoRegistVC];
    };
    [one setTextHighlight:registerHighlight range:registerRange];
    
    YYTextHighlight * touristLoginHighlight = [YYTextHighlight new];
    [touristLoginHighlight setBorder:border];
    touristLoginHighlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"游客身份访问");
    };
    [one setTextHighlight:touristLoginHighlight range:touristLoginRange];
    
    YYLabel * registerLabel = [YYLabel new];
    registerLabel.width = self.view.width;
    registerLabel.attributedText = one;
    registerLabel.numberOfLines = 0;
    registerLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self.view addSubview:registerLabel];

    CGSize size = [str sizeAutoFitIOS7WithFont:one.font];
    registerLabel.frame = CGRectMake(20, SCREEN_HEIGHT_NONAV - 20 - size.height, size.width, size.height);

    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(registerLabel.mas_top).with.offset(-5);
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_scrollView);
        make.width.equalTo(_self.view);
        make.bottom.mas_equalTo(otherLoginView.mas_bottom).priorityLow();
        make.height.mas_greaterThanOrEqualTo(registerLabel.top);
    }];
}

-(void)gotoRegistVC
{
    NSArray * vcs = self.navigationController.viewControllers;
    for (UIViewController * vc in vcs) {
        if ([vc isKindOfClass:[HMRegisterViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    HMRegisterViewController * loginVC = [[HMRegisterViewController alloc] initWithNibName:NSStringFromClass([HMRegisterViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginVC animated:YES];

}

-(void)forgetPasssWordBtnCLick
{
    NSLog(@"忘记密码");
    HMFindPasswordViewController * findPWVC = [[HMFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPWVC animated:YES];
}

-(void)loginBtnClick
{
    NSLog(@"登录");
    [self.view endEditing:YES];
    
    NSString * phoneStr = _phoneInputView.textField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGULAR_PHONE];
    BOOL isValid = [predicate evaluateWithObject:phoneStr];
    if (!isValid) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手机号输入错误，请输入正确的手机号", nil)];
        return;
    }
    
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
                                   HMRunDataShare.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
                                   [HMRunDataShare userInfoSynchronize];
                                   NSLog(@"%@", [HMRunData sharedHMRunData]);
                                   [self loginSucces];
                               }
                           }
                           failure:^(HMNetResponse *response, NSString *errorMsg) {
                               [SVProgressHUD showErrorWithStatus:errorMsg];
                           }];
}

-(void)secureTextEntyBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"是否明文输入");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneInputView.textField) {
        [_pwInputView.textField becomeFirstResponder];
    }
    else if (textField == _pwInputView.textField) {
        [self.view endEditing:YES];
        NSLog(@"登录");
        [self loginBtnClick];
    }
    return YES;
}

-(void)setIsShowBackItem:(BOOL)isShowBackItem
{
    if (isShowBackItem) {
        [self setDefaultLeftBackItemWhenPresentViewControll];
    }
}

+(void)loginWithSuccess:(loginSuccessBlock)success inViewController:(UIViewController*)viewController
{
     [HMLoginViewController login:success inViewController:viewController];
}


+(void)login:(loginSuccessBlock)success inViewController:(UIViewController*)viewController
{
    
    HMLoginViewController *vc = [[HMLoginViewController alloc] initWithNibName:@"HMLoginViewController" bundle:nil];
    vc.isShowBackItem = YES;
    vc.loginSuccess = success;
    HMBaseNavigationController *nav = [[HMBaseNavigationController alloc] initWithRootViewController:vc];
    [viewController presentViewController:nav animated:YES completion:nil];
}

-(void)loginSucces
{
    HM_POST_MSG(NotificationLoginSuccess);
    if (self.loginSuccess) {
        if (self==[self.navigationController.viewControllers objectAtIndex:0])
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.loginSuccess();
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
