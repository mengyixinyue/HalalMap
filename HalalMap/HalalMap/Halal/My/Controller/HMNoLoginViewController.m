//
//  HMNoLoginViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMNoLoginViewController.h"
#import "HMLoginViewController.h"
#import "HMRegisterViewController.h"

@interface HMNoLoginViewController ()

@end

@implementation HMNoLoginViewController
{
    __weak IBOutlet UIImageView *_headerImageView;
    __weak IBOutlet UILabel *_noLoginLabel;
    __weak IBOutlet UIButton *_registerBtn;
    __weak IBOutlet UIButton *_loginBtn;
    __weak IBOutlet UILabel *_tipsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _headerImageView.layer.cornerRadius = 45.0f;
    _headerImageView.layer.borderColor = HMBorderColor.CGColor;
    _headerImageView.layer.borderWidth = 0.5f;
    
    _noLoginLabel.font = [HMFontHelper fontOfSize:18.0f];
    
    _loginBtn.titleLabel.font = [HMFontHelper fontOfSize:12.0f];
    _loginBtn.layer.cornerRadius = 3.0f;
    _loginBtn.layer.borderWidth = 0.5f;
    _loginBtn.layer.borderColor = HMBorderColor.CGColor;
    
    _registerBtn.titleLabel.font = [HMFontHelper fontOfSize:12.0f];
    _registerBtn.layer.cornerRadius = 3.0f;
    _registerBtn.layer.borderWidth = 0.5f;
    _registerBtn.layer.borderColor = HMBorderColor.CGColor;
    
    _tipsLabel.font = [HMFontHelper fontOfSize:14.0f];
}


- (IBAction)loginBtnClick:(UIButton *)sender
{
    HMLoginViewController * loginVC = [[HMLoginViewController alloc] initWithNibName:NSStringFromClass([HMLoginViewController class]) bundle:[NSBundle mainBundle]];
    loginVC.loginSuccess = ^(){
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)registBtnClick:(UIButton *)sender
{
    HMRegisterViewController * registVC = [[HMRegisterViewController alloc] initWithNibName:NSStringFromClass([HMRegisterViewController class]) bundle:[NSBundle mainBundle]];
    registVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
