//
//  HMUserInfoViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMUserInfoViewController.h"
#import "HMUserFeedViewController.h"

#import "HMLoginView.h"

@interface HMUserInfoViewController ()

@end

@implementation HMUserInfoViewController
{
    HMLoginView                 * _loginView;
    HMUserFeedViewController    * _userFeedVC;
}

-(instancetype)init
{
    _userFeedVC = [HMHelper xibWithViewControllerClass:[HMUserFeedViewController class]];
    
    self = [super initWithControllers:_userFeedVC, nil];
    if (self) {
        self.segmentMiniTopInset = 0;
        self.headerHeight = 245;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInfo];
    if (self.userInfoModel.nickname && self.userInfoModel.nickname.length != 0) {
        self.navigationItem.title = self.userInfoModel.nickname;
    }
}

-(void)getUserInfo
{
    WS(weakSelf);
    [HMNetwork getRequestWithPath:HMRequestUserInfo(self.userInfoModel.user_unique_key) params:nil modelClass:[HMUserModel class] success:^(id object, HMNetPageInfo *pageInfo) {
        _userInfoModel = object;
        [weakSelf configureLoginView];
    }];
}

-(void)configureLoginView
{
    self.navigationItem.title = self.userInfoModel.nickname;

    [_loginView.headImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.avatar] placeholderImage:nil];
    _loginView.nameLabel.text = self.userInfoModel.nickname;
    _loginView.sayingLabel.text = self.userInfoModel.signature;
    _userFeedVC.user_unique_key = self.userInfoModel.user_unique_key;
}


#pragma mark - override
-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    if (_loginView == nil) {
        _loginView = [HMHelper xibWithClass:[HMLoginView class]];
    }
    return _loginView;
}

//-(void)dealloc
//{
//    [self removeObserver:self forKeyPath:@"segmentTopInset"];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
