//
//  HMLoginViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMMyLoginViewController.h"
#import "HMRegisterViewController.h"
#import "HMEditPersonalInfoViewController.h"
#import "HMPOIDetailViewController.h"
#import "HMMyCollectPOIViewController.h"//我收藏的餐厅
#import "HMMyFeedViewController.h"//我晒过的美食

#import "HMLoginView.h"

@interface HMMyLoginViewController ()


@end

@implementation HMMyLoginViewController
{
    HMLoginView     * _loginView;
    HMMyFeedViewController * _myFeedVC;
    HMMyCollectPOIViewController * _myCollectionVC;
}

-(instancetype)init
{
    _myFeedVC = [HMHelper xibWithViewControllerClass:[HMMyFeedViewController class]];
    _myCollectionVC = [HMHelper xibWithViewControllerClass:[HMMyCollectPOIViewController class]];
    
    self = [super initWithControllers:_myFeedVC,_myCollectionVC, nil];
    if (self) {
        // your code
        self.segmentMiniTopInset = 0;
        self.headerHeight = 245;
    }
    
    return self;
}

#pragma mark - override

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    if (_loginView == nil) {
        _loginView = [HMHelper xibWithClass:[HMLoginView class]];
    }
    return _loginView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_loginView.headImageView sd_setImageWithURL:[NSURL URLWithString:HMRunDataShare.userModel.avatar] placeholderImage:nil];
    _loginView.nameLabel.text = HMRunDataShare.userModel.nickname;
    _loginView.sayingLabel.text = HMRunDataShare.userModel.signature;
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
