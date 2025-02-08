//
//  HMChangePasswordViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/24.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMChangePasswordViewController.h"
#import "YSKeyboardScrollView.h"
#import "HMInputView.h"

@interface HMChangePasswordViewController ()
<
UITextFieldDelegate
>
@end

@implementation HMChangePasswordViewController
{
    __weak IBOutlet UIView *_scrollViewAchorView;
    
    __weak IBOutlet YSKeyboardScrollView *_scrollView;
    __weak IBOutlet UIView *_contrainView;
    __weak IBOutlet NSLayoutConstraint *_containerViewHeightConstraint;
    
    __weak IBOutlet HMInputView *_oldPWInputView;
    __weak IBOutlet HMInputView *_newPWInputView;
    __weak IBOutlet HMInputView *_againNewPWInputView;
    UIButton * _changeBtn;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    self.navigationItem.title = NSLocalizedString(@"修改密码", nil);
}

-(void)initialUI
{
    _oldPWInputView.textField.returnKeyType = UIReturnKeyGo;
    _oldPWInputView.textField.delegate = self;
    _oldPWInputView.secureTextEntry = YES;
    [_oldPWInputView setTitle:NSLocalizedString(@"原密码       ", nil)];
    [_oldPWInputView setPlaceholder:NSLocalizedString(@"请输入原密码", nil)];
    
    _newPWInputView.textField.returnKeyType = UIReturnKeyGo;
    _newPWInputView.textField.delegate = self;
    _newPWInputView.secureTextEntry = YES;
    [_newPWInputView setTitle:NSLocalizedString(@"新密码       ", nil)];
    [_newPWInputView setPlaceholder:NSLocalizedString(@"请输入新密码", nil)];
    
    _againNewPWInputView.textField.returnKeyType = UIReturnKeyGo;
    _againNewPWInputView.textField.delegate = self;
    _againNewPWInputView.secureTextEntry = YES;
    [_againNewPWInputView setTitle:NSLocalizedString(@"确认新密码", nil)];
    [_againNewPWInputView setPlaceholder:NSLocalizedString(@"请再次输入新密码", nil)];
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn addTarget:self action:@selector(changePWBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setTitle:NSLocalizedString(@"修改密码", nil) forState:UIControlStateNormal];
        [_changeBtn setTitleColor:HMMainColor forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
        [_contrainView addSubview:_changeBtn];
        
        _changeBtn.layer.borderColor = HMBorderColor.CGColor;
        _changeBtn.layer.borderWidth = 0.5f;
        _changeBtn.layer.cornerRadius = 8;
        _changeBtn.clipsToBounds = YES;
        _changeBtn.layer.shouldRasterize = YES;
        _changeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _changeBtn.bounds = [UIScreen mainScreen].bounds;
        
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(_againNewPWInputView.mas_bottom).offset(50);
            make.height.mas_equalTo(44);
        }];
    }
//    [_changeBtn setBackgroundColor:HMGrayColor forState:UIControlStateNormal];

    _containerViewHeightConstraint.constant =  _changeBtn.bottom > _scrollView.height ? (_changeBtn.bottom + 20) : (_scrollView.height + 1);
    [self updateViewConstraints];
}

#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _oldPWInputView.textField) {
        [_newPWInputView.textField becomeFirstResponder];
    }
    else if (textField == _newPWInputView.textField)
    {
        [_againNewPWInputView.textField becomeFirstResponder];
    }
    else{
//        [self findPWBtnClick];
    }
    return YES;
}

-(void)changePWBtn:(UIButton *)btn
{
    if (_oldPWInputView.textField.text == nil || _oldPWInputView.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请输入原密码", nil)];
        return;
    }
    else if (_newPWInputView.textField.text == nil || _newPWInputView.textField.text.length == 0 || _againNewPWInputView.textField.text == nil || _againNewPWInputView.textField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请输入新密码", nil)];
        return;
    }
    if (![_newPWInputView.textField.text isEqualToString:_againNewPWInputView.textField.text]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请确认密码是否一致", nil)];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"修改中...", nil)];
    NSDictionary * params = @{
                              @"password" : _oldPWInputView.textField.text,//原密码，为6到18位字母或数字
                              @"new_password" : _newPWInputView.textField.text,//新密码，6到18位字母或数字
                              @"new_password_again" : _againNewPWInputView.textField.text//重复新密码，6到18位字母或数字
                              };
    [HMNetwork postRequestWithPath:HMRequestChangePassword params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"修改成功", nil)];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0f];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

-(void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
