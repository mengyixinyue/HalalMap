//
//  HMMyViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMMyViewController.h"
#import "HMMyLoginViewController.h"
#import "HMNoLoginViewController.h"
#import "HMSettingViewController.h"

@interface HMMyViewController ()


@end

@implementation HMMyViewController
{
    HMMyLoginViewController * _myLoginVC;
    HMNoLoginViewController * _noLoginVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    
    [self addBarButtonItemWithImageName:@"setting"
                                  title:nil
                                 action:@selector(setting)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:nil
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];

    _myLoginVC = [[HMMyLoginViewController alloc] init];
    
    _noLoginVC = [HMHelper xibWithViewControllerClass:[HMNoLoginViewController class]];
    
    
    if ([HMRunData isLogin]) {
        _myLoginVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:_myLoginVC.view];
        [self addChildViewController:_myLoginVC];
    }
    else{
        _noLoginVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:_noLoginVC.view];
        [self addChildViewController:_noLoginVC];
    }

    HM_BIND_MSG(NotificationLoginSuccess, @selector(loginSuccess));
    HM_BIND_MSG(NotificationLogOut, @selector(logout));
    
}

-(void)loginSuccess
{
    [_noLoginVC removeFromParentViewController];
    [_noLoginVC.view removeFromSuperview];
    
    _myLoginVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:_myLoginVC.view];
    [self addChildViewController:_myLoginVC];
}

-(void)logout
{
    [_myLoginVC removeFromParentViewController];
    [_myLoginVC.view removeFromSuperview];
    
    _noLoginVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:_noLoginVC.view];
    [self addChildViewController:_noLoginVC];
}


-(void)setting
{
    NSLog(@"设置");
    HMSettingViewController * settingVC = [HMHelper xibWithViewControllerClass:[HMSettingViewController class]];
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
